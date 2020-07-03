import QtQuick 2.0
import QtQuick.Layouts 1.4
import QtQuick.Controls 2.4
import NewDrone 1.0
import NewDrone.Controllers 1.0

Item {
    id: settingsEditor
    property int titleSize: 20
    property int space: 10
    property int small_space: 5

    property bool isSuperAdmin: false

    property var resetSettings: settingsEditorController.resetSettings
    property var loadSettings: settingsEditorController.loadSettings
    property var saveSettings: settingsEditorController.saveSettings

    property var modified: settingsEditorController.modified

    FontLoader {
        id: abelioFont
        source: "/fonts/FuturaBookBT"
    }

    ColumnLayout {
        anchors.fill: parent
        anchors.leftMargin: 50
        spacing: space

        ScrollView {
            id: control
            contentWidth: -1 //Make the scrollView only scrollable vertically
            Layout.fillWidth: true
            Layout.fillHeight: true
            clip: true

            ColumnLayout {
                height: 300
                implicitWidth: settingsEditor.width
                anchors.margins: 20
                spacing: 20

                GroupBox {
                    visible: !isSuperAdmin
                    label: Label {
                        text: "Flight Presets"
                        font.bold: true
                        font.pointSize: titleSize
                        font.family: abelioFont.name
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
                            font.family: abelioFont.name
                        }
                        Label {
                            text: "Medium"
                            font.family: abelioFont.name
                        }
                        Label {
                            text: "High"
                            font.family: abelioFont.name
                        }
                        Label {
                            text: "Speed (m/s)"
                            font.family: abelioFont.name
                        }
                        DoubleSpinBox {
                            editable: true
                            to: 50
                            decimals: 1
                            value: settingsEditorController.lowSpeed
                            onValueChanged: settingsEditorController.lowSpeed = value
                        }
                        DoubleSpinBox {
                            id: test2
                            editable: true
                            to: 50
                            decimals: 1
                            value: settingsEditorController.mediumSpeed
                            onValueChanged: settingsEditorController.mediumSpeed = value
                        }
                        DoubleSpinBox {
                            editable: true
                            to: 50
                            decimals: 1
                            value: settingsEditorController.highSpeed
                            onValueChanged: settingsEditorController.highSpeed = value
                        }
                        Label {
                            text: "Altitude (m)"
                            font.family: abelioFont.name
                        }
                        DoubleSpinBox {
                            editable: true
                            to: 200
                            decimals: 1
                            value: settingsEditorController.lowAltitude
                            onValueChanged: settingsEditorController.lowAltitude = value
                        }
                        DoubleSpinBox {
                            editable: true
                            to: 200
                            decimals: 1
                            value: settingsEditorController.mediumAltitude
                            onValueChanged: settingsEditorController.mediumAltitude = value
                        }
                        DoubleSpinBox {
                            editable: true
                            to: 200
                            decimals: 1
                            value: settingsEditorController.highAltitude
                            onValueChanged: settingsEditorController.highAltitude = value
                        }
                    }
                }

                GroupBox {
                    visible: !isSuperAdmin
                    label: Label {
                        text: "Flight Settings"
                        font.bold: true
                        font.pointSize: titleSize
                        font.family: abelioFont.name
                    }


                    GridLayout {
                        anchors.centerIn: parent
                        columns: 4
                        columnSpacing: space
                        rowSpacing: small_space
                        Label {
                            text: "Turnaround Distance (m)"
                            font.family: abelioFont.name
                        }
                        DoubleSpinBox {
                            Layout.columnSpan: 3
                            editable: true
                            to: 100
                            decimals: 1
                            value: settingsEditorController.turnaroundDistance
                            onValueChanged: settingsEditorController.turnaroundDistance = value
                        }
                        Label {
                            text: "Loiter Radius (m)"
                            font.family: abelioFont.name
                        }
                        DoubleSpinBox {
                            Layout.columnSpan: 3
                            editable: true
                            to: 100
                            decimals: 1
                            value: settingsEditorController.loiterRadius
                            onValueChanged: settingsEditorController.loiterRadius = value
                        }

                        Item {
                            Layout.columnSpan: 4
                            implicitHeight: 10
                        }

                        Item {
                            implicitWidth: 1
                        }
                        Label {
                            text: "Tolerance (m)"
                            font.family: abelioFont.name
                        }
                        Label {
                            text: "Max Climb Rate (m/s)"
                            font.family: abelioFont.name
                        }
                        Label {
                            text: "Max Descent Rate (m/s)"
                            font.family: abelioFont.name
                        }
                        Label {
                            text: "Terrain Following"
                            font.family: abelioFont.name
                        }
                        DoubleSpinBox {
                            editable: true
                            to: 100
                            decimals: 1
                            value: settingsEditorController.tolerance
                            onValueChanged: settingsEditorController.tolerance = value
                        }
                        DoubleSpinBox {
                            editable: true
                            to: 50
                            decimals: 2
                            stepSize: 0.5
                            value: settingsEditorController.maxClimbRate
                            onValueChanged: settingsEditorController.maxClimbRate = value
                        }
                        DoubleSpinBox {
                            editable: true
                            to: 50
                            decimals: 2
                            stepSize: 0.5
                            value: settingsEditorController.maxDescentRate
                            onValueChanged: settingsEditorController.maxDescentRate = value
                        }
                    }
                }

                GroupBox {
                    label: Label {
                        text: "Camera Settings"
                        font.bold: true
                        font.pointSize: titleSize
                        font.family: abelioFont.name
                    }

                    GridLayout {
                        anchors.centerIn: parent
                        columns: 2
                        columnSpacing: space
                        Label {
                            text: "Focal Length (mm)"
                            font.family: abelioFont.name
                            Layout.columnSpan: 2
                        }
                        DoubleSpinBox {
                            Layout.columnSpan: 2
                            editable: true
                            to: 500
                            decimals: 2
                            stepSize: 0.01
                            value: settingsEditorController.focalLength
                            onValueChanged: settingsEditorController.focalLength = value
                        }
                        Label {
                            text: "Sensor Width (mm)"
                            font.family: abelioFont.name
                        }
                        Label {
                            text: "Sensor Height (mm)"
                            font.family: abelioFont.name
                        }
                        DoubleSpinBox {
                            editable: true
                            to: 500
                            decimals: 2
                            stepSize: 0.01
                            value: settingsEditorController.sensorWidth
                            onValueChanged: settingsEditorController.sensorWidth = value
                        }
                        DoubleSpinBox {
                            editable: true
                            to: 500
                            stepSize: 0.01
                            value: settingsEditorController.sensorHeight
                            onValueChanged: settingsEditorController.sensorHeight = value
                        }
                    }
                }

                GroupBox {
                    label: Label {
                        text: "Image Settings"
                        font.bold: true
                        font.pointSize: titleSize
                        font.family: abelioFont.name
                    }

                    GridLayout {
                        anchors.centerIn: parent
                        columns: 2
                        columnSpacing: space
                        Label {
                            text: "Image Orientation"
                            font.family: abelioFont.name
                            Layout.columnSpan: 2
                            visible: isSuperAdmin
                        }
                        ComboBox {
                            model: ["Landscape", "Portrait"]
                            font.family: abelioFont.name
                            Layout.columnSpan: 2
                            Layout.minimumWidth: 180
                            currentIndex: settingsEditorController.imageOrientation
                            onCurrentIndexChanged: settingsEditorController.imageOrientation
                                                   = currentIndex
                            visible: isSuperAdmin
                        }
                        Label {
                            text: "Image Width (px)"
                            font.family: abelioFont.name
                            visible: isSuperAdmin
                        }
                        Label {
                            text: "Image Height (px)"
                            font.family: abelioFont.name
                            visible: isSuperAdmin
                        }
                        SpinBox {
                            Layout.minimumWidth: 180
                            editable: true
                            to: 8000
                            value: settingsEditorController.imageWidth
                            onValueChanged: settingsEditorController.imageWidth = value
                            visible: isSuperAdmin
                        }
                        SpinBox {
                            Layout.minimumWidth: 180
                            editable: true
                            to: 8000
                            value: settingsEditorController.imageHeight
                            onValueChanged: settingsEditorController.imageHeight = value
                            visible: isSuperAdmin
                        }
                        Label {
                            text: "Overlap (%)"
                            font.family: abelioFont.name
                            Layout.columnSpan: 2
                            visible: !isSuperAdmin
                        }
                        SpinBox {
                            Layout.minimumWidth: 180
                            Layout.columnSpan: 2
                            editable: true
                            to: 8000
                            value: settingsEditorController.overlap
                            onValueChanged: settingsEditorController.overlap = value
                            visible: !isSuperAdmin
                        }
                    }
                }
                GroupBox {
                    label: Label {
                        text: "Checklist"
                        font.bold: true
                        font.pointSize: titleSize
                        font.family: abelioFont.name
                    }
                    TextArea {
                        implicitWidth: 600
                        font.family: abelioFont.name
                        implicitHeight: 300
                        enabled: isSuperAdmin
                        text: settingsEditorController.checklist
                        onTextChanged: settingsEditorController.checklist=text
                        placeholderText: "Title1:Question1\nTitle2:Question2\nTitle3:Question3\n..."
                    }
                }
            }
        }

        RowLayout {
            Button {
                text: "Reset to default"
                font.family: abelioFont.name
                Layout.margins: small_space
                Layout.alignment: Qt.AlignHCenter

                onClicked: {
                    confirmResetDialog.show(
                                "Are you sure you want to DISCARD ALL YOUR SETTINGS and reset them to default values?")
                }
            }
            Button {
                text: "Restore"
                font.family: abelioFont.name
                Layout.fillWidth: true
                Layout.margins: small_space
                Layout.alignment: Qt.AlignHCenter

                enabled: settingsEditorController.modified

                onClicked: {
                    confirmRestoreDialog.show(
                                "Are you sure you want to discard your unsaved changes?")
                }
            }
            Button {
                text: "Save"
                font.family: abelioFont.name
                Layout.fillWidth: true
                Layout.margins: small_space
                Layout.alignment: Qt.AlignHCenter

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
