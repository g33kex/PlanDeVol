import QtQuick 2.11
import QtQuick.Layouts 1.4
import QtQuick.Controls 2.4
import QtQuick.Controls 1.4 as LC //Lecacy Controls
import NewDrone 1.0
import NewDrone.Controllers 1.0

/* The User Manager is used in the admin settings to view, add and remove users and change their passwords, as well as the admin and superadmin passwords */
/* It is also used to modify user subscription settings (grant the ability to create parcels and limit the total parcel surface) */
Item {

    UserManagerController {
        id: userManagerController
    }

    SqlCustomModel {
        id: userModel
        Component.onCompleted: {
            setupForUsers()
        }
    }

    ColumnLayout {
        anchors.fill: parent
        Rectangle {
            Layout.fillWidth: true
            Layout.fillHeight: true
            color: "white"

            LC.TableView {
                id: userTableView
                anchors.fill: parent
                model: userModel
                selectionMode: LC.SelectionMode.MultiSelection
                LC.TableViewColumn {
                    role: "username"
                    title: "Username"
                    movable: false
                    width: userTableView.width / 6
                }
                LC.TableViewColumn {
                    role: "firstname"
                    title: "First Name"
                    movable: false
                    width: userTableView.width / 6
                }
                LC.TableViewColumn {
                    role: "lastname"
                    title: "Last Name"
                    movable: false
                    width: userTableView.width / 6
                }
                LC.TableViewColumn {
                    role: "role"
                    title: "Role"
                    movable: false
                    width: userTableView.width / 6
                }
                LC.TableViewColumn {
                    role: "allowParcelCreation"
                    title: "Can create parcels?"
                    width: userTableView.width / 6
                }
                LC.TableViewColumn {
                    role: "maximumParcelSurface"
                    title: "Surface Limit (ha)"
                    width: userTableView.width / 6
                }
            }
        }
        RowLayout {
            Button {
                Layout.fillWidth: true
                Layout.margins: margin
                Layout.alignment: Qt.AlignHCenter

                text: "Add User"
                onClicked: {
                    userDialog.show(-1)
                }
            }
            Button {
                Layout.fillWidth: true
                Layout.margins: margin
                Layout.alignment: Qt.AlignHCenter

                text: "Delete Users"
                onClicked: {
                    var selected = []
                    userTableView.selection.forEach(function (rowIndex) {
                        console.log("Selected : " + rowIndex)
                        selected.push(rowIndex)
                    })
                    if(selected.length>0) {
                        //deleteConfirmationDialog.show(selected)
                        confirmDeleteDialog.toDelete=selected
                        confirmDeleteDialog.show("Are you sure you want to delete " + selected.length + " user"+(selected.length>1 ? "s" : "")+" ?\nThis will also delete all their parcels and missions.")

                    }
                    else {
                       errorDialog.show("Please select at least one user to delete.")
                    }
                }

            }
            Button {
                Layout.fillWidth: true
                Layout.margins: margin
                Layout.alignment: Qt.AlignHCenter

                text: "Edit User"
                onClicked: {
                    if (userTableView.selection.count === 1) {
                        var sel = 0
                        userTableView.selection.forEach(function (rowIndex) {
                            sel = rowIndex
                        })
                        userDialog.show(sel)
                    } else if(userTableView.selection.count === 0) {
                        errorDialog.show("Please select one user to edit.")
                    }
                    else {
                        errorDialog.show("Please select ONLY one user to edit.")
                    }
                }
            }
        }
    }

    Dialog {
        id: userDialog
        modal: true
        closePolicy: Popup.NoAutoClose


        x: (parent.width - width) / 2
        y: (parent.height - height) / 2

        property int userIndex
        property bool isNew: true
        property bool isUser: true
        property bool wasUser: false

        function reset() {
            usernameField.text = ""
            passwordField.text = ""
            passwordConfirmationField.text = ""
            firstnameField.text = ""
            lastnameField.text = ""
            roleComboBox.currentIndex = 0
            allowParcelCreationCheckBox.checked = false
            maximumParcelSurfaceSpinBox.value = 0
        }

        function refresh() {
            usernameField.updateContent()
            firstnameField.updateContent()
            lastnameField.updateContent()
            roleComboBox.updateContent()
            passwordField.text = ""
            passwordConfirmationField.text = ""
        }

        function show(selection) {
            if (selection === -1) {
                title = "New User"
                isUser = true
                isNew = true
                reset()
            } else {
                title = "Modify User"
                userIndex = selection
                isNew = false
                refresh()
            }
            open()
        }

        onAccepted: {
            if (isNew) {
                if (usernameField.length > 0) {
                    userManagerController.addUser(
                                userModel, passwordField.text,
                                usernameField.text, firstnameField.text,
                                lastnameField.text, roleComboBox.currentText,
                                allowParcelCreationCheckBox.checked,
                                maximumParcelSurfaceSpinBox.value)
                }
            } else {
                userManagerController.modifyUser(
                            userModel, userIndex, passwordField.text,
                            firstnameField.text, lastnameField.text,
                            roleComboBox.currentText,
                            allowParcelCreationCheckBox.checked,
                            maximumParcelSurfaceSpinBox.value)
            }
        }

        GridLayout {
            id: addOrEditUserDialog_gridLayout
            columns: (passwordConfirmationField.visible || userDialog.isUser) ? 6 : 5
            anchors.fill: parent

            Label {
                text: "Username"
            }
            Label {
                text: "First Name"
            }
            Label {
                text: "Last Name"
            }
            Label {
                text: "Role"
            }
            Label {
                text: (userDialog.isNew || userDialog.wasUser) ? "Password" : "Change Password"
                visible: passwordField.visible
            }
            Label {
                text: "Confirm Password"
                visible: passwordConfirmationField.visible
            }
            Label {
                text: "Can create parcels?"
                visible: allowParcelCreationCheckBox.visible
            }
            Label {
                text: "Surface Limit (ha)"
                visible: maximumParcelSurfaceSpinBox.visible
            }
            TextField {
                id: usernameField
                enabled: userDialog.isNew
                function updateContent() {
                    text = userModel.getRecordValue(userDialog.userIndex,
                                                    "username")
                }
            }
            TextField {
                id: firstnameField
                function updateContent() {
                    text = userModel.getRecordValue(userDialog.userIndex,
                                                    "firstname")
                }
            }
            TextField {
                id: lastnameField
                function updateContent() {
                    text = userModel.getRecordValue(userDialog.userIndex,
                                                    "lastname")
                }
            }
            ComboBox {
                id: roleComboBox
                implicitWidth: 200
                currentIndex: 0
                model: ["User", "Admin", "SuperAdmin"]
                onActivated: {
                    updateOthers(index)
                }

                function updateOthers(index) {
                    var toggle
                    if (index !== 0) {
                        userDialog.isUser=false
                        allowParcelCreationCheckBox.checked = false
                        maximumParcelSurfaceSpinBox.value = 0
                    } else {
                        userDialog.isUser=true
                        passwordField.text = ""
                        passwordConfirmationField.text = ""
                        if (!userDialog.isNew) {
                            allowParcelCreationCheckBox.updateContent()
                            maximumParcelSurfaceSpinBox.updateContent()
                        }
                    }
                }

                function updateContent() {
                    currentIndex = roleComboBox.find(
                                userModel.getRecordValue(
                                    userDialog.userIndex, "role"))
                    if(currentIndex===0) {
                        userDialog.wasUser=true
                    }
                    else {
                        userDialog.wasUser=false
                    }

                    updateOthers(currentIndex)
                }
            }
            TextField {
                id: passwordField
                echoMode: TextInput.Password
                visible: !userDialog.isUser
            }
            TextField {
                id: passwordConfirmationField
                echoMode: TextInput.Password
                visible: !userDialog.isUser && (userDialog.isNew || userDialog.wasUser || passwordField.text!=="");
            }
            CheckBox {
                id: allowParcelCreationCheckBox
                Layout.alignment: Qt.AlignHCenter
                visible: userDialog.isUser
                function updateContent() {
                    checked = userModel.getRecordValue(
                                userDialog.userIndex,
                                "allowParcelCreation") === "yes" ? true : false
                }
            }
            SpinBox {
                id: maximumParcelSurfaceSpinBox
                Layout.alignment: Qt.AlignHCenter
                implicitWidth: 180
                editable: true
                to: 1000000
                //Layout.fillWidth: true
                visible: userDialog.isUser
                function updateContent() {
                    value = userModel.getRecordValue(userDialog.userIndex,
                                                     "maximumParcelSurface")
                }
            }
        }



        footer: DialogButtonBox {
            Layout.fillWidth: true
            Button {
                text: "Ok"
                onClicked: {
                    if(usernameField.text==="") {
                        errorDialog.show("Username cannot be empty.")
                    }
                    else if(!userDialog.isUser &&  passwordField.text==="" && (userDialog.isNew || userDialog.wasUser)) {
                        errorDialog.show("Please specify a password.")
                    }
                    else if(passwordField.text!="" && passwordField.text != passwordConfirmationField.text) {
                        errorDialog.show("Password don't match confirmation.")
                    }
                    else {
                        userDialog.accept()
                    }
                }
            }
            Button {
                text: "Cancel"
                onClicked: {
                    userDialog.close()
                }
            }
        }

    }

    Dialog {
        id: deleteConfirmationDialog
        modal: true
        closePolicy: Popup.NoAutoClose

        title: "Confirm"
        standardButtons: Dialog.Ok | Dialog.Cancel
        x: (parent.width - width) / 2
        y: (parent.height - height) / 2

        property var toDelete

        function show(selected) {
            toDelete = selected
            if(selected.length>0) {
            deleteConfirmationDialog_label.text
                    = "Are you sure you want to delete " + toDelete.length
                    + " user"+(toDelete.length>1 ? "s" : "")+" ?\nThis will also delete all their parcels and missions."
            }

            open()
        }

        onAccepted: {
            userTableView.selection.clear()
            userManagerController.deleteUsers(userModel, toDelete)
        }

        Label {
            id: deleteConfirmationDialog_label
        }
    }

    ConfirmationDialog {
        id: confirmDeleteDialog
        property var toDelete
        onAccepted: {
            userTableView.selection.clear()
            userManagerController.deleteUsers(userModel, toDelete)
        }
    }

    SimpleDialog {
        id: errorDialog
        title: "Error"
    }
}
