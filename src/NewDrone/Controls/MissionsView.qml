import QtQuick 2.0
import QtQuick.Layouts 1.4
import QtQuick 2.1
import QtQuick.Controls 2.4
import QGroundControl 1.0
import QGroundControl.Controllers 1.0
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4

Item {
    ColumnLayout {
        anchors.fill: parent
        Rectangle {
            Layout.fillWidth: true
            Layout.fillHeight: true
            color: "white"

            SqlCustomModel {
                id: missionModel

                Component.onCompleted: {
                    setupForMission()
                }
            }

            TableView {
                id: missionTableView
                anchors.fill: parent
                selectionMode: SelectionMode.MultiSelection
                TableViewColumn {
                    role: "owner"
                    title: "Utilisateur"
                    movable: false
                    width: missionTableView.width / 2
                }
                TableViewColumn {
                    role: "name"
                    title: "Nom de la Mission"
                    movable: false
                    width: missionTableView.width / 2
                }

                model: missionModel
            }
        }

        Button {
            Layout.fillWidth: true
            Layout.margins: margin
            text: "Supprimer Mission"
            onClicked: {
                var selected = []
                missionTableView.selection.forEach(
                            function (rowIndex) {
                                console.log("Selected : " + rowIndex)
                                selected.push(rowIndex)
                            })
                missionTableView.selection.clear()

                loginController.deleteMission(missionModel,
                                               selected)
            }
        }
    }
}
