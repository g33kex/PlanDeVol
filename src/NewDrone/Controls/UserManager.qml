import QtQuick 2.0
import QtQuick.Layouts 1.4
import QtQuick 2.1
import QtQuick.Controls 2.4
import QGroundControl 1.0
import QGroundControl.Controllers 1.0
import QtQuick.Controls 1.4

/* The User Manager is used in the admin settings to view, add and remove users and change their passwords, as well as the admin and superadmin passwords */
Item {
    ColumnLayout {
        anchors.fill: parent
        Rectangle {
            Layout.fillWidth: true
            Layout.fillHeight: true
            color: "white"

            SqlCustomModel {
                id: userModel
                Component.onCompleted: {
                    setupForUser()
                }
            }

            TableView {
                id: userTableView
                anchors.fill: parent
                model: userModel
                selectionMode: SelectionMode.MultiSelection
                TableViewColumn {
                    role: "username"
                    title: "Username"
                    movable: false
                    width: userTableView.width / 4
                }
                TableViewColumn {
                    role: "nom"
                    title: "Nom"
                    movable: false
                    width: userTableView.width / 4
                }
                TableViewColumn {
                    role: "prenom"
                    title: "Prenom"
                    movable: false
                    width: userTableView.width / 4
                }
                TableViewColumn {
                    role: "role"
                    title: "Role"
                    movable: false
                    width: userTableView.width / 4
                }
            }
        }
        RowLayout {
            Button {
                Layout.fillWidth: true
                Layout.margins: margin
                Layout.alignment: Qt.AlignHCenter

                text: "Ajouter Utilisateur"
                onClicked: {
                    if (loginController.nbUser()) {
                        addUserDialog.reset()
                        addUserDialog.open()
                    } else {
                        tooManySessionsDialog.open()
                    }
                }
            }
            Button {
                Layout.fillWidth: true
                Layout.margins: margin
                Layout.alignment: Qt.AlignHCenter

                text: "Supprimer Utilisateur"
                onClicked: {
                    var selected = []
                    userTableView.selection.forEach(function (rowIndex) {
                        console.log("Selected : " + rowIndex)
                        selected.push(rowIndex)
                    })
                    userTableView.selection.clear()

                    loginController.deleteUser(userModel, selected)
                }
            }
            Button {
                Layout.fillWidth: true
                Layout.margins: margin
                Layout.alignment: Qt.AlignHCenter

                text: "Modifier Utilisateur"
                onClicked: {
                    if (userTableView.selection.count === 1) {
                        var sel = 0
                        userTableView.selection.forEach(function (rowIndex) {
                            sel = rowIndex
                        })
                        editUserDialog.userIndex = sel
                        editUserDialog.refresh()
                        editUserDialog.open()
                    } else {
                        modifyOnlyOneDialog.open()
                    }
                }
            }
            Button {
                Layout.margins: margin
                Layout.fillWidth: true
                Layout.alignment: Qt.AlignHCenter

                text: "Modifier Mot de Passe"
                onClicked: {
                    if (userTableView.selection.count === 1) {
                        var sel = 0
                        userTableView.selection.forEach(function (rowIndex) {
                            sel = rowIndex
                        })
                        editPassDialog.userIndex = sel
                        editPassDialog.refresh()
                        editPassDialog.open()
                    } else {
                        errorModifyOnlyOneDialog.open()
                    }
                }
            }
        }
    }

    Dialog {
        id: addUserDialog
        modal: true

        onAccepted: {
            if (a_usernameField.length > 0) {
                loginController.addUser(userModel, a_usernameField.text,
                                        a_passwordField.text, a_nomField.text,
                                        a_prenomField.text)
            }
        }

        title: "Ajouter un utilisateur"

        function reset() {
            a_usernameField.text = ""
            a_passwordField.text = ""
            a_nomField.text = ""
            a_prenomField.text = ""
        }

        standardButtons: Dialog.Ok | Dialog.Cancel
        x: (parent.width - width) / 2
        y: (parent.height - height) / 2

        GridLayout {
            columns: 4
            anchors.fill: parent

            Label {
                text: "Username"
            }
            Label {
                text: "Password"
            }
            Label {
                text: "Nom"
            }
            Label {
                text: "Prénom"
            }
            TextField {
                id: a_usernameField
            }
            TextField {
                id: a_passwordField
                echoMode: TextInput.Password
            }
            TextField {
                id: a_nomField
            }
            TextField {
                id: a_prenomField
            }
        }
    }

    Dialog {
        id: editUserDialog

        property int userIndex: 0

        function refresh() {
            userField.updateContent()
            nomField.updateContent()
            prenomField.updateContent()
        }

        onAccepted: {
            loginController.modifyUser(userModel, userIndex, userField.text,
                                       nomField.text, prenomField.text)
        }

        title: "Modifier Utilisateur"

        standardButtons: Dialog.Ok | Dialog.Cancel
        x: (parent.width - width) / 2
        y: (parent.height - height) / 2
        modal: true

        GridLayout {
            columns: 3
            anchors.fill: parent

            Label {
                text: "Username"
            }
            Label {
                text: "Nom"
            }
            Label {
                text: "Prenom"
            }
            TextField {
                id: userField
                enabled: false
                function updateContent() {
                    text = userModel.getRecordValue(editUserDialog.userIndex,
                                                    "username")
                }
            }
            TextField {
                id: nomField
                function updateContent() {
                    text = userModel.getRecordValue(editUserDialog.userIndex,
                                                    "nom")
                }
            }
            TextField {
                id: prenomField
                function updateContent() {
                    text = userModel.getRecordValue(editUserDialog.userIndex,
                                                    "prenom")
                }
            }
        }
    }

    Dialog {
        id: editPassDialog
        modal: true

        property int userIndex: 0

        function refresh() {
            userField2.updateContent()
        }

        onAccepted: {
            if (newPassField.text == confirmationField.text) {
                loginController.modifyPassword(userModel, userIndex,
                                               userField2.text,
                                               oldPassField.text,
                                               newPassField.text)
            } else {
                wrongConfirmationDialog.open()
            }
        }

        title: "Modifier mot de passe"

        standardButtons: Dialog.Ok | Dialog.Cancel
        x: (parent.width - width) / 2
        y: (parent.height - height) / 2

        GridLayout {
            columns: 4
            anchors.fill: parent

            Label {
                text: "Username"
            }
            Label {
                text: "Ancien Mot de Passe"
            }
            Label {
                text: "Nouveau Mot de Passe"
            }
            Label {
                text: "Confirmation"
            }

            TextField {
                id: userField2
                enabled: false
                function updateContent() {
                    text = userModel.getRecordValue(editPassDialog.userIndex,
                                                    "username")
                }
            }
            TextField {
                id: oldPassField
                echoMode: TextInput.Password
            }
            TextField {
                id: newPassField
                echoMode: TextInput.Password
            }
            TextField {
                id: confirmationField
                echoMode: TextInput.Password
            }
        }
    }

    Dialog {
        id: wrongConfirmationDialog
        standardButtons: Dialog.Ok
        x: (parent.width - width) / 2
        y: (parent.height - height) / 2
        modal: true
        title: "Error"
        Label {
            text: "Nouveau mot de passe et confirmation non identique"
        }
    }

    Dialog {
        id: modifyOnlyOneDialog
        standardButtons: Dialog.Ok
        x: (parent.width - width) / 2
        y: (parent.height - height) / 2
        title: "Error"
        modal: true

        Label {
            text: "Choisisser qu'une ligne à modifier"
        }
    }

    Dialog {
        id: tooManySessionsDialog
        standardButtons: Dialog.Ok
        x: (parent.width - width) / 2
        y: (parent.height - height) / 2
        modal: true
        title: "Warning"
        Label {
            anchors.centerIn: parent
            text: "Limite de sessions enregistrées atteintes."
        }
    }
}
