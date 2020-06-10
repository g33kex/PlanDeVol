import QtQuick 2.0
import QtQuick.Layouts 1.4
import QtQuick 2.1
import QtQuick.Controls 2.4
import QGroundControl 1.0
import QGroundControl.Controllers 1.0
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4
import NewDrone 1.0

Item {
    ColumnLayout {
        anchors.fill: parent
        Rectangle {
            Layout.fillWidth: true
            Layout.fillHeight: true
            color: "white"

            SqlCustomModel {
                id: parcelleModel

                Component.onCompleted: {
                    setupForParcelle()
                }
            }

            TableView {
                id: parcelleTableView
                anchors.fill: parent
                selectionMode: SelectionMode.MultiSelection
                TableViewColumn {
                    role: "owner"
                    title: "Utilisateur"
                    movable: false
                    width: 2 * parcelleTableView.width / 5
                }
                TableViewColumn {
                    role: "name"
                    title: "Nom de la Parcelle"
                    movable: false
                    width: 2 * parcelleTableView.width / 5
                }
                TableViewColumn {
                    role: "surface"
                    title: "Surface (ha)"
                    movable: false
                    width: parcelleTableView.width / 5
                }

                model: parcelleModel
            }
        }

        Button {
            Layout.fillWidth: true
            Layout.margins: margin
            text: "Supprimer Parcelle"
            onClicked: {
                var selected = []
                parcelleTableView.selection.forEach(
                            function (rowIndex) {
                                console.log("Selected : " + rowIndex)
                                selected.push(rowIndex)
                            })
                parcelleTableView.selection.clear()

                _parcelleManagerController.deleteParcelle(
                            parcelleModel, selected)
            }
        }
    }

}
