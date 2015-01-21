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

CoverBackground {

    BackgroundItem {
        anchors.fill: parent

        Image {
            id: coverBgImage
            height: parent.height - Theme.paddingLarge * 2
            width: parent.width - Theme.paddingLarge * 2
            x: Theme.paddingLarge
            y: Theme.paddingLarge
            fillMode: Image.PreserveAspectFit
            source: "../images/phototools_coverbg.png"
            opacity: 0.2
            horizontalAlignment: Image.AlignHCenter
            verticalAlignment: Image.AlignVCenter
        }
    }

    Rectangle {
        anchors.fill: parent
        anchors.margins: Theme.paddingSmall * 2
        color: "transparent"

        Column {
            spacing: Theme.paddingLarge
            width: parent.width

            Label {
                id: appTitle
                anchors.horizontalCenter: parent.horizontalCenter
                text: ptWindow.appName
                color: Theme.highlightColor
            }

            Label {
                id: currentCamera
                text: qsTr("Current camera:\n") + ptWindow.currentCameraManufacturer + " " + ptWindow.currentCameraModel
                font.pixelSize: Theme.fontSizeExtraSmall
            }
        }
    }
}


