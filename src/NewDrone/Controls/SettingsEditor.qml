import QtQuick 2.0
import QtQuick.Layouts 1.4
import QtQuick.Controls 2.4
import NewDrone 1.0
import NewDrone.Controllers 1.0

Item {
    id: settingsEditor
    property int titleSize: 10
    property int space: 10
    property int small_space: 5

    SettingsEditorController {
        id: settingsEditorController
    }

    property var resetSettings: settingsEditorController.resetSettings
    property var loadSettings: settingsEditorController.loadSettings
    property var saveSettings: settingsEditorController.saveSettings

    property var modified: settingsEditorController.modified

    ColumnLayout {
        anchors.fill: parent
        spacing : space

    ScrollView {
        Layout.fillWidth: true
        Layout.fillHeight: true
        clip: true

        ColumnLayout {
            height: 300
            implicitWidth: settingsEditor.width
            anchors.margins: 20
            spacing: 20

            GroupBox {
                id: flightPresets
                label: Label {
                    text: "Flight Presets"
                    font.bold: true
                    font.pointSize: titleSize
                }

                // Layout.alignment: Qt.AlignHCenter
                //Layout.fillWidth: true
                GridLayout {
                    anchors.centerIn: parent
                    columns: 4
                    columnSpacing: space
                    rowSpacing: space
                    Item {
                        implicitWidth: 1
                    }
                    Label {
                        text: "Low"
                    }
                    Label {
                        text: "Medium"
                    }
                    Label {
                        text: "High"
                    }
                    Label {
                        text: "Speed (m/s)"
                    }
                    DoubleSpinBox {
                        editable: true
                        to: 50
                        decimals: 1
                        value: settingsEditorController.lowSpeed
                        onValueChanged: settingsEditorController.lowSpeed=value
                    }
                    DoubleSpinBox {
                        id: test2
                        editable: true
                        to: 50
                        decimals: 1
                        value: settingsEditorController.mediumSpeed
                        onValueChanged: settingsEditorController.mediumSpeed=value
                    }
                    DoubleSpinBox {
                        editable: true
                        to: 50
                        decimals: 1
                        value: settingsEditorController.highSpeed
                        onValueChanged: settingsEditorController.highSpeed=value
                    }
                    Label {
                        text: "Altitude (m)"
                    }
                    DoubleSpinBox {
                        editable: true
                        to: 200
                        decimals: 1
                        value: settingsEditorController.lowAltitude
                        onValueChanged: settingsEditorController.lowAltitude=value
                    }
                    DoubleSpinBox {
                        editable: true
                        to: 200
                        decimals: 1
                        value: settingsEditorController.mediumAltitude
                        onValueChanged: settingsEditorController.mediumAltitude=value
                    }
                    DoubleSpinBox {
                        editable: true
                        to: 200
                        decimals: 1
                        value: settingsEditorController.highAltitude
                        onValueChanged: settingsEditorController.highAltitude=value
                    }
                }
            }

            GroupBox {
                id: flightSettings
                label: Label {
                    text: "Flight Settings"
                    font.bold: true
                    font.pointSize: titleSize
                }

                GridLayout {
                    anchors.centerIn: parent
                    columns: 2
                    columnSpacing: space
                    rowSpacing: small_space
                    Label {
                        text: "Turnaround Distance (m)"
                    }
                    Label {
                        text: "Tolerance (m)"
                    }
                    DoubleSpinBox {
                        editable: true
                        to: 100
                        decimals: 1
                        value: settingsEditorController.turnaroundDistance
                        onValueChanged: settingsEditorController.turnaroundDistance=value
                    }
                    DoubleSpinBox {
                        editable: true
                        to: 100
                        decimals: 1
                        value: settingsEditorController.tolerance
                        onValueChanged: settingsEditorController.tolerance=value
                    }
                    Label {
                        text: "Max Climb Rate (m/s)"
                    }
                    Label {
                        text: "Max Descent Rate (m/s)"
                    }
                    DoubleSpinBox {
                        editable: true
                        to: 50
                        decimals: 2
                        stepSize: 0.5
                        value: settingsEditorController.maxClimbRate
                        onValueChanged: settingsEditorController.maxClimbRate=value
                    }
                    DoubleSpinBox {
                        editable: true
                        to: 50
                        decimals: 2
                        stepSize: 0.5
                        value: settingsEditorController.maxDescentRate
                        onValueChanged: settingsEditorController.maxDescentRate=value
                    }
                }
            }

            GroupBox {
                id: cameraSettings
                label: Label {
                    text: "Camera Settings"
                    font.bold: true
                    font.pointSize: titleSize
                }

                GridLayout {
                    anchors.centerIn: parent
                    columns: 2
                    columnSpacing: space
                    Label {
                        text: "Focal Length (mm)"
                        Layout.columnSpan: 2
                    }
                    DoubleSpinBox {
                        Layout.columnSpan: 2
                        editable: true
                        to: 500
                        decimals: 2
                        stepSize: 0.01
                        value: settingsEditorController.focalLength
                        onValueChanged: settingsEditorController.focalLength=value
                    }
                    Label {
                        text: "Sensor Width (mm)"
                    }
                    Label {
                        text: "Sensor Height (mm)"
                    }
                    DoubleSpinBox {
                        editable: true
                        to: 500
                        decimals: 2
                        stepSize: 0.01
                        value: settingsEditorController.sensorWidth
                        onValueChanged: settingsEditorController.sensorWidth=value
                    }
                    DoubleSpinBox {
                        editable: true
                        to: 500
                        stepSize: 0.01
                        value: settingsEditorController.sensorHeight
                        onValueChanged: settingsEditorController.sensorHeight=value
                    }
                }
            }

            GroupBox {
                id: imageSettings
                label: Label {
                    text: "Image Settings"
                    font.bold: true
                    font.pointSize: titleSize
                }

                GridLayout {
                    anchors.centerIn: parent
                    columns: 2
                    columnSpacing: space
                    Label {
                        text: "Image Orientation"
                        Layout.columnSpan: 2
                    }
                    ComboBox {
                        model: ["Landscape", "Portrait"]
                        Layout.columnSpan: 2
                        currentIndex: settingsEditorController.imageOrientation
                        onCurrentIndexChanged: settingsEditorController.imageOrientation=currentIndex
                    }
                    Label {
                        text: "Image Width (px)"
                    }
                    Label {
                        text: "Image Height (px)"
                    }
                    SpinBox {
                        editable: true
                        to: 8000
                        value: settingsEditorController.imageWidth
                        onValueChanged: settingsEditorController.imageWidth=value
                    }
                    SpinBox {
                        editable: true
                        to: 8000
                        value: settingsEditorController.imageHeight
                        onValueChanged: settingsEditorController.imageHeight=value
                    }
                    Label {
                        text: "Overlap (cm)"
                        Layout.columnSpan: 2
                    }
                    SpinBox {
                        Layout.columnSpan: 2
                        editable: true
                        to: 8000
                        value: settingsEditorController.overlap
                        onValueChanged: settingsEditorController.overlap=value
                    }
                }
            }
        }
    }

    RowLayout {
        Layout.fillWidth: true
        spacing: space
        Button {
            text: "Reset to default"
            Layout.fillWidth: true
            Layout.margins: small_space

            onClicked: {
                confirmResetDialog.show("Are you sure you want to DISCARD ALL YOUR SETTINGS and reset them to default values?")
            }
        }
        Button {
            text: "Restore"
            Layout.fillWidth: true
            Layout.margins: small_space
            enabled: settingsEditorController.modified

            onClicked: {
                confirmRestoreDialog.show("Are you sure you want to discard your unsaved changes?")
            }
        }
        Button {
            text: "Save"
            Layout.fillWidth: true
            Layout.margins: small_space
            enabled: settingsEditorController.modified

            onClicked: {
                saveSettings()
            }
        }
    }
    }

    ConfirmationDialog {
        id: confirmRestoreDialog
        onAccepted: {
            loadSettings()
        }
    }

    ConfirmationDialog {
        id: confirmResetDialog
        onAccepted: {
            resetSettings()
        }
    }
}
/*ColumnLayout {


    function save() {

        loginController.setParamSpeed(lowspeed.text, medspeed.text,
                                       highspeed.text)
        loginController.setParamAlt(lowalt.text, medalt.text,
                                     highalt.text)
        loginController.setParamLimit(nbSession.text, nbParcelle.text,
                                       nbMission.text)
        loginController.setParamChecklist(checkListEditor.getCheckList())
        loginController.setParamFlight(turn.text, tol.text,
                                        maxclimb.text, maxdescent.text)
        loginController.setParamCamera(focale.text, sensorW.text,
                                        sensorH.text, imageW.text,
                                        imageH.text, land.currentIndex)
    }

    Label {
        text: "Vitesse"
        color: "gray"
        Layout.margins: m2
    }
    GridLayout {
        columns: 6

        Label {
            text: "Basse"
            Layout.columnSpan: 2
        }
        Label {
            text: "Medium"
            Layout.columnSpan: 2
        }
        Label {
            text: "Rapide"
            Layout.columnSpan: 2
        }

        TextField {
            id: lowspeed
            text: loginController.getSpeedLow()
        }
        Label {
            text: "m/s"
        }
        TextField {
            id: medspeed
            text: loginController.getSpeedMed()
        }
        Label {
            text: "m/s"
        }
        TextField {
            id: highspeed
            text: loginController.getSpeedHigh()
        }
        Label {
            text: "m/s"
        }
    }

    Label {
        text: "Altitude"
        color: "gray"
        Layout.margins: m2
    }
    GridLayout {
        columns: 6

        Label {
            text: "Basse"
            Layout.columnSpan: 2
        }
        Label {
            text: "Medium"
            Layout.columnSpan: 2
        }
        Label {
            text: "Haute"
            Layout.columnSpan: 2
        }

        TextField {
            id: lowalt
            text: loginController.getAltLow()
        }
        Label {
            text: "m"
        }

        TextField {
            id: medalt
            text: loginController.getAltMed()
        }
        Label {
            text: "m"
        }

        TextField {
            id: highalt
            text: loginController.getAltHigh()
        }
        Label {
            text: "m"
        }
    }

    Label {
        text: "Paramètre de vol"
        color: "gray"
        Layout.margins: m2
    }

    GridLayout {
        columns: 8

        Label {
            text: "Turnaround distance"
            Layout.margins: m2
            Layout.columnSpan: 2
        }
        Label {
            text: "Tolerance"
            Layout.margins: m2
            Layout.columnSpan: 2
        }
        Label {
            text: "Maximum Climb Rate"
            Layout.margins: m2
            Layout.columnSpan: 2
        }
        Label {
            text: "Maximum Descent Rate"
            Layout.margins: m2
            Layout.columnSpan: 2
        }

        TextField {
            id: turn
            text: loginController.getTurn()
        }
        Label {
            text: "m"
            Layout.margins: m2
        }
        TextField {
            id: tol
            text: loginController.getTolerance()
        }
        Label {
            text: "m"
            Layout.margins: m2
        }
        TextField {
            id: maxclimb
            text: loginController.getMaxClimbRate()
        }
        Label {
            text: "m/s"
            Layout.margins: m2
        }
        TextField {
            id: maxdescent
            text: loginController.getMaxDescentRate()
        }
        Label {
            text: "m/s"
            Layout.margins: m2
        }
    }

    Label {
        text: "Paramètre de Caméra-"
        color: "gray"
        Layout.margins: m2
    }

    GridLayout {
        columns: 6

        Label {
            text: "Focale"
            Layout.margins: m2
            Layout.columnSpan: 2
        }
        Label {
            text: "sensor Width"
            Layout.margins: m2
            Layout.columnSpan: 2
        }
        Label {
            text: "Sensor Height"
            Layout.margins: m2
            Layout.columnSpan: 2
        }
        TextField {
            id: focale
            text: loginController.getCameraFocale()
        }
        Label {
            text: "mm"
            Layout.margins: m2
        }
        TextField {
            id: sensorW
            text: loginController.getCameraSensorW()
        }
        Label {
            text: "mm"
            Layout.margins: m2
        }
        TextField {
            id: sensorH
            text: loginController.getCameraSensorH()
        }
        Label {
            text: "mm"
            Layout.margins: m2
        }
        Label {
            text: "Image Width"
            Layout.margins: m2
            Layout.columnSpan: 2
        }
        Label {
            text: "Image Height"
            Layout.margins: m2
            Layout.columnSpan: 2
        }
        Label {
            text: "Orientation"
            Layout.margins: m2
            Layout.columnSpan: 2
        }
        TextField {
            id: imageW
            text: loginController.getCameraImageW()
        }
        Label {
            text: "px"
            Layout.margins: m2
        }
        TextField {
            id: imageH
            text: loginController.getCameraImageH()
        }
        Label {
            text: "px"
            Layout.margins: m2
        }
        ComboBox {
            id: land
            model: ["Portrait", "Paysage"]
            currentIndex: loginController.getCameraLand()
            Layout.columnSpan: 2
        }
    }

    Button {
        text: "exporter en XML"
        Layout.margins: m2
        onClicked: {
            loginController.exportToXML()
            doneDialog.open()
        }
    }

    Button {
        text: "Enregistrer"
        Layout.margins: m2
        onClicked: {
            save()
            doneDialog.open()
        }
    }
}*/

