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

    Column {
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
        }

        TextField {
            id: cameraModel
            width: parent.width
            label: qsTr("Model")
            placeholderText: label
        }

        Slider {
            id: sensorCropFactor
            width: parent.width
            //: crop factor in relation to the 35mm format
            label: qsTr("Crop factor")

            minimumValue: 0
            maximumValue: ptWindow.cropFactorsDouble.length - 1
            value: currentCameraCrop
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

                currentIndex: currentCameraFormat
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
                text: currentCameraResolution
            }
        }
    }
}
