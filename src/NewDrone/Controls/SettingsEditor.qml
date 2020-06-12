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

    ScrollView {
        anchors.fill: parent
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
                    SpinBox {
                        id: lowSpeed
                        editable: true
                        value: settingsEditorController.lowSpeed
                        onValueChanged: settingsEditorController.lowSpeed=value
                    }
                    SpinBox {
                        id: mediumSpeed
                        editable: true
                        value: settingsEditorController.lowSpeed
                        onValueChanged: settingsEditorController.lowSpeed=value
                    }
                    SpinBox {
                        id: highSpeed
                        editable: true
                    }
                    Label {
                        text: "Altitude (m)"
                    }
                    SpinBox {
                        id: lowAltitude
                        editable: true
                    }
                    SpinBox {
                        id: mediumAltitude
                        editable: true
                    }
                    SpinBox {
                        id: highAltitude
                        editable: true
                    }
                }

                function save() {}
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
                    SpinBox {
                        id: turnaroundDistance
                        editable: true
                    }
                    SpinBox {
                        id: tolerance
                        editable: true
                    }
                    Label {
                        text: "Max Climb Rate (m/s)"
                    }
                    Label {
                        text: "Max Descent Rate (m/s)"
                    }
                    SpinBox {
                        id: maxClimbRate
                        editable: true
                    }
                    SpinBox {
                        id: minDescentRate
                        editable: true
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
                    SpinBox {
                        Layout.columnSpan: 2
                    }
                    Label {
                        text: "Sensor Width (mm)"
                    }
                    Label {
                        text: "Sensor Height (mm)"
                    }
                    SpinBox {}
                    SpinBox {}
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
                    }
                    Label {
                        text: "Image Width (px)"
                    }
                    Label {
                        text: "Image Height (px)"
                    }
                    SpinBox {}
                    SpinBox {}
                    Label {
                        text: "Overlap (cm)"
                        Layout.columnSpan: 2
                    }
                    SpinBox {
                        Layout.columnSpan: 2
                    }
                }
            }
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

