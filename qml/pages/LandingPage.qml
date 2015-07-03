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

Page {
    id: landingPage
    allowedOrientations: Orientation.All

    SilicaFlickable {
        anchors.fill: parent
        contentHeight: landingContent.height

        VerticalScrollDecorator { }

        PushUpMenu {
            MenuItem {
                //: menu item to jump to the application information page
                //% "About"
                text: qsTrId("menu-to-about-page") + " " + ptWindow.appName
                onClicked: pageStack.push("AboutPage.qml")
            }
        }

        Column {
            id: landingContent
            width: parent.width
            spacing: Theme.paddingLarge

            PageHeader {
                //: header of start/landing page
                //% "Start"
                title: qsTrId("landing-page-title") + " - " + ptWindow.appName
            }

            SectionHeader {
                //% "Tools"
                text: qsTrId("tools-header")
            }

            Button {
                anchors.horizontalCenter: parent.horizontalCenter
                //: button to switch to depth of field page
                //% "Depth of field"
                text: qsTrId("button-to-dop-page")
                onClicked: pageStack.push("DepthOfFieldPage.qml")
            }

            Button {
                anchors.horizontalCenter: parent.horizontalCenter
                //: button to switch to camera setup page
                //% "Camera Setup"
                text: qsTrId("button-to-camerasetup-page")
                onClicked: pageStack.push("CameraSetupPage.qml")
            }

            SectionHeader {
                //% "Information"
                text: qsTrId("information-header")
            }

            Label {
                id: currentCamera
                anchors.horizontalCenter: parent.horizontalCenter
                //% "Current Camera"
                text: qsTrId("current-camera-label") + ": " + ptWindow.currentCameraManufacturer + " " + ptWindow.currentCameraModel
            }
        }
    }
}
