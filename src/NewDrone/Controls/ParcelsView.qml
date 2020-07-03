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
                id: parcelModel

                Component.onCompleted: {
                    setupForParcel(true)
                }
            }

            TableView {
                id: parcelTableView
                anchors.fill: parent
                selectionMode: SelectionMode.MultiSelection
                TableViewColumn {
                    role: "owner"
                    title: "Username"
                    movable: false
                    width: 2 * parcelTableView.width / 5
                }
                TableViewColumn {
                    role: "name"
                    title: "Parcel Name"
                    movable: false
                    width: 2 * parcelTableView.width / 5
                }
                TableViewColumn {
                    role: "surface"
                    title: "Surface (ha)"
                    movable: false
                    width: parcelTableView.width / 5
                }

                model: parcelModel
            }
        }

        Button {
            Layout.fillWidth: true
            Layout.margins: margin
            text: "Delete Parcel"
            onClicked: {
                var selected = []
                parcelTableView.selection.forEach(
                            function (rowIndex) {
                                console.log("Selected : " + rowIndex)
                                selected.push(rowIndex)
                            })
                parcelTableView.selection.clear()

                _parcelManagerController.deleteParcel(
                            parcelModel, selected)
            }
        }
    }

}
