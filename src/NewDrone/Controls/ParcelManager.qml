import QtQuick 2.0
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.4
import QtQuick.Controls 1.4
import QtGraphicalEffects 1.0
import QtLocation 5.11
import QtPositioning 5.11

import QGroundControl 1.0
import QGroundControl.Controllers 1.0

import NewDrone 1.0
import NewDrone.Controllers 1.0

Item {
    id: element

    property int margin: 5
    anchors.fill: parent

    property bool showAllUsers: false
    property bool allowEdit: true

    ParcelManagerController {
        id: _parcelManagerController
        onDownloadEnded: {
            addParcelProgressOverlay.close()
            if (success) {
                downloadSuccessDialog.open()
                map.updateParcell()
            } else {
                downloadFailureDialog.open()
            }
        }
    }

    function show() {
        _parcelManagerController.updateModel(parcelModel, showAllUsers)

        parcelManagerPopup.open()
    }

    function hide() {
        parcelManagerPopup.close()
    }

    Popup {
        id: parcelManagerPopup
        width: element.width
        height: element.height

        modal: allowEdit
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
                            id: parcelModel

                            Component.onCompleted: {
                                setupForParcel(showAllUsers)
                            }
                        }

                        TableView {
                            id: tableView
                            anchors.fill: parent
                            selectionMode: SelectionMode.MultiSelection
                            TableViewColumn {
                                role: "owner"
                                title: "Username"
                                movable: false
                                width: 2 * tableView.width / 8
                            }
                            TableViewColumn {
                                role: "name"
                                title: "Parcel Name"
                                movable: false
                                width: 3 * tableView.width / 8
                            }
                            TableViewColumn {
                                role: "surface"
                                title: "Surface (ha)"
                                movable: false
                                width: 3 * tableView.width / 8
                            }

                            model: parcelModel

                            onClicked: {
                                console.log("SELECTION CHANGED, COUNT=" + selection.count)
                                if (tableView.selection.count === 1) {
                                    var sel = 0
                                    tableView.selection.forEach(
                                                function (rowIndex) {
                                                    sel = rowIndex
                                                })
                                    questionsView3.populateQA(parcelModel,
                                                              sel)
                                } else {
                                    questionsView3.clear()
                                }
                            }
                        }
                    }

                    Rectangle {
                        visible: allowEdit
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
                        visible: allowEdit
                        Layout.fillWidth: true
                        Layout.margins: margin
                        text: "Ajouter"

                        onClicked: {
                            if (QGroundControl.settingsManager.appSettings.nbParcel) {
                                addParcelDialog.reset()
                                addParcelDialog.open()
                            } else {
                                messageDialog_toomuch.open()
                            }
                        }
                    }
                    Button {
                        visible: allowEdit
                        id: removeParcel
                        Layout.fillWidth: true
                        Layout.margins: margin
                        text: "Supprimer"
                        signal adminVerified
                        onClicked: {
                            removeParcel.adminVerified.connect(
                                        deleteParcelOnAdminVerifed)
                            admin.open()
                        }

                        function deleteParcelOnAdminVerifed() {
                            adminVerified.disconnect(
                                        deleteParcelOnAdminVerifed)
                            var selected = []
                            tableView.selection.forEach(function (rowIndex) {
                                console.log("Selected : " + rowIndex)
                                selected.push(rowIndex)
                            })
                            tableView.selection.clear()
                            parcelManagerController.deleteParcel(
                                        parcelModel, selected)
                            map.updateParcels()
                        }
                    }
                    Button {
                        visible: allowEdit
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
                                editParcelDialog.parcelIndex = sel
                                editParcelDialog.refresh()
                                editParcelDialog.open()
                            } else {
                                errorModifyOnlyOneParcelDialog.open()
                            }
                        }
                    }
                    Button {
                        visible: allowEdit
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

                            _parcelManagerController.addToMission(
                                        parcelModel,
                                        _planMasterController.missionController,
                                        selected)
                            parcelManagerPopup.close()
                        }
                    }

                    Button {
                        visible: allowEdit
                        Layout.fillWidth: true
                        Layout.margins: margin
                        text: "Ok"
                        onClicked: {
                            parcelManagerPopup.close()
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

                property var parcels
                property var names

                function updateParcels() {
                    map.clearMapItems()
                    parcels = _parcelManagerController.getParcelList()
                    names = _parcelManagerController.getParcelNames()
                    for (var i = 0; i < parcels.length; i++) {
                        if (zoomLevel > 11) {
                            var polygon = Qt.createQmlObject(
                                        'import QtLocation 5.3; MapPolygon {}',
                                        map)
                            polygon.path = parcels[i]
                            polygon.color = "#50FFA500"
                            polygon.border.width = 5
                            polygon.border.color = "red"
                            map.addMapItem(polygon)
                        } else {
                            var parcelIndicator = Qt.createQmlObject('
import QtLocation 5.3;import QtQuick 2.0; MapQuickItem {sourceItem: Rectangle {
width: 25
height: 25
border.width: 5
color: "red"
}}', map)
                            parcelIndicator.coordinate = parcels[i][0]
                            map.addMapItem(parcelIndicator)
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
                        label.coordinate = parcels[i][0]
                        map.addMapItem(label)
                    }
                }

                onZoomLevelChanged: {
                    updateParcels()
                }

                Component.onCompleted: {

                    updateParcels()
                    if (parcels.length > 0) {
                        map.center = parcels[0][0]
                    }
                }
            }
        }

        Dialog {
            id: editParcelDialog

            x: (element.width - width) / 2
            y: (element.height - height) / 2
            width: 4 * element.width / 5
            height: 4 * element.height / 5

            modal: true

            property int parcelIndex: 0

            function refresh() {
                ownerField.updateContent()
                fileField.updateContent()
                questionsView.populateQA(parcelModel, parcelIndex)
            }

            onAccepted: {
                parcelManagerController.modifyParcel(
                            parcelModel, parcelIndex, ownerField.text,
                            fileField.text, questionsView.getAnswers(),
                            questionsView.getComboAnswers())
                map.updateParcels()
                questionsView3.clear()
            }

            title: "Edit Parcel"

            standardButtons: Dialog.Ok | Dialog.Cancel

            GridLayout {
                columns: 2
                anchors.fill: parent

                Label {
                    text: "Username"
                }
                Label {
                    text: "Parcel Name"
                }
                TextField {
                    id: ownerField
                    enabled: false
                    function updateContent() {
                        text = parcelModel.getRecordValue(
                                    editParcelDialog.parcelIndex, "owner")
                    }
                }
                TextField {
                    id: fileField
                    enabled: false
                    function updateContent() {
                        text = parcelModel.getRecordValue(
                                    editParcelDialog.parcelIndex, "name")
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
            id: addParcelDialog

            x: (element.width - width) / 2
            y: (element.height - height) / 2
            width: 4 * element.width / 5
            height: 4 * element.height / 5
            modal: true

            onAccepted: {
                if (a_ilotField.length > 0 && a_fileField.length > 0) {
                    if (parcelManagerController.checkIfExist(
                                QGroundControl.settingsManager.appSettings.missionSavePath
                                + "/" + a_fileField.text)) {
                        parceleManagerController.addParcel(
                                    parcelModel, a_ilotField.text,
                                    QGroundControl.settingsManager.appSettings.missionSavePath
                                    + "/" + a_fileField.text,
                                    questionsView2.getAnswers(),
                                    questionsView2.getComboAnswers())
                        addParcelProgressOverlay.open()
                    } else {
                        parcelExistsDialog.open()
                    }
                } else {
                    champVideDialog.open()
                }
            }

            Popup {
                id: addParcelProgressOverlay

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
                questionsView2.populateQA(parcelModel, -1)
            }

            title: "Add Parcel"

            standardButtons: Dialog.Ok | Dialog.Cancel

            GridLayout {
                columns: 2
                anchors.fill: parent

                Label {
                    text: "Parcel Number"
                }
                Label {
                    text: "File Name"
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
        id: errorModifyOnlyOneParcelDialog
        standardButtons: Dialog.Ok
        x: (parent.width - width) / 2
        y: (parent.height - height) / 2
        modal: true
        title: "Error"
        Label {
            text: "Please choose a parcel to edit."
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
            text: "Limite de parcels enregistrées atteintes."
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
            text: "Parcel successfully downloaded"
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
            text: "Error when downloading the parcel."
        }
    }

    Dialog {
        id: parcelExistsDialog
        standardButtons: Dialog.Ok
        x: (parent.width - width) / 2
        y: (parent.height - height) / 2
        modal: true
        title: "Error"
        Label {
            anchors.centerIn: parent
            text: "The parcel already exists."
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
            text: "The parcel number field or name field is empty."
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
                text: "Username"
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
            if (parcelManagerController.verif("admin", a_password.text)) {
                removeParcel.deleteParcelOnAdminVerifed()
            }
            a_password.text = ""
        }
    }
}
