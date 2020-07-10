import QtQuick.Layouts 1.4
import QtQuick 2.1
import QtQuick.Controls 2.4
import QGroundControl 1.0
import QGroundControl.Controllers 1.0

import QGroundControl.Palette 1.0
import QGroundControl.ScreenTools 1.0
import QGroundControl.FlightDisplay 1.0
import QGroundControl.FlightMap 1.0

Popup {
    id: superAdminPopup
    modal: true
    padding: 20

    signal superAdminClosed()

    function disconnect() {
        if (settingsEditor.modified) {
            confirmDiscardModificationsAndDisconnect.show(
                        "You have unsaved settings.\nAre you sure you want to discard them and disconnect?")
            return
        }
        tabBar.setCurrentIndex(0)
        questionsEditor.onClosed()
        settingsWindow.setSource("")
        superAdminClosed()
        superAdminPopup.close()
    }

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
                text: "Parcels"
                background: Rectangle {
                    color: tabBar.currentIndex == 2 ? "mediumseagreen" : "lightgreen"
                    radius: 3
                }
            }
            TabButton {
                implicitHeight: 60
                text: "Parcel Manager"
                background: Rectangle {
                    color: tabBar.currentIndex == 3 ? "chartreuse" : "aquamarine"
                    radius: 3
                }
            }
            TabButton {
                implicitHeight: 60
                text: "Questions"
                background: Rectangle {
                    color: tabBar.currentIndex == 4 ? "orange" : "gold"
                    radius: 3
                }
            }
            TabButton {
                height: 60
                text: "Settings"
                background: Rectangle {
                    color: tabBar.currentIndex == 5 ? "silver" : "lightgrey"
                    radius: 3
                }
            }
            TabButton {
                height: 60
                text: "Advanced"
                background: Rectangle {
                    color: tabBar.currentIndex == 6 ? "plum" : "pink"
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
                Item {
                ParcelManager {
                    id: parcelManager
                    showAllUsers: true
                    allowEdit: false
                    onVisibleChanged: {
                        if(visible) {
                            parcelManager.show()
                        }
                        else {
                            parcelManager.hide()
                        }
                    }
                }
                }

                QuestionsEditor {
                    id: questionsEditor
                }
                SettingsEditor {
                    id: settingsEditor
                    isSuperAdmin: true
                }
                Item {
                    id: advanced
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                }
            }
        }

        Loader {
            id: settingsWindow
            visible: advanced.visible
            Layout.preferredHeight: advanced.height
            Layout.preferredWidth: advanced.width
            function close() {
                tabBar.setCurrentIndex(0)
            }

            //Needed properties from mainRootWindow
            property alias mainWindow: advanced
            property var activeVehicle: QGroundControl.multiVehicleManager.activeVehicle

            source: "qrc:/qml/AppSettings.qml"
        }

        Button {
            id: disconnectButton
            Layout.alignment: Qt.AlignRight
            padding: 10

            text: "Disconnect"
            background: Rectangle {
                border.width: disconnectButton.activeFocus ? 2 : 1
                border.color: "pink"
                radius: 20
                color: "#C00"
            }

            onClicked: {
                disconnect()
            }
        }
    }

    ConfirmationDialog {
        id: confirmDiscardModificationsAndDisconnect
        onAccepted: {
            settingsEditor.loadSettings()
            disconnect()
        }
    }
}
