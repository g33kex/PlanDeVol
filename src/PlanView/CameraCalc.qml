import QtQuick          2.3
import QtQuick.Controls 1.2
import QtQuick.Layouts  1.2

import QGroundControl                   1.0
import QGroundControl.ScreenTools       1.0
import QGroundControl.Controls          1.0
import QGroundControl.FactControls      1.0
import QGroundControl.Palette           1.0

// Camera calculator section for mission item editors
Column {
    anchors.left:   parent.left
    anchors.right:  parent.right
    spacing:        _margin

    visible: !usingPreset || !cameraSpecifiedInPreset

    property var    cameraCalc
    property bool   vehicleFlightIsFrontal:         true
    property string distanceToSurfaceLabel
    property int    distanceToSurfaceAltitudeMode:  QGroundControl.AltitudeModeNone
    property string frontalDistanceLabel
    property string sideDistanceLabel
    property bool   usingPreset:                    false
    property bool   cameraSpecifiedInPreset:        false

    property real   _margin:            ScreenTools.defaultFontPixelWidth / 2
    property string _cameraName:        cameraCalc.cameraName.value
    property real   _fieldWidth:        ScreenTools.defaultFontPixelWidth * 10.5
    property var    _cameraList:        [ ]
    property var    _vehicle:           QGroundControl.multiVehicleManager.activeVehicle ? QGroundControl.multiVehicleManager.activeVehicle : QGroundControl.multiVehicleManager.offlineEditingVehicle
    property var    _vehicleCameraList: _vehicle ? _vehicle.staticCameraList : []
    property bool   _cameraComboFilled: false

    readonly property int _gridTypeManual:          0
    readonly property int _gridTypeCustomCamera:    1
    readonly property int _gridTypeCamera:          2


    function _fillCameraCombo() {
        _cameraComboFilled = true
        _cameraList.push(_vehicle.staticCameraList[0].name)
        cameraCalc.cameraName.value = "New Drone Camera"
//        _cameraList.push(cameraCalc.manualCameraName)
//        _cameraList.push(cameraCalc.customCameraName)
    }

    Component.onCompleted: {
        cameraCalc.frontalOverlap.value = settingsEditorController.overlap
        cameraCalc.sideOverlap.value = settingsEditorController.overlap
    }

    QGCPalette { id: qgcPal; colorGroupEnabled: true }

    ExclusiveGroup {
        id: cameraOrientationGroup
    }

    SectionHeader {
        id:         cameraHeader
        text:       qsTr("Camera")
        showSpacer: false
    }

    Column {
        anchors.left:   parent.left
        anchors.right:  parent.right
        spacing:        _margin
        visible:        cameraHeader.checked

        Label {
            text : "New Drone Camera"
            color: "white"
        }

        RowLayout {
            anchors.left:   parent.left
            anchors.right:  parent.right
            spacing:        _margin
            visible:        !usingPreset
            Item { Layout.fillWidth: true }
            QGCLabel {
                Layout.preferredWidth:  _root._fieldWidth
                text:                   qsTr("Front Lap")
            }
            QGCLabel {
                Layout.preferredWidth:  _root._fieldWidth
                text:                   qsTr("Side Lap")
            }
        }

        RowLayout {
            anchors.left:   parent.left
            anchors.right:  parent.right
            spacing:        _margin
            visible:        !usingPreset
            QGCLabel { text: "Overlap"; Layout.fillWidth: true }
            FactTextField {
                Layout.preferredWidth:  _root._fieldWidth
                fact:                   cameraCalc.frontalOverlap
                enabled: false
            }
            FactTextField {
                Layout.preferredWidth:  _root._fieldWidth
                fact:                   cameraCalc.sideOverlap
                enabled: false
            }
        }

        QGCLabel {
            wrapMode:               Text.WordWrap
            text:                   qsTr("Select one:")
            Layout.preferredWidth:  parent.width
            Layout.columnSpan:      2
            visible:                !usingPreset
        }

        GridLayout {
            anchors.left:   parent.left
            anchors.right:  parent.right
            columnSpacing:  _margin
            rowSpacing:     _margin
            columns:        2
            visible:        !usingPreset

            Label {
                text: distanceToSurfaceLabel
            }

            AltitudeFactTextField {
                fact:                   cameraCalc.distanceToSurface
                altitudeMode:           distanceToSurfaceAltitudeMode
                enabled:                false
                Layout.fillWidth:       true
            }

            Label {
                text:                   qsTr("Ground Res")
            }

            FactTextField {
                fact:                   cameraCalc.imageDensity
                enabled:                false
                Layout.fillWidth:       true
            }
        }

    } // Column - Camera Section
} // Column
