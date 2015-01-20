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

    // variables for current camera specifications
    property int currentCameraIndex: ptWindow.currentCameraIndex
    property double currentCameraResolution: ptWindow.currentCameraResolution
    property int currentCameraCrop: ptWindow.currentCameraCrop
    property int currentCameraFormat: ptWindow.currentCameraFormat

    /*  variables to store all main values
        global default unit for distances is mm (millimeter) */
    // camera related
    property double sensorFormatProduct: ptWindow.sensorFormatsX[currentCameraFormat] * ptWindow.sensorFormatsY[currentCameraFormat]
    property double sensorFormatHorizontal: ptWindow.sensorFormatsX[currentCameraFormat]
    property double cropFactor: ptWindow.cropFactorsDouble[currentCameraCrop]
    property double sensorResolution: parseFloat(currentCameraResolution) * 1000000

    // lens related
    property double aperture: ptWindow.aperturesDouble[dopAperture.value]
    property double focalLength: parseFloat(dopFocalLength.text)
    property double objectDistance: parseFloat(dopObjectDistance.text) * 1000

    // variables to calculate the depth of field
    property double sensorSizeX: ptWindow.calcSensorX(currentCameraFormat, currentCameraCrop)
    property double circleOfConfusionAbsolute: sensorSizeX / (Math.sqrt(sensorResolution / sensorFormatProduct) * sensorFormatHorizontal) * 2
    //property double circleOfConfusionAbsolute: 0.03
    property double hyperfocalDistance: Math.pow(focalLength, 2) / (aperture * circleOfConfusionAbsolute) + focalLength
    property double nearPoint: objectDistance / ((objectDistance - focalLength) / (hyperfocalDistance - focalLength) + 1)
    property double farPoint: objectDistance / ((focalLength - objectDistance)/(hyperfocalDistance - focalLength) + 1)
    property double depthOfField: farPoint - nearPoint

    function readCameras() {
        var cameraList = DB.readCameras(null);
        cameraListModel.clear()

        for (var i = 0; i < cameraList.rows.length; i++) {
            cameraListModel.append({   "id": cameraList.rows.item(i).ID,
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

    SilicaFlickable {
        anchors.fill: parent
        contentHeight: column.height

        VerticalScrollDecorator { }

        Column {
            id: column

            width: parent.width
            spacing: Theme.paddingSmall

            PageHeader {
                //: header of depth of field page
                title: qsTr("Depth of field") + " - " + ptWindow.appName
            }

            SectionHeader {
                //: start of result section
                text: qsTr("Results")
            }

            Row {
                width: parent.width - 2 * Theme.paddingLarge
                x: Theme.paddingLarge

                Rectangle {
                    id: displayDopDepthOfField
                    width: depthOfField / (depthOfField + nearPoint) * parent.width
                    height: displayDopNearPointLabel.height
                    color: Theme.highlightColor

                    Rectangle {
                        id: displayDopObjectDistance
                        width: 2
                        height: displayDopNearPointLabel.height
                        anchors.right: parent.right
                        anchors.rightMargin: (objectDistance - nearPoint) / depthOfField * parent.width -1
                        color: "red"
                    }
                }

                Rectangle {
                    id: displayDopNearPoint
                    width: nearPoint / (depthOfField + nearPoint) * parent.width
                    height: displayDopNearPointLabel.height
                    color: Theme.secondaryColor

                    Label {
                        id: displayDopNearPointLabel
                        anchors.right: parent.right
                        anchors.rightMargin: Theme.paddingSmall
                        text: dopNearPoint.text
                        horizontalAlignment: Text.AlignRight
                        color: "black"
                    }
                }

                ContextMenu {

                    MenuItem {
                        //: explanation of visual presentation of the depth of field
                        text: qsTr("Explanation")

                        onClicked: {

                        }
                    }
                }
            }

            Row {
                width: parent.width - Theme.paddingLarge

                TextField {
                    id: dopNearPoint
                    width: parent.width * 0.3
                    //: start of depth of field from sight of the camera
                    label: qsTr("Near point")
                    readOnly: true
                    text: Math.round(nearPoint / 1000 * 1000) / 1000 + "m"
                }

                TextField {
                    id: dopFarPoint
                    width: parent.width * 0.3
                    //: end of depth of field from sight of the camera
                    label: qsTr("Far point")
                    readOnly: true
                    text: objectDistance < hyperfocalDistance ? Math.round(farPoint / 1000 * 1000) / 1000 + "m" : "∞"
                }

                TextField {
                    id: dopDepthOfField
                    width: parent.width * 0.4
                    //: size of depth of field from near point till far point
                    label: qsTr("Depth of field")
                    readOnly: true
                    text: objectDistance < hyperfocalDistance ? Math.round(depthOfField / 10 * 100) / 100 + "cm" : "∞"
                }
            }

            Row {
                width: parent.width - Theme.paddingLarge

                TextField {
                    id: dopCircleOfConfusionAbsolute
                    width: parent.width / 2
                    //: definition of sharpness of a point of the focused object
                    label: qsTr("Circle of confusion")
                    readOnly: true
                    text: Math.round(circleOfConfusionAbsolute * 10000) / 10000 + "mm"
                }

                TextField {
                    id: dopHyperfocalDistance
                    width: parent.width / 2
                    //:
                    label: qsTr("Hyperfocale distance")
                    readOnly: true
                    text: Math.round(hyperfocalDistance / 1000 * 100) / 100 + "m"
                }
            }

            SectionHeader {
                //: start of the lens section
                text: qsTr("Lens data")
            }

            Slider {
                id: dopAperture
                width: parent.width
                //: aperture of the used lens
                label: qsTr("Aperture")

                minimumValue: 0
                maximumValue: ptWindow.aperturesDouble.length - 1
                value: 9
                stepSize: 1
                valueText: "f/" + ptWindow.aperturesDouble[value]
            }

            Row {
                width: parent.width

                TextField {
                    id: dopFocalLength
                    width: parent.width * 0.47
                    //: focal length of the used lens in millimeter
                    label: qsTr("Focal length (mm)")
                    placeholderText: label
                    validator: DoubleValidator {
                        bottom: 0
                        top: 9999
                    }
                    inputMethodHints: Qt.ImhFormattedNumbersOnly
                    text: "50"
                }

                TextField {
                    id: dopObjectDistance
                    width: parent.width * 0.53
                    //: distance to the focused object in meter
                    label: qsTr("Object distance (m)")
                    placeholderText: label
                    validator: DoubleValidator {
                        bottom: 0
                        top: 9999
                    }
                    inputMethodHints: Qt.ImhFormattedNumbersOnly
                    text: "1.2"
                }
            }

            SectionHeader {
                //: start of the camera section
                text: qsTr("Camera data")
            }

            ComboBox {
                id: dopCamera

                label: qsTr("Select camera")

                menu: ContextMenu {
                    Repeater {
                        model: cameraListModel
                        MenuItem {
                            text: cameraManufaturer + " " + cameraModel
                        }
                    }
                }
                description: "Resolution: " + currentCameraResolution + "Mpix, " +
                             "Crop: " + ptWindow.cropFactorsDouble[currentCameraCrop] + "(" + Math.round(sensorSizeX * 100) / 100 + "mm), " +
                             "Format: " + ptWindow.sensorFormatsX[currentCameraFormat] + ":" + ptWindow.sensorFormatsY[currentCameraFormat]
            }
        }
    }
}
