import QtQuick.Layouts 1.4
import QtQuick 2.1
import QtQuick.Controls 2.4
import QGroundControl 1.0
import QGroundControl.Controllers 1.0
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4

Popup {
    id: adminPopup
    modal: true

    ColumnLayout {
        anchors.fill: parent

        TabBar {
            id: tabBar
            contentWidth: 220 * 7

            TabButton {
                height: 60
                text: "User Manager"
                background: Rectangle {
                    color: tabBar.currentIndex == 0 ? "steelblue" : "lightsteelblue"
                    radius: 3
                }
            }
            TabButton {
                height: 60
                text: "Missions"
                background: Rectangle {
                    color: tabBar.currentIndex == 1 ? "coral" : "lightcoral"
                    radius: 3
                }
            }
            TabButton {
                height: 60
                text: "Parcelles"
                background: Rectangle {
                    color: tabBar.currentIndex == 2 ? "mediumseagreen" : "lightgreen"
                    radius: 3
                }
            }
            TabButton {
                height: 60
                text: "Questions"
                background: Rectangle {
                    color: tabBar.currentIndex == 3 ? "orange" : "gold"
                    radius: 3
                }
            }
            TabButton {
                height: 60
                text: "Paramètres"
                background: Rectangle {
                    color: tabBar.currentIndex == 4 ? "silver" : "lightgrey"
                    radius: 3
                }
            }
            TabButton {
                height: 60
                text: "Checklist"
                background: Rectangle {
                    color: tabBar.currentIndex == 5 ? "orchid" : "plum"
                    radius: 3
                }
            }
        }

        StackLayout {
            id: tabV
            currentIndex: tabBar.currentIndex
            Layout.fillWidth: true
            Layout.fillHeight: true

            UserManager {}
            MissionsView {}
            ParcelsView {}
            QuestionsEditor {
                id: questionsEditor
            }

            Item {

                ColumnLayout {
                    anchors.fill: parent

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
                            text: _loginController.getSpeedLow()
                        }
                        Label {
                            text: "m/s"
                        }
                        TextField {
                            id: medspeed
                            text: _loginController.getSpeedMed()
                        }
                        Label {
                            text: "m/s"
                        }
                        TextField {
                            id: highspeed
                            text: _loginController.getSpeedHigh()
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
                            text: _loginController.getAltLow()
                        }
                        Label {
                            text: "m"
                        }

                        TextField {
                            id: medalt
                            text: _loginController.getAltMed()
                        }
                        Label {
                            text: "m"
                        }

                        TextField {
                            id: highalt
                            text: _loginController.getAltHigh()
                        }
                        Label {
                            text: "m"
                        }
                    }

                    Label {
                        text: "Limite de nombre"
                        color: "gray"
                        Layout.margins: m2
                    }

                    GridLayout {
                        columns: 3

                        Label {
                            text: "Limite nombre de session"
                        }
                        Label {
                            text: "Limite parcelle / utilisateur"
                        }
                        Label {
                            text: "Limit mission / utilisateur"
                        }

                        TextField {
                            id: nbSession
                            text: _loginController.getNbSession()
                        }
                        TextField {
                            id: nbParcelle
                            text: _loginController.getNbParcelle()
                        }
                        TextField {
                            id: nbMission
                            text: _loginController.getNbMission()
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
                            text: _loginController.getTurn()
                        }
                        Label {
                            text: "m"
                            Layout.margins: m2
                        }
                        TextField {
                            id: tol
                            text: _loginController.getTolerance()
                        }
                        Label {
                            text: "m"
                            Layout.margins: m2
                        }
                        TextField {
                            id: maxclimb
                            text: _loginController.getMaxClimbRate()
                        }
                        Label {
                            text: "m/s"
                            Layout.margins: m2
                        }
                        TextField {
                            id: maxdescent
                            text: _loginController.getMaxDescentRate()
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
                            text: _loginController.getCameraFocale()
                        }
                        Label {
                            text: "mm"
                            Layout.margins: m2
                        }
                        TextField {
                            id: sensorW
                            text: _loginController.getCameraSensorW()
                        }
                        Label {
                            text: "mm"
                            Layout.margins: m2
                        }
                        TextField {
                            id: sensorH
                            text: _loginController.getCameraSensorH()
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
                            text: _loginController.getCameraImageW()
                        }
                        Label {
                            text: "px"
                            Layout.margins: m2
                        }
                        TextField {
                            id: imageH
                            text: _loginController.getCameraImageH()
                        }
                        Label {
                            text: "px"
                            Layout.margins: m2
                        }
                        ComboBox {
                            id: land
                            model: ["Portrait", "Paysage"]
                            currentIndex: _loginController.getCameraLand()
                            Layout.columnSpan: 2
                        }
                    }

                    Button {
                        text: "exporter en XML"
                        Layout.margins: m2
                        onClicked: {
                            _loginController.exportToXML()
                            doneDialog.open()
                        }
                    }

                    Button {
                        text: "Enregistrer"
                        Layout.margins: m2
                        onClicked: {
                            _loginController.setParamSpeed(lowspeed.text,
                                                           medspeed.text,
                                                           highspeed.text)
                            _loginController.setParamAlt(lowalt.text,
                                                         medalt.text,
                                                         highalt.text)
                            _loginController.setParamLimit(nbSession.text,
                                                           nbParcelle.text,
                                                           nbMission.text)
                            _loginController.setParamFlight(turn.text,
                                                            tol.text,
                                                            maxclimb.text,
                                                            maxdescent.text)
                            _loginController.setParamCamera(focale.text,
                                                            sensorW.text,
                                                            sensorH.text,
                                                            imageW.text,
                                                            imageH.text,
                                                            land.currentIndex)
                            doneDialog.open()
                        }
                    }
                }
            }

            ChecklistEditor {
                id: checkListEditor
            }
        }

        Button {
            Layout.alignment: Qt.AlignRight
            text: "Deconnexion"
            Layout.margins: 5
            style: ButtonStyle {
                background: Rectangle {
                    implicitWidth: 120
                    implicitHeight: 35
                    border.width: control.activeFocus ? 2 : 1
                    border.color: "pink"
                    radius: 20
                    gradient: Gradient {
                        GradientStop {
                            position: 0
                            color: control.pressed ? "pink" : "red"
                        }
                        GradientStop {
                            position: 1
                            color: control.pressed ? "purple" : "darkred"
                        }
                    }
                }
            }
            onClicked: {

                //we save the flight param
                _loginController.setParamSpeed(lowspeed.text, medspeed.text,
                                               highspeed.text)
                _loginController.setParamAlt(lowalt.text, medalt.text,
                                             highalt.text)
                _loginController.setParamLimit(nbSession.text, nbParcelle.text,
                                               nbMission.text)
                _loginController.setParamChecklist(checkListEditor.getCheckList())
                _loginController.setParamFlight(turn.text, tol.text,
                                                maxclimb.text, maxdescent.text)
                _loginController.setParamCamera(focale.text, sensorW.text,
                                                sensorH.text, imageW.text,
                                                imageH.text, land.currentIndex)

                //we save the questions
                questionsEditor.save()
                _loginController.onAdminClosed()

                adminPopup.close()
            }
        }
    }
}
