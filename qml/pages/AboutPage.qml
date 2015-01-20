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
    id: aboutPage
    allowedOrientations: Orientation.All

    SilicaFlickable {
        id: aboutPhotoTools
        anchors.fill: parent
        contentHeight: aboutRectangle.height

        VerticalScrollDecorator { flickable: aboutPhotoTools }

        Column {
            id: aboutRectangle
            anchors.horizontalCenter: parent.horizontalCenter
            width: parent.width
            spacing: Theme.paddingSmall

            PageHeader {
                //: headline of application information page
                title: qsTr("About") + " - " + ptWindow.appName
            }

            Image {
                source: "../images/harbour-phototools.png"
                width: parent.width
                fillMode: Image.PreserveAspectFit
                horizontalAlignment: Image.AlignHCenter
            }

            Label {
                text: ptWindow.appName + " " + Qt.application.version
                horizontalAlignment: Text.Center
                width: parent.width - Theme.paddingLarge * 2
                anchors.horizontalCenter: parent.horizontalCenter
            }

            SectionHeader {
                //: headline for application description
                text: qsTr("Description")
            }

            Label {
                //: application description
                text: qsTr("A collection of useful tools for daily photography.")
                width: parent.width - Theme.paddingLarge * 2
                anchors.horizontalCenter: parent.horizontalCenter
                wrapMode: Text.WordWrap
                font.pixelSize: Theme.fontSizeSmall
            }

            SectionHeader {
                //: headline for application licensing information
                text: qsTr("Licensing")
            }

            Label {
                //: Copyright and license information
                text: qsTr("Copyright © by") + " Thomas Amler\n" + qsTr("License") + ": GPL v3"
                width: parent.width - Theme.paddingLarge * 2
                anchors.horizontalCenter: parent.horizontalCenter
                font.pixelSize: Theme.fontSizeSmall
            }

            SectionHeader {
                //: headline for application project information
                text: qsTr("Project information")
                font.pixelSize: Theme.fontSizeSmall
            }

            Label {
                textFormat: Text.RichText;
                text: "<style>a:link { color: " + Theme.highlightColor + "; }</style><a href=\"https://github.com/Armadill0/harbour-phototools\">https://github.com/Armadill0/harbour-phototools</a>"
                width: parent.width - Theme.paddingLarge * 2
                anchors.horizontalCenter: parent.horizontalCenter
                font.pixelSize: Theme.fontSizeTiny

                onLinkActivated: {
                    Qt.openUrlExternally(link)
                }
            }
        }
    }
}
