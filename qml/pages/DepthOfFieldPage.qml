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


Page {
    id: depthOfFieldPage
    allowedOrientations: Orientation.All

    /*  variables to store all main values
        global default unit for distances is mm (millimeter) */
    property double aperture: photoToolsWindow.dopAperturesDouble[dopAperture.value]
    property double sensorFormatProduct: photoToolsWindow.dopSensorFormatProducts[dopSensorFormat.currentIndex]
    property double sensorFormatHorizontal: photoToolsWindow.dopSensorFormatHorizontals[dopSensorFormat.currentIndex]
    property double cropFactor: photoToolsWindow.dopCropFactorsDouble[dopCropFactor.value]
    property double sensorResolution: parseFloat(dopSensorResolution.text) * 1000000
    property double focalLength: parseFloat(dopFocalLength.text)
    property double objectDistance: parseFloat(dopObjectDistance.text) * 1000

    // calculate the depth of field
    property double circleOfConfusionAbsolute: (36 / cropFactor) / (Math.sqrt(sensorResolution / sensorFormatProduct) * sensorFormatHorizontal) * 2
    //property double circleOfConfusionAbsolute: 0.03
    property double hyperfocalDistance: Math.pow(focalLength, 2) / (aperture * circleOfConfusionAbsolute) + focalLength
    property double nearPoint: objectDistance / ((objectDistance - focalLength) / (hyperfocalDistance - focalLength) + 1)
    property double farPoint: objectDistance / ((focalLength - objectDistance)/(hyperfocalDistance - focalLength) + 1)
    property double depthOfField: farPoint - nearPoint

    SilicaFlickable {
        anchors.fill: parent
        contentHeight: column.height

        VerticalScrollDecorator { }

        PushUpMenu {
            MenuItem {
                //: menu item to jump to the application information page
                text: qsTr("About") + " PhotoTools"
                onClicked: pageStack.push(Qt.resolvedUrl("AboutPage.qml"))
            }
        }

        Column {
            id: column

            width: depthOfFieldPage.width
            spacing: Theme.paddingSmall

            PageHeader {
                title: qsTr("Depth of field") + " - PhotoTools"
            }

            SectionHeader {
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
                    label: "Near point"
                    readOnly: true
                    text: Math.round(nearPoint / 1000 * 1000) / 1000 + "m"
                }

                TextField {
                    id: dopFarPoint
                    width: parent.width * 0.3
                    label: "Far point"
                    readOnly: true
                    text: objectDistance < hyperfocalDistance ? Math.round(farPoint / 1000 * 1000) / 1000 + "m" : "∞"
                }

                TextField {
                    id: dopDepthOfField
                    width: parent.width * 0.4
                    label: "Depth of field"
                    readOnly: true
                    text: objectDistance < hyperfocalDistance ? Math.round(depthOfField / 10 * 100) / 100 + "cm" : "∞"
                }
            }

            Row {
                width: parent.width - Theme.paddingLarge

                TextField {
                    id: dopCircleOfConfusionAbsolute
                    width: parent.width / 2
                    label: "Circle of confusion"
                    readOnly: true
                    text: Math.round(circleOfConfusionAbsolute * 10000) / 10000 + "mm"
                }

                TextField {
                    id: dopHyperfocalDistance
                    width: parent.width / 2
                    label: "Hyperfocale distance"
                    readOnly: true
                    text: Math.round(hyperfocalDistance / 1000 * 100) / 100 + "m"
                }
            }

            SectionHeader {
                text: qsTr("Lens data")
            }

            Slider {
                id: dopAperture
                width: parent.width
                label: qsTr("Aperture")

                minimumValue: 0
                maximumValue: photoToolsWindow.dopAperturesDouble.length - 1
                value: 9
                stepSize: 1
                valueText: "f/" + photoToolsWindow.dopAperturesDouble[value]
            }

            Row {
                width: parent.width

                TextField {
                    id: dopFocalLength
                    width: parent.width * 0.47
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
                text: qsTr("Sensor specifications")
            }

            Slider {
                id: dopCropFactor
                width: parent.width
                label: qsTr("Crop factor")

                minimumValue: 0
                maximumValue: photoToolsWindow.dopCropFactorsDouble.length - 1
                value: 2
                stepSize: 1
                valueText: photoToolsWindow.dopCropFactorsDouble[value] + "(" + Math.round(36 / photoToolsWindow.dopCropFactorsDouble[value] * 100) / 100 + "mm)"
            }

            Row {
                width: parent.width

                ComboBox {
                    id: dopSensorFormat
                    width: parent.width / 2
                    label: qsTr("Format")

                    currentIndex: 1
                    menu: ContextMenu {
                        MenuItem { text: "1:1" }
                        MenuItem { text: "3:2" }
                        MenuItem { text: "4:3" }
                    }
                }

                TextField {
                    id: dopSensorResolution
                    width: parent.width / 2
                    label: qsTr("Resolution (mpix)")
                    placeholderText: label
                    validator: DoubleValidator {
                        bottom: 0
                        top: 999
                    }
                    inputMethodHints: Qt.ImhFormattedNumbersOnly
                    text: "24"
                }
            }
        }
    }
}
