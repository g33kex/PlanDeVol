import QtQuick 2.0
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.4
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
        onDownloadEnded: {
            if(success) {
                downloadSuccessDialog.open()
                map.updateParcelles()
            }
            else {
                downloadFailureDialog.open()
            }
        }
    }


    function show() {
        _parcelleManagerController.updateModel(parcelleModel)

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

                    SqlCustomModel {
                        id: parcelleModel

                        Component.onCompleted: {
                            setupForParcelle()
                        }

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
                            role: "name"
                            title: "name of the Parcelle"
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
                Button {
                    Layout.fillWidth: true
                    Layout.margins : margin
                    text: "Add Parcelle"

                    onClicked: {
                        if(QGroundControl.settingsManager.appSettings.nbParcelle) {
                            addParcelleDialog.reset()
                            addParcelleDialog.open()
                        }
                        else {
                            messageDialog_toomuch.open()
                        }

                    }
                }
                Button {
                    id: removeParcelle
                    Layout.fillWidth: true
                    Layout.margins : margin
                    text: "Remove Parcelle"
                    signal adminVerified()
                        onClicked: {
                                removeParcelle.adminVerified.connect(deleteParcelleOnAdminVerifed)
                                admin.open()
                           }


                        function deleteParcelleOnAdminVerifed() {
                            adminVerified.disconnect(deleteParcelleOnAdminVerifed)
                            var selected=[]
                            tableView.selection.forEach( function(rowIndex) {console.log("Selected : "+rowIndex);selected.push(rowIndex)} )
                            tableView.selection.clear()
                            _parcelleManagerController.deleteParcelle(parcelleModel,selected)
                            map.updateParcelles()
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
                            parcelleManagerPopup.close()
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
                    text: "Done"
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
                zoomLevel: 14
                activeMapType: map.supportedMapTypes[1]

                property var parcelles;

                function updateParcelles() {
                    map.clearMapItems()
                    parcelles=_parcelleManagerController.getParcelleList()
                    for(var i=0; i<parcelles.length; i++) {
                        if(zoomLevel>11) {
                            var polygon = Qt.createQmlObject('import QtLocation 5.3; MapPolygon {}', map)
                            polygon.path = parcelles[i]
                            polygon.color = "#50FFA500"
                            polygon.border.width = 5
                            polygon.border.color = "red"
                            map.addMapItem(polygon)
                        }
                        else
                        {
                            var parcelleIndicator = Qt.createQmlObject('import QtLocation 5.3;import QtQuick 2.0; MapQuickItem {sourceItem: Rectangle {
                                width: 25
                                height: 25
                                border.width: 5
                                color: "red"
                            }}', map)
                           /* circle.color = "red"
                            circle.radius = 5000.0/map.zoomLevel
                            circle.center = parcelles[i][0]*/
                            parcelleIndicator.coordinate = parcelles[i][0]
                            map.addMapItem(parcelleIndicator)
                        }
                    }
                }

                onZoomLevelChanged: {
                    updateParcelles()
                }

                Component.onCompleted: {

                    updateParcelles()
                    map.center=parcelles[0][0]

                  /* console.log("PARCELLE LIST LENGTH:"+parcelles.length)
                    for(var i=0; i<parcelles.length; i++) {


                     //  for(var j=0;j<parcelles[i].length;j++) {
                            //console.log("Parcelle "+i+" "+j+" = "+parcelles[i][j])
                            /* var circle = Qt.createQmlObject('import QtLocation 5.3; MapCircle {}', map)
                            circle.center=parcelles[i][j]

                            circle.radius = 5.0
                            circle.color = 'green'
                            circle.border.width = 3
                            map.addMapItem(circle)
                            map.center=parcelles[i][j]

                           var circle2 = Qt.createQmlObject('import QtLocation 5.3; MapCircle {}', map)
                           circle2.center=parcelles[i][j]

                           circle2.radius = 500
                           circle2.border.width = 20
                           map.addMapItem(circle2)*/

                       // }


                    }
            }


        }


        Dialog {
            id: editParcelleDialog

            x: (parent.width - width) / 2
            y: (parent.height - height) / 2
            modal: true

            property int parcelleIndex: 0

            function refresh() {
                ownerField.updateContent()
                fileField.updateContent()
                typeField.updateContent()
                speedBox.updateContent()
            }

            onAccepted: {
                _parcelleManagerController.modifyParcelle(parcelleModel, parcelleIndex, ownerField.text, fileField.text, typeField.text, speedBox.value)
                map.updateParcelles()
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
                    text: "Name"
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
                    enabled: false
                    function updateContent() {
                        text=parcelleModel.getRecordValue(editParcelleDialog.parcelleIndex, "name")
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
                    maximumValue: 3
                    minimumValue: 1
                    function updateContent() {
                        value=parcelleModel.getRecordValue(editParcelleDialog.parcelleIndex, "speed")
                    }
                }


            }


        }

        Dialog {
            id: addParcelleDialog

            x: (parent.width - width) / 2
            y: (parent.height - height) / 2
            modal: true


            onAccepted: {
                if(_parcelleManagerController.checkIfExist(QGroundControl.settingsManager.appSettings.missionSavePath + "/" + a_fileField.text)) {
                    parcelleExistsDialog.open()
                }
                else {
                _parcelleManagerController.addParcelle(parcelleModel, a_ilotField.text, QGroundControl.settingsManager.appSettings.missionSavePath + "/" + a_fileField.text, a_typeField.text, a_speedBox.value)
                }
           }

            function reset() {
                a_ilotField.text = ""
                a_fileField.text = ""
                a_typeField.text = ""
            }


            title: "Add Parcelle"

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
                    maximumValue: 3
                    minimumValue: 1
                    id: a_speedBox
                }


            }


        }

        Dialog {
            id: errorModifyOnlyOneParcelleDialog
            standardButtons: Dialog.Ok
            x: (parent.width - width) / 2
            y: (parent.height - height) / 2
            modal: true
            title: "Error"
            Label{
                text: "Please select ONE Parcelle to modify."
            }

        }
    }


    Dialog {
        id: messageDialog_toomuch
        standardButtons: Dialog.Ok
        x: (parent.width - width) / 2
        y: (parent.height - height) / 2
        modal:true
        title: "Warning"
        Label {
            anchors.centerIn: parent
            text: "Limite de parcelles enregistrées atteintes."
        }
    }

    Dialog {
        id: downloadSuccessDialog
        standardButtons: Dialog.Ok
        x: (parent.width - width) / 2
        y: (parent.height - height) / 2
        modal:true
        title: "Success"
        Label {
            anchors.centerIn: parent
            text: "Parcelle téléchargée avec succès."
        }
    }

    Dialog {
        id: downloadFailureDialog
        standardButtons: Dialog.Ok
        x: (parent.width - width) / 2
        y: (parent.height - height) / 2
        modal:true
        title: "Error"
        Label {
            anchors.centerIn: parent
            text: "Impossible de télécharger la parcelle."
        }
    }

    Dialog {
        id: parcelleExistsDialog
        standardButtons: Dialog.Ok
        x: (parent.width - width) / 2
        y: (parent.height - height) / 2
        modal:true
        title: "Error"
        Label {
            anchors.centerIn: parent
            text: "La parcelle existe déja!"
        }
    }

    Dialog {
        id : admin
        title: "Admin"
        standardButtons: Dialog.Ok | Dialog.Cancel
        x: (parent.width - width) / 2
        y: (parent.height - height) / 2
        modal: true
        property bool verif: false
        GridLayout {
            columns: 2
            anchors.fill: parent

            Label {
                text: "username"
            }
            TextField {
                id: a_username
                enabled: false
                text: "admin"
            }
            Label {
                text: "password"
            }
            TextField {
                id: a_password
                echoMode: TextInput.Password
            }

        }
        onAccepted: {
            if(_parcelleManagerController.verif("admin", a_password.text)) {
                removeParcelle.deleteParcelleOnAdminVerifed()
            }
            a_password.text=""
        }
    }

}
