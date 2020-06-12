import QtQuick.Layouts 1.4
import QtQuick 2.1
import QtQuick.Controls 2.4
import QGroundControl 1.0
import QGroundControl.Controllers 1.0

Popup {
    id: superAdminPopup
    modal: true
    padding: 20

    contentItem: ColumnLayout {

        TabBar {
            id: tabBar
            Layout.alignment: Qt.AlignTop
            Layout.fillWidth: true

            TabButton {
                implicitHeight: 60
                text: "User Manager"
                background: Rectangle {
                    color: tabBar.currentIndex == 0 ? "steelblue" : "lightsteelblue"
                    radius: 3
                }
            }
            TabButton {
                implicitHeight: 60
                text: "Missions"
                background: Rectangle {
                    color: tabBar.currentIndex == 1 ? "coral" : "lightcoral"
                    radius: 3
                }
            }
            TabButton {
                implicitHeight: 60
                text: "Parcelles"
                background: Rectangle {
                    color: tabBar.currentIndex == 2 ? "mediumseagreen" : "lightgreen"
                    radius: 3
                }
            }
            TabButton {
                implicitHeight: 60
                text: "Questions"
                background: Rectangle {
                    color: tabBar.currentIndex == 3 ? "orange" : "gold"
                    radius: 3
                }
            }
            TabButton {
                height: 60
                text: "Settings"
                background: Rectangle {
                    color: tabBar.currentIndex == 4 ? "silver" : "lightgrey"
                    radius: 3
                }
            }
        }

        Item {
            Layout.fillHeight: true
            Layout.fillWidth: true

            StackLayout {
                id: tabV
                currentIndex: tabBar.currentIndex
                anchors.fill: parent

                UserManager {}
                MissionsView {}
                ParcelsView {}
                QuestionsEditor {
                    id: questionsEditor
                }
                SettingsEditor {
                    id: settingsEditor
                }
            }
        }

        Button {
            id: disconnectButton
            Layout.alignment: Qt.AlignRight
            padding: 10

            text: "Deconnexion"
            background: Rectangle {
                border.width: disconnectButton.activeFocus ? 2 : 1
                border.color: "pink"
                radius: 20
                color: "#C00"
            }

            onClicked: {
                //we save the flight param
                settingsEditor.save()

                //we save the questions
                questionsEditor.save()
                loginController.onAdminClosed()

                superAdminPopup.close()
            }
        }
    }
}
