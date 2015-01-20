/*
  Copyright (C) 2015 Thomas Amler
  Contact: Thomas Amler <armadillo@penguinfriends.org>
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
import "../localdb.js" as DB


Page {
    id: cameraSetupPage
    allowedOrientations: Orientation.All

    function readCameras() {
        var cameraList = DB.readCameras(null);
        cameraListModel.clear()

        for (var i = 0; i < cameraList.rows.length; i++) {
            cameraListModel.append({    "id": cameraList.rows.item(i).ID,
                                       "cameraManufaturer": cameraList.rows.item(i).Manufacturer,
                                       "cameraModel": cameraList.rows.item(i).Model,
                                       "cameraSensorResolution": cameraList.rows.item(i).Resolution,
                                       "cameraSensorCrop": cameraList.rows.item(i).Crop,
                                       "cameraSensorFormat": cameraList.rows.item(i).Format,
                                       "cameraStatus": cameraList.rows.item(i).Status})
        }
    }

    Component.onCompleted: {
        readCameras()
    }

    ListModel {
        id: cameraListModel
    }

    Component {
        id: cameraComponent

        ListItem {
            width: parent.width
            contentHeight: cameraDetails.height

            Column {
                id: cameraDetails
                width: parent.width - 2 * Theme.paddingLarge
                x: Theme.paddingLarge

                Label {
                    id: cameraName
                    width: parent.width

                    text: cameraManufaturer + " " + cameraModel
                }

                Label {
                    id: cameraProperties
                    width: parent.width

                    property double sensorX: Math.round(ptWindow.calcSensorX(cameraSensorFormat, cameraSensorCrop) * 100 ) / 100
                    property double sensorY: Math.round(ptWindow.calcSensorY(cameraSensorFormat, cameraSensorCrop) * 100 ) / 100

                    text: qsTr("Resolution") + ": " + cameraSensorResolution + "Mpix\n" +
                          qsTr("Crop") + ": " + ptWindow.cropFactorsDouble[cameraSensorCrop] + "\n" +
                          qsTr("Sensor") + ": " + sensorX + "x" + sensorY + "mm\n" +
                          qsTr("Format") + ": " + ptWindow.sensorFormatsX[cameraSensorFormat] + ":" + ptWindow.sensorFormatsY[cameraSensorFormat]
                    color: Theme.secondaryHighlightColor
                    truncationMode: TruncationMode.Elide
                    maximumLineCount: 1
                }
            }

            onClicked: cameraProperties.maximumLineCount === 1 ? cameraProperties.maximumLineCount = 10 : cameraProperties.maximumLineCount = 1
        }
    }

    SilicaListView {
        id: cameraList
        anchors.fill: parent

        VerticalScrollDecorator { }

        PullDownMenu {
            MenuItem {
                text: "Add new camera"
                onClicked: pageStack.push("CameraEditPage.qml")
            }
        }

        model: cameraListModel

        header: PageHeader {
            title: qsTr("Camera Setup") + " - " + ptWindow.appName
        }

        delegate: cameraComponent
    }
}
