import QtQuick 2.0
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.0
import QtQuick.Controls 1.4
import QtGraphicalEffects 1.0
import QtLocation 5.11
import QtPositioning 5.11


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
        popup.open()
    }

    Popup {
         id: popup
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
                   /* ListView {
                        anchors.fill: parent
                        model: parcelleModel
                        delegate: Text { text: parcelleModel.owner }
                    }*/
                    TableView {
                        id: tableView
                        anchors.fill: parent
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

                  /*ListModel {
                      id: myModel
                      ListElement { type: "Dog"; age: 8 }
                      ListElement { type: "Cat"; age: 5 }
                  }*/

                  Component {
                      id: myDelegate
                      Rectangle {
                        color: "gray"
                        Text {
                            text: type + ", " + age
                        }
                      }
                  }

                 /* ListView {
                      anchors.fill: parent
                      model: myModel
                      delegate: myDelegate
                      highlight: highlightBar
                      highlightFollowsCurrentItem: false
                  }*/



                Button {
                    Layout.fillWidth: true
                    Layout.margins : margin
                    text: "Add Parcelle"
                    onClicked: {
                        _parcelleManagerController.addParcelle(parcelleModel)
                    }
                }
                Button {
                    Layout.fillWidth: true
                    Layout.margins : margin
                    text: "Remove Parcelle"
                    onClicked: {
                        tableView.selection.forEach( function(rowIndex) {
                            console.log(rowIndex)
                            _parcelleManagerController.deleteParcelle(parcelleModel,rowIndex)
                        } )
                    }
                }
                Button {
                    Layout.fillWidth: true
                    Layout.margins : margin
                    text: "Insert to Mission"
                    onClicked: {
                        _parcelleManagerController.addToMission()
                    }
                }
                Button {

                    Layout.margins : margin
                    Layout.columnSpan: 2
                    Layout.fillWidth: true

                    Layout.alignment: Qt.AlignHCenter
                    text: "Save to database"

                }
                Button {
                    Layout.fillWidth: true
                    text: "Cancel"
                    onClicked: {
                        popup.close()
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
    }


}
