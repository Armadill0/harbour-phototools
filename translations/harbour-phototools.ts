<?xml version="1.0" encoding="utf-8"?>
<!DOCTYPE TS>
<TS version="2.1">
<context>
    <name>AboutPage</name>
    <message>
        <source>About</source>
        <extracomment>headline of application information page</extracomment>
        <translation type="unfinished"></translation>
    </message>
    <message>
        <source>Description</source>
        <extracomment>headline for application description</extracomment>
        <translation type="unfinished"></translation>
    </message>
    <message>
        <source>A collection of useful tools for daily photography.</source>
        <extracomment>application description</extracomment>
        <translation type="unfinished"></translation>
    </message>
    <message>
        <source>Licensing</source>
        <extracomment>headline for application licensing information</extracomment>
        <translation type="unfinished"></translation>
    </message>
    <message>
        <source>Copyright © by</source>
        <extracomment>Copyright and license information</extracomment>
        <translation type="unfinished"></translation>
    </message>
    <message>
        <source>License</source>
        <translation type="unfinished"></translation>
    </message>
    <message>
        <source>Project information</source>
        <extracomment>headline for application project information</extracomment>
        <translation type="unfinished"></translation>
    </message>
</context>
<context>
    <name>CameraSetupPage</name>
    <message>
        <source>Camera Setup</source>
        <translation type="unfinished"></translation>
    </message>
    <message>
        <source>Sensor</source>
        <translation type="unfinished"></translation>
    </message>
    <message>
        <source>Resolution</source>
        <translation type="unfinished"></translation>
    </message>
    <message>
        <source>Crop</source>
        <translation type="unfinished"></translation>
    </message>
    <message>
        <source>Format</source>
        <translation type="unfinished"></translation>
    </message>
</context>
<context>
    <name>CoverPage</name>
    <message>
        <source>Current camera:
</source>
        <translation type="unfinished"></translation>
    </message>
</context>
<context>
    <name>DepthOfFieldPage</name>
    <message>
        <source>Lens data</source>
        <extracomment>start of the lens section</extracomment>
        <translation type="unfinished"></translation>
    </message>
    <message>
        <source>Aperture</source>
        <extracomment>aperture of the used lens</extracomment>
        <translation type="unfinished"></translation>
    </message>
    <message>
        <source>Focal length (mm)</source>
        <extracomment>focal length of the used lens in millimeter</extracomment>
        <translation type="unfinished"></translation>
    </message>
    <message>
        <source>Object distance (m)</source>
        <extracomment>distance to the focused object in meter</extracomment>
        <translation type="unfinished"></translation>
    </message>
    <message>
        <source>Results</source>
        <extracomment>start of result section</extracomment>
        <translation type="unfinished"></translation>
    </message>
    <message>
        <source>Depth of field</source>
        <extracomment>header of depth of field page
