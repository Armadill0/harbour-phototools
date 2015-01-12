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

import QtQuick 2.1
import Sailfish.Silica 1.0
import "localdb.js" as DB
import "pages"

ApplicationWindow
{
    id: photoToolsWindow

    // list of available aperture values
    property variant aperturesDouble: [1, 1.1, 1.2, 1.4, 1.6, 1.8, 2, 2.2, 2.5, 2.8, 3.2, 3.5, 4, 4.5, 5.0, 5.6, 6.3, 7.1, 8, 9, 10, 11, 13, 14, 16, 18, 20, 22, 25, 29, 32, 36, 40, 45]
    // list of default crop factors
    property variant cropFactorsDouble: [0.7, 0.8, 1, 1.2, 1.3, 1.5, 1.6, 2, 2.38, 2.7, 4, 4.5, 4.9, 5.6, 6.2, 6.8, 7.2, 8, 8.7]
    // list of sensor formats
    property variant sensorFormatsX: [1, 3, 4]
    property variant sensorFormatsY: [1, 2, 3]
    // define 35mm film default dimensions
    property double sensor35mmX: 36
    property double sensor35mmY: 24
    property double sensor35mmDiagonal: Math.sqrt(Math.pow(sensor35mmX, 2) + Math.pow(sensor35mmY, 2))

    function calcSensorX(sensorFormat, sensorCrop) {
        return (sensorFormatsX[sensorFormat] / Math.sqrt(Math.pow(sensorFormatsX[sensorFormat], 2) + Math.pow(sensorFormatsY[sensorFormat], 2))) * sensor35mmDiagonal / cropFactorsDouble[sensorCrop]
    }

    function calcSensorY(sensorFormat, sensorCrop) {
        return (sensorFormatsY[sensorFormat] / Math.sqrt(Math.pow(sensorFormatsX[sensorFormat], 2) + Math.pow(sensorFormatsY[sensorFormat], 2))) * sensor35mmDiagonal / cropFactorsDouble[sensorCrop]
    }

    initialPage: Component { LandingPage { } }
    cover: Qt.resolvedUrl("pages/CoverPage.qml")

    Component.onCompleted: {
        DB.initializeDB()
    }
}


