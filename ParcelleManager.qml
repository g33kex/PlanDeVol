import QtQuick 2.0
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.0
import QtQuick.Controls 1.4
import QtGraphicalEffects 1.0
import QtLocation 5.11
import QtPositioning 5.11
import QtQuick.Dialogs 1.2


import QGroundControl                   1.0
import QGroundControl.Controllers       1.0





Item {
    id: element

    property int margin: 5

    anchors.fill: parent

    ParcelleManagerController {
        id: _parcelleManagerController
    }

    function show() {
        parcelleModel.setupForParcelle()
        parcelleManagerPopup.open()
    }

    Popup {
         id: parcelleManagerPopup
         width: parent.width
         height: parent.height


         modal: true
         focus: true
         background: Rectangle {
              color: "#C0C0C0"
             }
         closePolicy: Popup.CloseOnEscape

        RowLayout {
            anchors.fill: parent
            anchors.margins: margin

            Item {
                Layout.fillHeight: true
                Layout.fillWidth: true
                Layout.margins: margin

            GridLayout {
                id: rowLayout
                columns: 3
                rows: 3
                anchors.fill: parent
               Rectangle {
                    Layout.columnSpan: 3
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    color: "white"
                    id: page1

                    SqlParcelleModel {
                        id: parcelleModel

                    }

                    TableView {
                        id: tableView
                        anchors.fill: parent
                        selectionMode: SelectionMode.MultiSelection
                        TableViewColumn {
                            role: "owner"
                            title: "Owner"
                            movable: false
                            width: 2*tableView.width/8
                        }
                        TableViewColumn {
                            role: "parcelleFile"
                            title: "ParcelleFile"
                            movable : false
                            width: 4*tableView.width/8
                        }
                        TableViewColumn {
                            role: "type"
                            title: "Type"
                            movable: false
                            width: tableView.width/8
                        }
                        TableViewColumn {
                            role: "speed"
                            title: "Speed"
                            movable: false
                            width: tableView.width/8
                        }

                        model: parcelleModel
                    }
               }
                  Component {
                      id: myDelegate
                      Rectangle {
                        color: "gray"
                        Text {
                            text: type + ", " + age
                        }
                      }
                  }

                Button {
                    Layout.fillWidth: true
                    Layout.margins : margin
                    text: "Add Parcelle"
                    onClicked: {
                        addParcelleDialog.open()
                    }
                }
                Button {
                    Layout.fillWidth: true
                    Layout.margins : margin
                    text: "Remove Parcelle"
                        onClicked: {
                                var selected=[]
                                tableView.selection.forEach( function(rowIndex) {console.log("Selected : "+rowIndex);selected.push(rowIndex)} )
                                tableView.selection.clear()

                                _parcelleManagerController.deleteParcelle(parcelleModel,selected)
                           }
                }
                Button {
                    Layout.fillWidth: true
                    Layout.margins : margin
                    text: "Insert Parcelle to Mission"
                    onClicked: {
                            var selected = []
                            tableView.selection.forEach( function(rowIndex) {selected.push(rowIndex)} )
                            tableView.selection.clear()

                            _parcelleManagerController.addToMission(parcelleModel,_planMasterController.missionController,selected)
                       }
                }
                Button {

                    Layout.margins : margin
                    Layout.fillWidth: true

                    Layout.alignment: Qt.AlignHCenter
                    text: "Modify Parcelle"

                    onClicked: {
                        if(tableView.selection.count===1) {
                            var sel=0
                            tableView.selection.forEach(function(rowIndex) {sel=rowIndex})
                            editParcelleDialog.parcelleIndex=sel
                            editParcelleDialog.refresh()
                            editParcelleDialog.open()
                        }
                        else {
                            errorModifyOnlyOneParcelleDialog.open()
                        }
                    }

                }
                Button {
                    Layout.fillWidth: true
                    Layout.margins: margin
                    text: "Cancel"
                    onClicked: {
                        parcelleManagerPopup.close()
                    }
                 }
            }
            }
            Plugin {
                   id: mapPlugin
                   //name: "osm" // "mapboxgl", "esri", ...
                   //name: "mapboxgl"
                   name: "esri"
                   // specify plugin parameters if necessary
                   // PluginParameter {
                   //     name:
                   //     value:
                   // }
            }

            Map {
                id: map
                Layout.fillHeight: true
                Layout.fillWidth: true
                Layout.margins: margin
                plugin: mapPlugin
                center: QtPositioning.coordinate(59.91, 10.75) // Oslo
                zoomLevel: 14
                activeMapType: map.supportedMapTypes[1]

            }


        }


        Dialog {
            id: editParcelleDialog

            property int parcelleIndex: 0

            function refresh() {
                ownerField.updateContent()
                fileField.updateContent()
                typeField.updateContent()
                speedBox.updateContent()
            }

            onYes: {
                _parcelleManagerController.modifyParcelle(parcelleModel, parcelleIndex, ownerField.getText(), fileField.getText(), typeField.getText(), speedBox.value)
            }


            title: "Edit Parcelle"

            standardButtons: Dialog.Ok | Dialog.Cancel

            GridLayout {
                columns: 4
                anchors.fill: parent

                Label {
                    text: "Owner"
                }
                Label {
                    text: "ParcelleFile"
                }
                Label {
                    text: "Type"
                }
                Label {
                    text: "Speed"

                }
                TextField {
                    id: ownerField
                    enabled: false
                    function updateContent() {
                        text=parcelleModel.getRecordValue(editParcelleDialog.parcelleIndex, "owner")
                    }
                }
                TextField {
                    id: fileField
                    function updateContent() {
                        text=parcelleModel.getRecordValue(editParcelleDialog.parcelleIndex, "parcelleFile")
                    }
                }
                TextField {
                    id: typeField
                    function updateContent() {
                        text=parcelleModel.getRecordValue(editParcelleDialog.parcelleIndex, "type")
                    }
                }
                SpinBox {
                    id: speedBox
                    function updateContent() {
                        value=parcelleModel.getRecordValue(editParcelleDialog.parcelleIndex, "speed")
                    }
                }


            }


        }

        Dialog {
            id: addParcelleDialog


            onYes: {
                _parcelleManagerController.addParcelle(parcelleModel, a_ilotNumberField.getText(), a_fileField.getText(), a_typeField.getText(), a_speedBox.value)
            }


            title: "Edit Parcelle"

            standardButtons: Dialog.Ok | Dialog.Cancel

            GridLayout {
                columns: 4
                anchors.fill: parent

                Label {
                    text: "Ilot number"
                }
                Label {
                    text: "ParcelleFile"
                }
                Label {
                    text: "Type"
                }
                Label {
                    text: "Speed"

                }
                TextField {
                    id: a_ilotField
                }
                TextField {
                    id: a_fileField
                }
                TextField {
                    id: a_typeField
                }
                SpinBox {
                    id: a_speedBox
                }


            }


        }

        Dialog {
            id: errorModifyOnlyOneParcelleDialog
            title: "Error"
            Label{
                text: "Please select ONE Parcelle to modify."
            }

        }
    }


}
