import QtQuick 2.0
import QtQuick.Layouts 1.4
import QtQuick 2.1
import QtQuick.Dialogs 1.2
import QtQuick.Controls 2.4
import QGroundControl 1.0
import QGroundControl.Controllers 1.0
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4
import NewDrone 1.0
import NewDrone.Controllers 1.0

Item {

    property var selectedForExport: []

    ParcelManagerController {
        id: _parcelManagerController
    }

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

        RowLayout {
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

        Button {
            Layout.fillWidth: true
            Layout.margins: margin
            text: "Export to file"
            onClicked: {
                if(parcelTableView.selection.count!==1) {
                    errorDialog.show("Please select one parcel to export.")
                }
                else {

                selectedForExport=[]
                parcelTableView.selection.forEach(
                            function (rowIndex) {
                                console.log("Selected : " + rowIndex)
                                selectedForExport.push(rowIndex)
                            })
                    parcelTableView.selection.clear()
                    var path = settingsEditorController.savePath
                    _parcelManagerController.exportParcel(
                                parcelModel, selectedForExport[0], path)
                }
            }
        }

      /*  Button {
            Layout.fillWidth: true
            Layout.margins: margin
            text: "Export to mail"
            onClicked: {
                if(parcelTableView.selection.count!==1) {
                    errorDialog.show("Please select one parcel to export.")
                }
                else {

                selectedForExport=[]
                parcelTableView.selection.forEach(
                            function (rowIndex) {
                                console.log("Selected : " + rowIndex)
                                selectedForExport.push(rowIndex)
                            })
                    parcelTableView.selection.clear()
                    _parcelManagerController.exportParcelToMail(parcelModel, selectedForExport[0])
                }
            }
        }*/
        }
    }

   /* FileDialog {
        id:             fileDialog
        title:          qsTr("Export Parcel")
        selectExisting: true
        selectMultiple: false
        selectFolder: true
        folder: shortcuts.home
        onAccepted: {
            var path = fileDialog.fileUrl.toString().replace("file://", "")
            _parcelManagerController.exportParcel(
                        parcelModel, selectedForExport[0], path)
            fileDialog.visible=false
        }
        onRejected: {
            fileDialog.visible=false
        }
    }*/


    SimpleDialog {
        id: errorDialog
        title: "Error"
    }

}
