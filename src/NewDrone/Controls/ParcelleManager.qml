import QtQuick 2.0
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.4
import QtQuick.Controls 1.4
import QtGraphicalEffects 1.0
import QtLocation 5.11
import QtPositioning 5.11

import QGroundControl 1.0
import QGroundControl.Controllers 1.0

Item {
    id: element

    property int margin: 5
    anchors.fill: parent

    ParcelleManagerController {
        id: _parcelleManagerController
        onDownloadEnded: {
            addParcelleProgressOverlay.close()
            if (success) {
                downloadSuccessDialog.open()
                map.updateParcelles()
            } else {
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
                                title: "Utilisateur"
                                movable: false
                                width: 2 * tableView.width / 8
                            }
                            TableViewColumn {
                                role: "name"
                                title: "Nom de la Parcelle"
                                movable: false
                                width: 3 * tableView.width / 8
                            }
                            TableViewColumn {
                                role: "surface"
                                title: "Surface (ha)"
                                movable: false
                                width: 3 * tableView.width / 8
                            }

                            model: parcelleModel

                            onClicked: {
                                console.log("SELECTION CHANGED, COUNT=" + selection.count)
                                if (tableView.selection.count === 1) {
                                    var sel = 0
                                    tableView.selection.forEach(
                                                function (rowIndex) {
                                                    sel = rowIndex
                                                })
                                    questionsView3.populateQA(parcelleModel,
                                                              sel)
                                } else {
                                    questionsView3.clear()
                                }
                            }
                        }
                    }

                    Rectangle {
                        Layout.columnSpan: 3
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        color: "white"

                        QuestionsView {
                            id: questionsView3
                            anchors.fill: parent
                            allowAnswers: false
                        }
                    }

                    Button {
                        Layout.fillWidth: true
                        Layout.margins: margin
                        text: "Ajouter"

                        onClicked: {
                            if (QGroundControl.settingsManager.appSettings.nbParcelle) {
                                addParcelleDialog.reset()
                                addParcelleDialog.open()
                            } else {
                                messageDialog_toomuch.open()
                            }
                        }
                    }
                    Button {
                        id: removeParcelle
                        Layout.fillWidth: true
                        Layout.margins: margin
                        text: "Supprimer"
                        signal adminVerified
                        onClicked: {
                            removeParcelle.adminVerified.connect(
                                        deleteParcelleOnAdminVerifed)
                            admin.open()
                        }

                        function deleteParcelleOnAdminVerifed() {
                            adminVerified.disconnect(
                                        deleteParcelleOnAdminVerifed)
                            var selected = []
                            tableView.selection.forEach(function (rowIndex) {
                                console.log("Selected : " + rowIndex)
                                selected.push(rowIndex)
                            })
                            tableView.selection.clear()
                            _parcelleManagerController.deleteParcelle(
                                        parcelleModel, selected)
                            map.updateParcelles()
                        }
                    }
                    Button {

                        Layout.margins: margin
                        Layout.fillWidth: true

                        Layout.alignment: Qt.AlignHCenter
                        text: "Modifier"

                        onClicked: {
                            if (tableView.selection.count === 1) {
                                var sel = 0
                                tableView.selection.forEach(
                                            function (rowIndex) {
                                                sel = rowIndex
                                            })
                                editParcelleDialog.parcelleIndex = sel
                                editParcelleDialog.refresh()
                                editParcelleDialog.open()
                            } else {
                                errorModifyOnlyOneParcelleDialog.open()
                            }
                        }
                    }
                    Button {
                        Layout.fillWidth: true
                        Layout.margins: margin
                        Layout.columnSpan: 2
                        text: "Ajouter à la mission"
                        onClicked: {
                            var selected = []
                            tableView.selection.forEach(function (rowIndex) {
                                selected.push(rowIndex)
                            })
                            tableView.selection.clear()

                            _parcelleManagerController.addToMission(
                                        parcelleModel,
                                        _planMasterController.missionController,
                                        selected)
                            parcelleManagerPopup.close()
                        }
                    }

                    Button {
                        Layout.fillWidth: true
                        Layout.margins: margin
                        text: "Ok"
                        onClicked: {
                            parcelleManagerPopup.close()
                        }
                    }
                }
            }
            Plugin {
                id: mapPlugin
                name: "esri"
            }

            Map {
                id: map
                Layout.fillHeight: true
                Layout.fillWidth: true
                Layout.margins: margin
                plugin: mapPlugin
                zoomLevel: 14
                activeMapType: map.supportedMapTypes[1]

                property var parcelles
                property var names

                function updateParcelles() {
                    map.clearMapItems()
                    parcelles = _parcelleManagerController.getParcelleList()
                    names = _parcelleManagerController.getParcelleNames()
                    for (var i = 0; i < parcelles.length; i++) {
                        if (zoomLevel > 11) {
                            var polygon = Qt.createQmlObject(
                                        'import QtLocation 5.3; MapPolygon {}',
                                        map)
                            polygon.path = parcelles[i]
                            polygon.color = "#50FFA500"
                            polygon.border.width = 5
                            polygon.border.color = "red"
                            map.addMapItem(polygon)
                        } else {
                            var parcelleIndicator = Qt.createQmlObject('
import QtLocation 5.3;import QtQuick 2.0; MapQuickItem {sourceItem: Rectangle {
width: 25
height: 25
border.width: 5
color: "red"
}}', map)
                            parcelleIndicator.coordinate = parcelles[i][0]
                            map.addMapItem(parcelleIndicator)
                        }

                        var label = Qt.createQmlObject('
import QtLocation 5.3; import QtQuick.Controls 2.4; MapQuickItem {
anchorPoint.x: -30
anchorPoint.y: 0

sourceItem: Label {
id: source
color: "pink"
font.pixelSize : 22
font.bold : true
text: "' + names[i] + '"}}', map)
                        label.coordinate = parcelles[i][0]
                        map.addMapItem(label)
                    }
                }

                onZoomLevelChanged: {
                    updateParcelles()
                }

                Component.onCompleted: {

                    updateParcelles()
                    if (parcelles.length > 0) {
                        map.center = parcelles[0][0]
                    }
                }
            }
        }

        Dialog {
            id: editParcelleDialog

            x: (element.width - width) / 2
            y: (element.height - height) / 2
            width: 4 * element.width / 5
            height: 4 * element.height / 5

            modal: true

            property int parcelleIndex: 0

            function refresh() {
                ownerField.updateContent()
                fileField.updateContent()
                questionsView.populateQA(parcelleModel, parcelleIndex)
            }

            onAccepted: {
                _parcelleManagerController.modifyParcelle(
                            parcelleModel, parcelleIndex, ownerField.text,
                            fileField.text, questionsView.getAnswers(),
                            questionsView.getComboAnswers())
                map.updateParcelles()
                questionsView3.clear()
            }

            title: "Modifier Parcelle"

            standardButtons: Dialog.Ok | Dialog.Cancel

            GridLayout {
                columns: 2
                anchors.fill: parent

                Label {
                    text: "Utilisateur"
                }
                Label {
                    text: "Nom"
                }
                TextField {
                    id: ownerField
                    enabled: false
                    function updateContent() {
                        text = parcelleModel.getRecordValue(
                                    editParcelleDialog.parcelleIndex, "owner")
                    }
                }
                TextField {
                    id: fileField
                    enabled: false
                    function updateContent() {
                        text = parcelleModel.getRecordValue(
                                    editParcelleDialog.parcelleIndex, "name")
                    }
                }

                QuestionsView {
                    id: questionsView
                    Layout.columnSpan: 2
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    Layout.minimumHeight: 100
                }
            }
        }

        Dialog {
            id: addParcelleDialog

            x: (element.width - width) / 2
            y: (element.height - height) / 2
            width: 4 * element.width / 5
            height: 4 * element.height / 5
            modal: true

            onAccepted: {
                if (a_ilotField.length > 0 && a_fileField.length > 0) {
                    if (_parcelleManagerController.checkIfExist(
                                QGroundControl.settingsManager.appSettings.missionSavePath
                                + "/" + a_fileField.text)) {
                        _parcelleManagerController.addParcelle(
                                    parcelleModel, a_ilotField.text,
                                    QGroundControl.settingsManager.appSettings.missionSavePath
                                    + "/" + a_fileField.text,
                                    questionsView2.getAnswers(),
                                    questionsView2.getComboAnswers())
                        addParcelleProgressOverlay.open()
                    } else {
                        parcelleExistsDialog.open()
                    }
                } else {
                    champVideDialog.open()
                }
            }

            Popup {
                id: addParcelleProgressOverlay

                parent: Overlay.overlay

                closePolicy: Popup.NoAutoClose
                modal: true

                x: Math.round((parent.width - width) / 2)
                y: Math.round((parent.height - height) / 2)
                width: 100
                height: 100

                BusyIndicator {
                    anchors.fill: parent
                }
            }

            function reset() {
                a_ilotField.text = ""
                a_fileField.text = ""
                questionsView2.populateQA(parcelleModel, -1)
            }

            title: "Ajouter Parcelle"

            standardButtons: Dialog.Ok | Dialog.Cancel

            GridLayout {
                columns: 2
                anchors.fill: parent

                Label {
                    text: "Numéro d'ilot"
                }
                Label {
                    text: "Nom du fichier"
                }
                TextField {
                    id: a_ilotField
                }
                TextField {
                    id: a_fileField
                }
                QuestionsView {
                    id: questionsView2
                    Layout.columnSpan: 2
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    Layout.minimumHeight: 100
                }
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
        Label {
            text: "Choisisser une parcelle à modifier"
        }
    }

    Dialog {
        id: messageDialog_toomuch
        standardButtons: Dialog.Ok
        x: (parent.width - width) / 2
        y: (parent.height - height) / 2
        modal: true
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
        modal: true
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
        modal: true
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
        modal: true
        title: "Error"
        Label {
            anchors.centerIn: parent
            text: "La parcelle existe déja!"
        }
    }

    Dialog {
        id: champVideDialog
        standardButtons: Dialog.Ok
        x: (parent.width - width) / 2
        y: (parent.height - height) / 2
        modal: true
        title: "Error"
        Label {
            anchors.centerIn: parent
            text: "Le champs numero d'ilot ou nom est vide"
        }
    }

    Dialog {
        id: admin
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
            if (_parcelleManagerController.verif("admin", a_password.text)) {
                removeParcelle.deleteParcelleOnAdminVerifed()
            }
            a_password.text = ""
        }
    }
}
