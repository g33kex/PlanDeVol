import QtQuick 2.0
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.0
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
        popup.open()
    }

   /* Dialog {
        id: _dialog
        title: "parcelleManager"
        modality: Qt.WindowModal
        standardButtons: Dialog.Ok | Dialog.Cancel
        visible: false

        onAccepted: console.log("Ok clicked")
        onRejected: console.log("Cancel clicked")
    }*/

   /* GridLayout {
        id: grid
        visible: false
        columns: 2
        Text { text: "Three"; font.bold: true; }
         Text { text: "words"; color: "red" }
         Text { text: "in"; font.underline: true }
         Text { text: "a"; font.pixelSize: 20 }
         Text { text: "row"; font.strikeout: true }

         Rectangle { id: one }
         Rectangle { id: two }

    }*/
   /* Window {
        visible: true
        modality: Qt.WindowModal
        Rectangle {
        id: page
        width: 320; height: 480
        color: "lightgray"

        Text {
            id: helloText
            text: "Hello world!"
            y: 30
            anchors.horizontalCenter: page.horizontalCenter
            font.pointSize: 24; font.bold: true
        }
    }
    }*/
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
               /* ListView {
                    Layout.columnSpan: 3
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    model: _parcelleManagerController.getSqlParcelleModel()
                }*/
               Rectangle {
                    Layout.columnSpan: 3
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    color: "white"
                    id: page1

                    Text {
                        id: name
                        anchors.fill: parent
                        text: parcelleSqlModel.name
                        font.bold: true; font.pointSize: 16
                        color: "white"
                    }

                    Text {
                        anchors.fill: parent
                        text: "Amount: " + parcelleSqlModel.qta
                        font.pointSize: 16
                        opacity: 1
                        color: "white"
                    }

                    ListModel {
                        id: nameModel
                        ListElement { name: "Alice" }
                        ListElement { name: "Bob" }
                        ListElement { name: "Jane" }
                        ListElement { name: "Harry" }
                        ListElement { name: "Wendy" }
                    }
                    Component {
                        id: nameDelegate
                        Text {
                            text: name;
                            font.pixelSize: 24
                        }
                    }

                    ListView {
                        anchors.fill: parent
                        clip: true
                        model: nameModel
                        delegate: nameDelegate
                        header: bannercomponent
                        footer: Rectangle {
                            width: parent.width; height: 30;
                            gradient: clubcolors
                        }
                        highlight: Rectangle {
                            width: parent.width
                            color: "lightgray"
                        }
                    }

                    Component {     //instantiated when header is processed
                        id: bannercomponent
                        Rectangle {
                            id: banner
                            width: parent.width; height: 50
                            gradient: clubcolors
                            border {color: "#9EDDF2"; width: 2}
                            Text {
                                anchors.centerIn: parent
                                text: "Club Members"
                                font.pixelSize: 32
                            }
                        }
                    }
                    Gradient {
                        id: clubcolors
                        GradientStop { position: 0.0; color: "#8EE2FE"}
                        GradientStop { position: 0.66; color: "#7ED2EE"}
                    }
               }

                  /*ListModel {
                      id: myModel
                      ListElement { type: "Dog"; age: 8 }
                      ListElement { type: "Cat"; age: 5 }
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

                  ListView {
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
                        _parcelleManagerController.addParcelle()
                    }
                }
                Button {
                    Layout.fillWidth: true
                    Layout.margins : margin
                    text: "Remove Parcelle"
                    onClicked: {
                        _parcelleManagerController.deleteParcelle()
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
                    //Layout.preferredWidth: parent.width/2
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
               /* GroupBox {
                title:"map types"
                               ComboBox{
                                  model:map.supportedMapTypes
                                   textRole:"description"
                                   onCurrentIndexChanged: {map.activeMapType = map.supportedMapTypes[currentIndex]; print(currentIndex); print(map.supportedMapTypes[currentIndex])}

                               }
                }*/

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

      /*   ColumnLayout {
               id: mainLayout
               anchors.fill: parent
               anchors.margins: margin
               GroupBox {
                   id: rowBox
                   title: "Row layout"
                   Layout.fillWidth: true

                   RowLayout {
                       id: rowLayout
                       anchors.fill: parent
                       TextField {
                           placeholderText: "This wants to grow horizontally"
                           Layout.fillWidth: true
                       }
                       Button {
                           text: "Button"
                       }
                   }
               }

               GroupBox {
                   id: gridBox
                   title: "Grid layout"
                   Layout.fillWidth: true

                   GridLayout {
                       id: gridLayout
                       rows: 3
                       flow: GridLayout.TopToBottom
                       anchors.fill: parent

                       Label { text: "Line 1" }
                       Label { text: "Line 2" }
                       Label { text: "Line 3" }

                       TextField { }
                       TextField { }
                       TextField { }

                       TextArea {
                           text: "This widget spans over three rows in the GridLayout.\n"
                               + "All items in the GridLayout are implicitly positioned from top to bottom."
                           Layout.rowSpan: 3
                           Layout.fillHeight: true
                           Layout.fillWidth: true
                       }
                   }
               }
               TextArea {
                   id: t3
                   text: "This fills the whole cell"
                   Layout.minimumHeight: 30
                   Layout.fillHeight: true
                   Layout.fillWidth: true
               }
               GroupBox {
                   id: stackBox
                   title: "Stack layout"
                   implicitWidth: 200
                   implicitHeight: 60
                   Layout.fillWidth: true
                   Layout.fillHeight: true
                   StackLayout {
                       id: stackLayout
                       anchors.fill: parent

                       function advance() { currentIndex = (currentIndex + 1) % count }

                       Repeater {
                           id: stackRepeater
                           model: 5
                           Rectangle {
                               color: Qt.hsla((0.5 + index)/stackRepeater.count, 0.3, 0.7, 1)
                               Button { anchors.centerIn: parent; text: "Page " + (index + 1); onClicked: { stackLayout.advance() } }
                           }
                       }
                   }
               }
         }*/
    }



}