----------
size of depth of field from near point till far point</extracomment>
        <translation type="unfinished"></translation>
    </message>
    <message>
        <source>Explanation</source>
        <extracomment>explanation of visual presentation of the depth of field</extracomment>
        <translation type="unfinished"></translation>
    </message>
    <message>
        <source>Camera data</source>
        <extracomment>start of the camera section</extracomment>
        <translation type="unfinished"></translation>
    </message>
    <message>
        <source>Select camera</source>
        <translation type="unfinished"></translation>
    </message>
    <message>
        <source>Crop factor</source>
        <extracomment>crop factor in relation to the 35mm format</extracomment>
        <translation type="unfinished"></translation>
    </message>
    <message>
        <source>Format</source>
        <extracomment>aspect ratio of the sensor</extracomment>
        <translation type="unfinished"></translation>
    </message>
    <message>
        <source>Resolution (mpix)</source>
        <extracomment>resolution of the sensor in megapixels</extracomment>
        <translation type="unfinished"></translation>
    </message>
    <message>
        <source>Near point</source>
        <extracomment>start of depth of field from sight of the camera</extracomment>
        <translation type="unfinished"></translation>
    </message>
    <message>
        <source>Far point</source>
        <extracomment>end of depth of field from sight of the camera</extracomment>
        <translation type="unfinished"></translation>
    </message>
    <message>
        <source>Circle of confusion</source>
        <extracomment>definition of sharpness of a point of the focused object</extracomment>
        <translation type="unfinished"></translation>
    </message>
    <message>
        <source>Hyperfocale distance</source>
        <extracomment>label: qsTr(&quot;Hyperfocale distance&quot;) readOnly: true text: Math.round(hyperfocalDistance / 1000 * 100) / 100 + &quot;m&quot; } } SectionHeader { //: start of the lens section text: qsTr(&quot;Lens data&quot;) } Slider { id: dopAperture width: parent.width //: aperture of the used lens label: qsTr(&quot;Aperture&quot;) minimumValue: 0 maximumValue: ptWindow.aperturesDouble.length - 1 value: 9 stepSize: 1 valueText: &quot;f/&quot; + ptWindow.aperturesDouble[value] } Row { width: parent.width TextField { id: dopFocalLength width: parent.width * 0.47 //: focal length of the used lens in millimeter label: qsTr(&quot;Focal length (mm)&quot;) placeholderText: label validator: DoubleValidator { bottom: 0 top: 9999 } inputMethodHints: Qt.ImhFormattedNumbersOnly text: &quot;50&quot; } TextField { id: dopObjectDistance width: parent.width * 0.53 //: distance to the focused object in meter label: qsTr(&quot;Object distance (m)&quot;) placeholderText: label validator: DoubleValidator { bottom: 0 top: 9999 } inputMethodHints: Qt.ImhFormattedNumbersOnly text: &quot;1.2&quot; } } SectionHeader { //: start of the camera section text: qsTr(&quot;Camera data&quot;) } ComboBox { id: dopCamera label: qsTr(&quot;Select camera&quot;) menu: ContextMenu { Repeater { model: cameraListModel MenuItem { text: cameraManufaturer + &quot; &quot; + cameraModel } } } description: &quot;Resolution: &quot; + currentCameraResolution + &quot;Mpix, &quot; + &quot;Crop: &quot; + ptWindow.cropFactorsDouble[currentCameraCrop] + &quot;(&quot; + Math.round(sensorSizeX * 100) / 100 + &quot;mm), &quot; + &quot;Format: &quot; + ptWindow.sensorFormatsX[currentCameraFormat] + &quot;:&quot; + ptWindow.sensorFormatsY[currentCameraFormat] } Column { width: parent.width spacing: Theme.paddingSmall visible: false Slider { id: dopCropFactor width: parent.width //: crop factor in relation to the 35mm format label: qsTr(&quot;Crop factor&quot;) minimumValue: 0 maximumValue: ptWindow.cropFactorsDouble.length - 1 value: currentCameraCrop stepSize: 1 valueText: ptWindow.cropFactorsDouble[value] + &quot;(&quot; + Math.round(sensorSizeX * 100) / 100 + &quot;mm)&quot; } Row { width: parent.width ComboBox { id: dopSensorFormat width: parent.width / 2 //: aspect ratio of the sensor label: qsTr(&quot;Format&quot;) currentIndex: currentCameraFormat menu: ContextMenu { MenuItem { text: &quot;1:1&quot; } MenuItem { text: &quot;3:2&quot; } MenuItem { text: &quot;4:3&quot; } } } TextField { id: dopSensorResolution width: parent.width / 2 //: resolution of the sensor in megapixels label: qsTr(&quot;Resolution (mpix)&quot;) placeholderText: label validator: DoubleValidator { bottom: 0 top: 999 } inputMethodHints: Qt.ImhFormattedNumbersOnly text: currentCameraResolution } } } } } }</extracomment>
        <translation type="unfinished"></translation>
    </message>
</context>
<context>
    <name>LandingPage</name>
    <message>
        <source>Start</source>
        <extracomment>header of start/landing page</extracomment>
        <translation type="unfinished"></translation>
    </message>
    <message>
        <source>About</source>
        <extracomment>menu item to jump to the application information page</extracomment>
        <translation type="unfinished"></translation>
    </message>
    <message>
        <source>Current Camera: </source>
        <translation type="unfinished"></translation>
    </message>
</context>
</TS>
