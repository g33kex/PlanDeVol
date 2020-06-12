import QtQuick.Layouts 1.4
import QtQuick 2.1
import QtQuick.Controls 2.4
import QGroundControl 1.0
import QGroundControl.Controllers 1.0
//import QtQuick.Controls 1.4
//import QtQuick.Controls.Styles 1.4

Popup {
    id: adminPopup
    modal: true
    padding: 20

    contentItem: ColumnLayout {

        TabBar {
            id: tabBar
            // contentWidth: 220 * 7
            Layout.alignment: Qt.AlignTop
            Layout.fillWidth: true

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
                text: "Paramètres"
                background: Rectangle {
                    color: tabBar.currentIndex == 4 ? "silver" : "lightgrey"
                    radius: 3
                }
            }
            TabButton {
                implicitHeight: 60
                text: "Checklist"
                background: Rectangle {
                    color: tabBar.currentIndex == 5 ? "orchid" : "plum"
                    radius: 3
                }
            }
        }
        Item {

            Layout.fillWidth: true
            Layout.fillHeight: true
            StackLayout {
                id: tabV
                currentIndex: tabBar.currentIndex
                anchors.fill: parent

                MissionsView {}
                ParcelsView {}
                SettingsEditor {
                    id: parametersEditor
                }
                ChecklistEditor {
                    id: checkListEditor
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
                parametersEditor.save()

                loginController.onAdminClosed()

                adminPopup.close()
            }
        }
    }
}
