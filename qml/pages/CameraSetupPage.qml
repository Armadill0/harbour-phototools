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
import "../localdb.js" as DB


Page {
    id: cameraSetupPage
    allowedOrientations: Orientation.All

    function reloadCameras() {
        var cameraList = DB.readCameras(null);
        cameraListModel.clear()

        for (var i = 0; i < cameraList.rows.length; i++) {
            cameraListModel.append({    "id": cameraList.rows.item(i).ID,
                                       "cameraManufacturer": cameraList.rows.item(i).Manufacturer,
                                       "cameraModel": cameraList.rows.item(i).Model,
                                       "cameraSensorResolution": cameraList.rows.item(i).Resolution,
                                       "cameraSensorCrop": cameraList.rows.item(i).Crop,
                                       "cameraSensorFormat": cameraList.rows.item(i).Format,
                                       "cameraStatus": cameraList.rows.item(i).Status})
        }
    }

    function setDefaultCamera(id) {
        DB.updateSetting("defaultCamera", id)

        ptWindow.defaultCameraIndex = id

        reloadCameras()
    }

    onStatusChanged: {
        switch(status) {
        case PageStatus.Activating:
            // reload cameras if page is activating
            reloadCameras()

            break
        }
    }

    ListModel {
        id: cameraListModel
    }

    Component {
        id: cameraComponent

        ListItem {
            id: cameraListItem
            width: parent.width
            contentHeight: menuOpen ? (listContextMenu.height + cameraDetails.height) : cameraDetails.height

            property Item listContextMenu
            property bool menuOpen: listContextMenu != null && listContextMenu.parent === cameraListItem

            // function to delete camera via the remorseitem
            function deleteCamera() {
                cameraRemorse.execute(cameraListItem, qsTr("Deleting") + " '" + cameraManufacturer + " " + cameraModel + "'", function() {
                    var deleteCam = DB.removeCamera(id)

                    // if camera was successfully removed from database, remove it from camera list
                    if (deleteCam !== "ERROR")
                        cameraListModel.remove(index)
                    else
                        console.log("ERROR: An error occured while deleting camera from database!")
                }, 5000)
            }

            // remorse item for all remorse actions
            RemorseItem {
                id: cameraRemorse
            }

            Column {
                id: cameraDetails
                width: parent.width - 2 * Theme.paddingLarge
                x: Theme.paddingLarge

                Label {
                    id: cameraName
                    width: parent.width

                    text: cameraManufacturer + " " + cameraModel
                }

                Label {
                    id: cameraProperties
                    width: parent.width

                    property double sensorX: Math.round(ptWindow.calcSensorX(cameraSensorFormat, cameraSensorCrop) * 100 ) / 100
                    property double sensorY: Math.round(ptWindow.calcSensorY(cameraSensorFormat, cameraSensorCrop) * 100 ) / 100

                    text: qsTr("Resolution") + ": " + cameraSensorResolution + "Mpix, " +
                          qsTr("Crop") + ": " + ptWindow.cropFactorsDouble[cameraSensorCrop] + ", " +
                          qsTr("Sensor") + ": " + sensorX + "x" + sensorY + "mm, " +
                          qsTr("Format") + ": " + ptWindow.sensorFormatsX[cameraSensorFormat] + ":" + ptWindow.sensorFormatsY[cameraSensorFormat]
                    color: Theme.secondaryHighlightColor
                    truncationMode: TruncationMode.Elide
                }
            }

            // defines the context menu used at each list item
            Component {
                id: contextMenuComponent
                ContextMenu {
                    id: listMenu

                    MenuItem {
                        //: context menu item to edit a camera
                        text: qsTr("Edit")
                        onClicked: {
                            // close contextmenu
                            listContextMenu.hide()
                            pageStack.push("CameraEditPage.qml", {"cameraId": id})
                        }
                    }

                    MenuItem {
                        //: context menu item to edit a camera
                        text: qsTr("Set as default camera")
                        visible: id !== ptWindow.defaultCameraIndex ? true : false
                        onClicked: {
                            // close contextmenu
                            listContextMenu.hide()
                            setDefaultCamera(id)
                        }
                    }

                    MenuItem {
                        //: context menu item to delete a camera
                        text: qsTr("Delete")
                        visible: id !== ptWindow.defaultCameraIndex ? true : false
                        onClicked: {
                            // close contextmenu
                            listContextMenu.hide()
                            deleteCamera()
                        }
                    }
                }
            }

            // show context menu
            onPressAndHold: {
                if (!listContextMenu) {
                    listContextMenu = contextMenuComponent.createObject(cameraList)
                }
                listContextMenu.show(cameraListItem)
            }

            onClicked: {
                ptWindow.updateCurrentCamera(id)

                pageStack.navigateBack()
            }
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
            title: qsTr("Select camera") + " - " + ptWindow.appName
        }

        delegate: cameraComponent
    }
}
