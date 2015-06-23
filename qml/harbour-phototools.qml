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

import QtQuick 2.1
import Sailfish.Silica 1.0
import "localdb.js" as DB
import "pages"

ApplicationWindow
{
    id: ptWindow

    // list of available aperture values
    property variant aperturesDouble: [1,1.1, 1.2, 1.4, 1.6, 1.8, 2, 2.2, 2.5, 2.8, 3.2, 3.5, 4, 4.5, 5.0, 5.6, 6.3, 7.1, 8, 9, 10, 11, 13, 14, 16, 18, 20, 22, 25, 29, 32, 36, 40, 45]
    // list of default crop factors
    property variant cropFactorsDouble: [
        0.3,
        0.6316,
        0.7,
        0.8,
        1,
        1.2,
        1.3,
        1.5,
        1.6,
        2,
        2.38,
        2.7,
        4,
        4.5,
        4.9,
        5.6,
        6.2,
        6.8,
        7.2,
        8,
        8.7]
    property string cropNoDescription: qsTr("No description")
    property variant cropDescriptions: [
        //: sensor format for crop 0.3
        qsTr("Large format"),
        //: sensor format for crop 0.6316
        cropNoDescription,
        //: sensor format for crop 0.7
        qsTr("Medium format"),
        //: sensor format for crop 0.8
        qsTr("S format"),
        //: sensor format for crop 1
        qsTr("35mm full frame"),
        //: sensor format for crop 1.2
        cropNoDescription,
        //: sensor format for crop 1.3
        qsTr("APS-H"),
        //: sensor format for crop 1.5
        qsTr("APS-C (Nikon, Pentax, Sigma)"),
        //: sensor format for crop 1.6
        qsTr("APS-C (Canon)"),
        //: sensor format for crop 2
        qsTr("(Micro) Four Thirds"),
        //: sensor format for crop 2.38
        qsTr("Blackmagic"),
        //: sensor format for crop 2.7
        qsTr("Digital Bolex"),
        //: sensor format for crop 4
        cropNoDescription,
        //: sensor format for crop 4.5
        cropNoDescription,
        //: sensor format for crop 4.9
        cropNoDescription,
        //: sensor format for crop 5.6
        cropNoDescription,
        //: sensor format for crop 6.2
        cropNoDescription,
        //: sensor format for crop 6.8
        cropNoDescription,
        //: sensor format for crop 7.2
        cropNoDescription,
        //: sensor format for crop 8
        cropNoDescription,
        //: sensor format for crop 8.7
        cropNoDescription]
    // list of sensor formats
    property variant sensorFormatsX: [1, 3, 4, 5]
    property variant sensorFormatsY: [1, 2, 3, 4]
    // define 35mm film default dimensions
    property double sensor35mmX: 36
    property double sensor35mmY: 24
    property double sensor35mmDiagonal: Math.sqrt(Math.pow(sensor35mmX, 2) + Math.pow(sensor35mmY, 2))

    property string appName: "PhotoTools"

    property int defaultCameraIndex
    property int currentCameraIndex

    property string currentCameraManufacturer
    property string currentCameraModel
    property double currentCameraResolution
    property int currentCameraCrop
    property int currentCameraFormat

    function calcSensorX(sensorFormat, sensorCrop) {
        var sensorXLength = sensor35mmX / cropFactorsDouble[sensorCrop]
        return sensorXLength
    }

    function calcSensorY(sensorFormat, sensorCrop) {
        var sensorXLength = sensor35mmX / cropFactorsDouble[sensorCrop]
        var sensorYLength = sensorXLength / sensorFormatsX[sensorFormat] * sensorFormatsY[sensorFormat]
        return (sensorYLength)
    }

    function updateCurrentCamera(cameraId) {
        var camera = DB.readCamera(cameraId);

        if (camera.rows.length === 1) {
            currentCameraManufacturer = camera.rows.item(0).Manufacturer
            currentCameraModel = camera.rows.item(0).Model
            currentCameraResolution = parseFloat(camera.rows.item(0).Resolution)
            currentCameraCrop = parseInt(camera.rows.item(0).Crop)
            currentCameraFormat = parseInt(camera.rows.item(0).Format)

            currentCameraIndex = cameraId
        }
    }

    initialPage: Component { LandingPage { } }
    cover: Qt.resolvedUrl("pages/CoverPage.qml")

    Component.onCompleted: {
        DB.initializeDB()

        defaultCameraIndex = parseInt(DB.readSetting("defaultCamera"))
        currentCameraIndex = defaultCameraIndex

        updateCurrentCamera(currentCameraIndex)
    }
}
