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
    id: depthOfFieldPage
    allowedOrientations: Orientation.All

    function readCameras() {
        var cameraList = DB.readCameras(null);
        cameraListModel.clear()

        for (var i = 0; i < cameraList.rows.length; i++) {
            cameraListModel.append({    "id": cameraList.rows.item(i).ID,
                                        "cameraManufaturerProperty": cameraList.rows.item(i).Manufacturer,
                                        "cameraModelProperty": cameraList.rows.item(i).Model,
                                        "cameraSensorResolutionProperty": cameraList.rows.item(i).Resolution,
                                        "cameraSensorCropProperty": cameraList.rows.item(i).Crop,
                                        "cameraSensorFormatProperty": cameraList.rows.item(i).Format,
                                        "cameraStatusProperty": cameraList.rows.item(i).Status})
        }
    }

    ListModel {
        id: cameraListModel
    }

    Component.onCompleted: {
        readCameras()
    }

    Component {
        id: cameraComponent

        Column {
            width: parent.width - 2 * Theme.paddingLarge
            x: Theme.paddingLarge

            Label {
                id: cameraName
                width: parent.width

                text: cameraManufaturerProperty + " " + cameraModelProperty
            }

            Label {
                id: cameraProperties
                width: parent.width

                text: qsTr("Sensor") + ": " + 36 / photoToolsWindow.dopCropFactorsDouble[cameraSensorCropProperty] + "mm, " +
                      qsTr("Resolution") + ": " + cameraSensorResolutionProperty + "Mpix, " +
                      qsTr("Crop") + ": " + photoToolsWindow.dopCropFactorsDouble[cameraSensorCropProperty] + ", " +
                      qsTr("Format") + ": " + photoToolsWindow.dopSensorFormatRelations[cameraSensorFormatProperty]
                color: Theme.secondaryHighlightColor
                truncationMode: TruncationMode.Elide
            }
        }
    }

    SilicaListView {
        id: cameraList
        anchors.fill: parent

        VerticalScrollDecorator { }

        model: cameraListModel

        header: PageHeader {
            title: qsTr("Camera Setup") + " - PhotoTools"
        }

        delegate: cameraComponent
    }
}
