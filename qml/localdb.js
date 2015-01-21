/*
  Copyright (C) 2015 Thomas Amler
  Contact: Thomas Amler <armadillo [at] penguinfriends.org>
  All rights reserved.

  This program is free software: you can redistribute it and/or modify
  it under the terms of the GNU General Public License as published by
  the Free Software Foundation, either version 3 of the License, or
  (at your option) any later version.

  This program is distributed in the hope that it will be useful,
  but WITHOUT ANY WARRANTY; without even the implied warranty of
  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  GNU General Public License for more details.

  You should have received a copy of the GNU General Public License
  along with this program.  If not, see <http://www.gnu.org/licenses/>.
*/

.import QtQuick.LocalStorage 2.0 as LS

function getUnixTime() {
    return (new Date()).getTime()
}

function connectDB() {
    // connect to the local database
    return LS.LocalStorage.openDatabaseSync("PhotoTools", "1.0", "PhotoTools Database", 100000);
}

function initializeDB() {
    // initialize DB connection
    var db = connectDB();

    // run initialization queries
    db.transaction(
                function(tx) {
                    // delete db for clean setup
                    //tx.executeSql("DROP TABLE cameras");
                    //tx.executeSql("DROP TABLE settings");
                    // create the task and list tables
                    tx.executeSql("CREATE TABLE IF NOT EXISTS cameras (ID INTEGER PRIMARY KEY AUTOINCREMENT, Manufacturer TEXT, Model TEXT, Nickname TEXT, Status INTEGER, Resolution TEXT, Crop INTEGER, Format INTEGER)");
                    tx.executeSql("CREATE TABLE IF NOT EXISTS settings (ID INTEGER PRIMARY KEY AUTOINCREMENT, Setting TEXT UNIQUE, Value TEXT)");

                    // if cameras table are empty (first start), create default camera
                    var result = tx.executeSql("SELECT count(ID) as cID FROM cameras");
                    if (result.rows.item(0)["cID"] == 0) {
                        tx.executeSql("INSERT INTO cameras (Manufacturer, Model, Nickname, Status, Resolution, Crop, Format) VALUES ('Default', 'Camera', 'Change me', 1, '24.0', 2, 1)");
                    }

                    /****************************/
                    /*** ADD DEFAULT SETTINGS ***/
                    /****************************/
                    // if no default camera is set, set to 1
                    var result = tx.executeSql("SELECT count(Setting) as cSetting FROM settings WHERE Setting='defaultCamera'");
                    if (result.rows.item(0)["cSetting"] == 0) {
                        tx.executeSql("INSERT INTO settings (Setting, Value) VALUES ('defaultCamera', '1')");
                    }
                }
                );

    return db;
}

/*****************************************/
/*** SQL functions for CAMERA handling ***/
/*****************************************/

// select cameras
function readCameras(sort) {
    var db = connectDB();
    var orderby;
    var result;

    if (sort != null) {
        orderby = sort;
    }
    else {
        orderby = " ORDER BY Manufacturer, Model ASC";
    }

    try {
        db.transaction(function(tx) {
            result = tx.executeSql("SELECT * FROM cameras" + orderby + ";");
        });

        return result;
    } catch (sqlErr) {
        return "ERROR" + sqlErr;
    }
}

// select specific camera by ID
function readCamera(id) {
    var db = connectDB();
    var result;

    try {
        db.transaction(function(tx) {
            result = tx.executeSql("SELECT * FROM cameras WHERE ID=" + id + ";");
        });

        return result;
    } catch (sqlErr) {
        return "ERROR" + sqlErr;
    }
}

// insert new camera and return ID
function writeCamera(manufacturer, model, status, resolution, crop, format) {
    var db = connectDB();
    var result;

    try {
        db.transaction(function(tx) {
            tx.executeSql("INSERT INTO cameras (Manufacturer, Model, Status, Resolution, Crop, Format) VALUES (?, ?, ?, ?, ?, ?);", [manufacturer, model, status, resolution, crop, format]);
            tx.executeSql("COMMIT;");
            result = tx.executeSql("SELECT ID FROM cameras WHERE Manufacturer=? AND Model=?;", [manufacturer, model]);
        });

        return result.rows.item(0).ID;
    } catch (sqlErr) {
        return "ERROR";
    }
}

// update camera by ID
function updateCamera(id, manufacturer, model, status, resolution, crop, format) {
    var db = connectDB();
    var result;

    try {
        db.transaction(function(tx) {
            result = tx.executeSql("UPDATE cameras SET Manufacturer=?, Model=?, Status=?, Resolution=?, Crop=?, Format=? WHERE ID=?;", [manufacturer, model, status, resolution, crop, format, id]);
            tx.executeSql("COMMIT;");
        });

        return result.rows.count;
    } catch (sqlErr) {
       return "ERROR";
    }
}

// delete camera from database
function removeCamera(id) {
    var db = connectDB();

    db.transaction(function(tx) {
        tx.executeSql("DELETE FROM cameras WHERE ID=?;", [id]);
        tx.executeSql("COMMIT;");
    });
}

/*******************************************/
/*** SQL functions for SETTINGS handling ***/
/*******************************************/

// insert new setting and return id
function writeSetting(settingname, settingvalue) {
    var db = connectDB();
    var result;

    try {
        db.transaction(function(tx) {
            tx.executeSql("INSERT INTO settings (Setting, Value) VALUES (?, ?);", [settingname, settingvalue]);
            tx.executeSql("COMMIT;");
            result = tx.executeSql("SELECT Value FROM settings WHERE Setting=?;", [settingname]);
        });

        return result.rows.item(0).Value;
    } catch (sqlErr) {
        return "ERROR";
    }
}

// update setting
function updateSetting(settingname, settingvalue) {
    var db = connectDB();
    var result;

    try {
        db.transaction(function(tx) {
            tx.executeSql("UPDATE settings SET Value=? WHERE Setting=?;", [settingvalue, settingname]);
            tx.executeSql("COMMIT;");
            result = tx.executeSql("SELECT Value FROM settings WHERE Setting=?;", [settingname]);
        });

        return result.rows.item(0).Value;
    } catch (sqlErr) {
        return "ERROR";
    }
}


// get setting property from database
function readSetting(settingname) {
    var db = connectDB();
    var result;

    db.transaction(function(tx) {
        result = tx.executeSql("SELECT * FROM settings WHERE Setting=?;", [settingname]);
    });

    return result.rows.item(0).Value;
}

