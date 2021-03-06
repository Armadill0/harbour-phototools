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
    id: depthOfFieldPage
    allowedOrientations: Orientation.All

    // variables for current camera specifications
    property int currentCameraIndex: ptWindow.currentCameraIndex
    property double currentCameraResolution: ptWindow.currentCameraResolution
    property int currentCameraCrop: ptWindow.currentCameraCrop
    property int currentCameraFormat: ptWindow.currentCameraFormat

    /*  variables to store all main values
        GLOBAL UNIT FOR DISTANCES IS MILLIMETER (mm) */
    // camera related
    property double sensorFormatProduct: ptWindow.sensorFormatsX[currentCameraFormat] * ptWindow.sensorFormatsY[currentCameraFormat]
    property double sensorFormatHorizontal: ptWindow.sensorFormatsX[currentCameraFormat]
    property double cropFactor: ptWindow.cropFactorsDouble[currentCameraCrop]
    property double sensorResolution: currentCameraResolution * 1000000
    property int cocMultiplicator: dopCocMultiplicator.value

    // lens related
    property double aperture: ptWindow.aperturesDouble[dopAperture.value]
    property double focalLength: parseFloat(dopFocalLength.text.replace(',', '.'))
    property double objectDistance: parseFloat(dopObjectDistance.text.replace(',', '.')) * 1000

    // variables to calculate the depth of field
    property double sensorSizeX: ptWindow.calcSensorX(currentCameraFormat, currentCameraCrop)
    property double circleOfConfusionAbsolute: sensorSizeX / (Math.sqrt(sensorResolution / sensorFormatProduct) * sensorFormatHorizontal) * cocMultiplicator
    property double hyperfocalDistance: Math.pow(focalLength, 2) / (aperture * circleOfConfusionAbsolute) + focalLength
    property double nearPoint: objectDistance / ((objectDistance - focalLength) / (hyperfocalDistance - focalLength) + 1)
    property double farPoint: objectDistance / ((focalLength - objectDistance)/(hyperfocalDistance - focalLength) + 1)
    property double depthOfField: farPoint - nearPoint

    property bool showResults: dopFocalLength.acceptableInput && dopObjectDistance.acceptableInput

    function readCameras() {
        var cameraList = DB.readCameras(null);
        cameraListModel.clear()

        for (var i = 0; i < cameraList.rows.length; i++) {
            cameraListModel.append({   "id": cameraList.rows.item(i).ID,
                                       "cameraManufacturer": cameraList.rows.item(i).Manufacturer,
                                       "cameraModel": cameraList.rows.item(i).Model,
                                       "cameraSensorResolution": cameraList.rows.item(i).Resolution,
                                       "cameraSensorCrop": cameraList.rows.item(i).Crop,
                                       "cameraSensorFormat": cameraList.rows.item(i).Format,
                                       "cameraStatus": cameraList.rows.item(i).Status})
        }
    }

    Component.onCompleted: {
        readCameras()

        for (var i = 0; i < cameraListModel.count; i++) {
            if (cameraListModel.get(i).id === ptWindow.currentCameraIndex) {
                dopCamera.currentIndex = i
                dopCamera.currentItem = dopCamera.menu.children[i]
            }
        }
    }

    ListModel {
        id: cameraListModel
    }

    SilicaFlickable {
        id: dopFlickable
        anchors.fill: parent
        contentHeight: column.height

        VerticalScrollDecorator { }

        Column {
            id: column

            width: parent.width
            spacing: Theme.paddingSmall

            PageHeader {
                //: header of depth of field page
                //% "Depth of field"
                title: qsTrId("dop-page-title") + " - " + ptWindow.appName
            }

            SectionHeader {
                //: start of result section
                //% "Results"
                text: qsTrId("results-header")
            }

            Label {
                id: dopResultError
                width: parent.width - 2 * Theme.paddingLarge
                x: Theme.paddingLarge
                //% "Fill in focal length and object distance to get results!"
                text: qsTrId("result-hint")
                color: "red"
                visible: !showResults
                wrapMode: Text.WordWrap
            }

            Row {
                width: parent.width - 2 * Theme.paddingLarge
                x: Theme.paddingLarge
                visible: showResults

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
            }

            Row {
                width: parent.width - Theme.paddingLarge
                visible: showResults

                TextField {
                    id: dopNearPoint
                    width: parent.width * 0.3
                    //: start of depth of field from sight of the camera
                    //% "Near point"
                    label: qsTrId("near-point-label")
                    readOnly: true
                    text: Math.round(nearPoint / 1000 * 1000) / 1000 + "m"
                }

                TextField {
                    id: dopFarPoint
                    width: parent.width * 0.3
                    //: end of depth of field from sight of the camera
                    //% "Far point"
                    label: qsTrId("far-point-label")
                    readOnly: true
                    text: objectDistance < hyperfocalDistance ? Math.round(farPoint / 1000 * 1000) / 1000 + "m" : "∞"
                }

                TextField {
                    id: dopDepthOfField
                    width: parent.width * 0.4
                    //: size of depth of field from near point till far point
                    //% "Depth of field"
                    label: qsTrId("dop-label")
                    readOnly: true
                    text: objectDistance < hyperfocalDistance ? Math.round(depthOfField / 10 * 100) / 100 + "cm" : "∞"
                }
            }

            Row {
                width: parent.width - Theme.paddingLarge
                visible: showResults

                TextField {
                    id: dopCircleOfConfusionAbsolute
                    width: parent.width / 2
                    //: definition of sharpness of a point of the focused object
                    //% "Circle of confusion"
                    label: qsTrId("coc-label")
                    readOnly: true
                    text: Math.round(circleOfConfusionAbsolute * 10000) / 10000 + "mm"
                }

                TextField {
                    id: dopHyperfocalDistance
                    width: parent.width / 2
                    //% "Hyperfocale distance"
                    label: qsTrId("hpd-label")
                    readOnly: true
                    text: Math.round(hyperfocalDistance / 1000 * 100) / 100 + "m"
                }
            }

            Slider {
                id: dopCocMultiplicator
                width: parent.width
                //: multiplicator for the circle of confusion
                //% "Circle of confusion multiplicator"
                label: qsTrId("coc-multiplicator-label")

                minimumValue: 1
                maximumValue: 10
                value: 5
                stepSize: 1
                valueText: value
            }

            SectionHeader {
                //: start of the lens section
                //% "Lens data"
                text: qsTrId("lens-data-header")
            }

            Slider {
                id: dopAperture
                width: parent.width
                //: aperture of the used lens
                //% "Aperture"
                label: qsTrId("aperture-label")

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
                    //% "Focal length"
                    label: qsTrId("focal-length-label") + "(mm)"
                    placeholderText: label
                    validator: DoubleValidator {
                        bottom: 0
                        top: 10000
                    }
                    inputMethodHints: Qt.ImhDigitsOnly
                    EnterKey.enabled: errorHighlight === false ? true : false
                    EnterKey.iconSource: "image://theme/icon-m-enter-next"
                    EnterKey.onClicked: dopObjectDistance.focus = true
                }

                TextField {
                    id: dopObjectDistance
                    width: parent.width * 0.53
                    //: distance to the focused object in meter
                    //% "Object distance"
                    label: qsTrId("object-distance-label") + "(m)"
                    placeholderText: label
                    validator: DoubleValidator {
                        bottom: 0
                        top: 10000
                    }
                    inputMethodHints: Qt.ImhDigitsOnly
                    EnterKey.enabled: errorHighlight === false ? true : false
                    EnterKey.iconSource: "image://theme/icon-m-enter-close"
                    EnterKey.onClicked: {
                        focus = false
                        dopFlickable.scrollToTop()
                    }
                }
            }

            SectionHeader {
                //: start of the camera section
                //% "Camera data"
                text: qsTrId("camera-data-header")
            }

            ComboBox {
                id: dopCamera

                //% "Select camera"
                label: qsTrId("select-camera-label")

                menu: ContextMenu {
                    Repeater {
                        model: cameraListModel
                        MenuItem {
                            text: cameraManufacturer + " " + cameraModel

                            onClicked: ptWindow.updateCurrentCamera(id)
                        }
                    }
                }
                //% "Resolution"
                description: qsTrId("resolution-label") + ": " + currentCameraResolution + "Mpix, " +
                             //% "Crop"
                             qsTrId("crop-label") + ": " + ptWindow.cropFactorsDouble[currentCameraCrop] + "(" + Math.round(sensorSizeX * 100) / 100 + "mm), " +
                             //% "Format"
                             qsTrId("formal-label") + ": " + ptWindow.sensorFormatsX[currentCameraFormat] + ":" + ptWindow.sensorFormatsY[currentCameraFormat]
            }
        }
    }
}
