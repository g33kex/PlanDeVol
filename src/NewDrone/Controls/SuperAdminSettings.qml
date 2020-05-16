import QtQuick.Layouts 1.4
import QtQuick 2.1
import QtQuick.Controls 2.4
import QGroundControl 1.0
import QGroundControl.Controllers 1.0
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4

Popup {
    id: superAdminPopup
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

            ParametersEditor {}

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

                superAdminPopup.close()
            }
        }
    }
}
