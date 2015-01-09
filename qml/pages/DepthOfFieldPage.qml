/*
  Copyright (C) 2013 Jolla Ltd.
  Contact: Thomas Perl <thomas.perl@jollamobile.com>
  All rights reserved.

  You may use this file under the terms of BSD license as follows:

  Redistribution and use in source and binary forms, with or without
  modification, are permitted provided that the following conditions are met:
    * Redistributions of source code must retain the above copyright
      notice, this list of conditions and the following disclaimer.
    * Redistributions in binary form must reproduce the above copyright
      notice, this list of conditions and the following disclaimer in the
      documentation and/or other materials provided with the distribution.
    * Neither the name of the Jolla Ltd nor the
      names of its contributors may be used to endorse or promote products
      derived from this software without specific prior written permission.

  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
  ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
  WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
  DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDERS OR CONTRIBUTORS BE LIABLE FOR
  ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
  (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
  LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
  ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
  (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
  SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
*/

import QtQuick 2.0
import Sailfish.Silica 1.0


Page {
    id: page

    property double aperture: photoToolsWindow.dopAperturesDouble[dopAperture.value]
    property double sensorFormatProduct: photoToolsWindow.dopSensorFormatProducts[dopSensorFormat.currentIndex]
    property double sensorFormatHorizontal: photoToolsWindow.dopSensorFormatHorizontals[dopSensorFormat.currentIndex]
    property double cropFactor: photoToolsWindow.dopCropFactorsDouble[dopCropFactor.value]
    property double sensorResolution: parseFloat(dopSensorResolution.text) * 1000000
    property double focalLength: parseFloat(dopFocalLength.text)
    property double objectDistance: parseFloat(dopObjectDistance.text) * 1000

    property double circleOfConfusionAbsolute: (36 / cropFactor) / (Math.sqrt(sensorResolution / sensorFormatProduct) * sensorFormatHorizontal) * 2
    //property double circleOfConfusionAbsolute: 0.03
    property double hyperfocalDistance: Math.pow(focalLength, 2) / (aperture * circleOfConfusionAbsolute) + focalLength
    property double nearPoint: objectDistance / ((objectDistance - focalLength) / (hyperfocalDistance - focalLength) + 1)
    property double farPoint: objectDistance / ((focalLength - objectDistance)/(hyperfocalDistance - focalLength) + 1)
    property double depthOfField: farPoint - nearPoint

    SilicaFlickable {
        anchors.fill: parent
        contentHeight: column.height

        Column {
            id: column

            width: page.width
            spacing: Theme.paddingSmall
            PageHeader {
                title: qsTr("Calculating depth of field")
            }

            Row {
                width: parent.width

                Rectangle {
                    width: depthOfField / (depthOfField + nearPoint) * parent.width
                    height: displayDop.height
                    color: "orange"

                    Rectangle {
                        width: 1
                        height: displayDop.height
                        anchors.right: parent.right
                        anchors.rightMargin: (objectDistance - nearPoint) / depthOfField * parent.width
                        color: "red"
                    }
                }

                Rectangle {
                    width: nearPoint / (depthOfField + nearPoint) * parent.width
                    height: displayDop.height
                    color: "lightblue"

                    Label {
                        id: displayDop
                        anchors.right: parent.right
                        text: dopNearPoint.text
                        horizontalAlignment: Text.AlignRight
                        color: "black"
                    }
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
                text: qsTr("Results")
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
        }
    }
}
