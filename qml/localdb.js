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
                    // create the task and list tables
                    tx.executeSql("CREATE TABLE IF NOT EXISTS cameras (ID INTEGER PRIMARY KEY AUTOINCREMENT, Manufacturer TEXT, Model TEXT, Status INTEGER, Resolution TEXT, Crop INTEGER, Format INTEGER)");

                    // if lists are empty, create default list
                    var result = tx.executeSql("SELECT count(ID) as cID FROM cameras");
                    if (result.rows.item(0)["cID"] == 0) {
                        tx.executeSql("INSERT INTO cameras (Manufacturer, Model, Status, Resolution, Crop, Format) VALUES ('Default', 'Camera', 0, '24', 2, 1)");
                    }
                }
                );

    return db;
}

/*****************************************/
/*** SQL functions for CAMERA handling ***/
/*****************************************/

// select tasks and push them into the camera list
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

