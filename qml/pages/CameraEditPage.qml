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


Dialog {
    id: cameraEditPage
    allowedOrientations: Orientation.All

    property int cameraId
    property double sensorX: Math.round(ptWindow.calcSensorX(sensorFormat.currentIndex, sensorCropFactor.value) * 100 ) / 100
    property double sensorY: Math.round(ptWindow.calcSensorY(sensorFormat.currentIndex, sensorCropFactor.value) * 100 ) / 100

    property string editCameraManufacturer: ""
    property string editCameraModel: ""
    property int editCameraCrop: 2
    property int editCameraFormat: 1
    property double editCameraResolution
    property int editCameraStatus: 1

    function loadCamera(id) {
        var editCam = DB.readCamera(cameraId)

        // check for successfully read from database
        if (editCam.rows.length === 1) {
            editCameraManufacturer = editCam.rows.item(0).Manufacturer
            editCameraModel = editCam.rows.item(0).Model
            editCameraResolution = parseFloat(editCam.rows.item(0).Resolution)
            editCameraCrop = parseInt(editCam.rows.item(0).Crop)
            editCameraFormat = parseInt(editCam.rows.item(0).Format)
            editCameraStatus = parseInt(editCam.rows.item(0).Status)
        }
        else {
            console.log("ERROR: An error occured while reading camera from database!")
        }
    }

    function writeCamera(manufacturer, model, status, resolution, crop, format) {
        var writeCam

        // check whether a new camera should be added or an existing one gets an update
        if (cameraId !== 0) {
            writeCam = DB.updateCamera(cameraId, manufacturer, model, status, resolution, crop, format)

            // update current camera to ensure the changed settings are also up to date
            if (cameraId === ptWindow.currentCameraIndex)
                ptWindow.updateCurrentCamera(cameraId)
        }
        else {
            writeCam = DB.writeCamera(manufacturer, model, status, resolution, crop, format)
        }

        if (writeCam === "ERROR")
            console.log("ERROR: An error occured while writing camera to database!")
    }

    function checkContent() {
        var contentOK = !cameraManufacturer.errorHighlight && !cameraModel.errorHighlight && !sensorResolution.errorHighlight

        cameraEditPage.canAccept = contentOK
    }

    Component.onCompleted: {
        // if cameraid has been given, load the needed camera details
        if (cameraId !== 0)
            loadCamera(cameraId)

        checkContent()
    }

    onAccepted: writeCamera(cameraManufacturer.text, cameraModel.text, 1, parseFloat(sensorResolution.text), parseInt(sensorCropFactor.value), parseInt(sensorFormat.currentIndex))


    SilicaFlickable {
        anchors.fill: parent
        contentHeight: cameraColumn.height

        VerticalScrollDecorator { }

        Column {
            id: cameraColumn
            width: parent.width
            spacing: Theme.paddingSmall

            DialogHeader {
                title: cameraId !== 0 ? qsTr("Edit camera") : qsTr("Add new camera")
                acceptText: qsTr("Save")
                cancelText: qsTr("Cancel")
            }

            TextField {
                id: cameraManufacturer
                width: parent.width
                label: qsTr("Manufacturer")
                placeholderText: label
                text: editCameraManufacturer
                validator: RegExpValidator { regExp: /^.{3,60}$/ }
                inputMethodHints: Qt.ImhNoPredictiveText
                EnterKey.enabled: errorHighlight === false ? true : false
                EnterKey.iconSource: "image://theme/icon-m-enter-next"
                EnterKey.onClicked: cameraModel.focus = true

                onErrorHighlightChanged: checkContent()
            }

            TextField {
                id: cameraModel
                width: parent.width
                label: qsTr("Model")
                placeholderText: label
                text: editCameraModel
                validator: RegExpValidator { regExp: /^.{2,60}$/ }
                inputMethodHints: Qt.ImhNoPredictiveText | Qt.ImhNoPredictiveText
                EnterKey.enabled: errorHighlight === false ? true : false
                EnterKey.iconSource: "image://theme/icon-m-enter-next"
                EnterKey.onClicked: sensorResolution.focus = true

                onErrorHighlightChanged: checkContent()
            }

            Slider {
                id: sensorCropFactor
                width: parent.width
                //: crop factor in relation to the 35mm format
                label: qsTr("Crop factor")

                minimumValue: 0
                maximumValue: ptWindow.cropFactorsDouble.length - 1
                value: editCameraCrop
                stepSize: 1
                valueText: ptWindow.cropFactorsDouble[value] + "(" + Math.round(sensorX * 100) / 100 + "mm)"
            }

            Row {
                width: parent.width

                ComboBox {
                    id: sensorFormat
                    width: parent.width / 2
                    //: aspect ratio of the sensor
                    label: qsTr("Format")

                    currentIndex: editCameraFormat
                    menu: ContextMenu {
                        MenuItem { text: "1:1" }
                        MenuItem { text: "3:2" }
                        MenuItem { text: "4:3" }
                    }
                }

                TextField {
                    id: sensorResolution
                    width: parent.width / 2
                    //: resolution of the sensor in megapixels
                    label: qsTr("Resolution (mpix)")
                    placeholderText: label
                    validator: DoubleValidator {
                        bottom: 0
                        top: 999
                    }
                    inputMethodHints: Qt.ImhFormattedNumbersOnly
                    text: editCameraResolution
                    EnterKey.enabled: errorHighlight === false ? true : false
                    EnterKey.iconSource: "image://theme/icon-m-enter-close"
                    EnterKey.onClicked: focus = false

                    onErrorHighlightChanged: checkContent()
                }
            }
        }
    }
}
