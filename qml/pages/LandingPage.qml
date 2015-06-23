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
                text: qsTr("About") + " " + ptWindow.appName
                onClicked: pageStack.push("AboutPage.qml")
            }
        }

        Column {
            id: landingContent
            width: parent.width
            spacing: Theme.paddingLarge

            PageHeader {
                //: header of start/landing page
                title: qsTr("Start") + " - " + ptWindow.appName
            }

            SectionHeader {
                text: qsTr("Tools")
            }

            Button {
                anchors.horizontalCenter: parent.horizontalCenter
                //: button to switch to depth of field page
                text: qsTr("Depth of field")
                onClicked: pageStack.push("DepthOfFieldPage.qml")
            }

            Button {
                anchors.horizontalCenter: parent.horizontalCenter
                //: button to switch to camera setup page
                text: qsTr("Camera Setup")
                onClicked: pageStack.push("CameraSetupPage.qml")
            }

            SectionHeader {
                text: qsTr("Information")
            }

            Label {
                id: currentCamera
                anchors.horizontalCenter: parent.horizontalCenter
                text: qsTr("Current Camera") + ": " + ptWindow.currentCameraManufacturer + " " + ptWindow.currentCameraModel
            }
        }
    }
}
