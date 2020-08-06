import QtQuick.Layouts 1.4
import QtQuick 2.1
import QtQuick.Controls 2.4
import QGroundControl 1.0
import QGroundControl.Controllers 1.0

//import QtQuick.Controls 1.4
//import QtQuick.Controls.Styles 1.4
import NewDrone.Controls 1.0
import NewDrone.Controllers 1.0

Item {
    property alias mainWindow: loginWindow
    //-------------------------------------------------------------------------
    //-- Global complex dialog

    /// Shows a QGCViewDialogContainer based dialog
    ///     @param component The dialog contents
    ///     @param title Title for dialog
    ///     @param charWidth Width of dialog in characters
    ///     @param buttons Buttons to show in dialog using StandardButton enum

    readonly property int showDialogFullWidth:      -1  ///< Use for full width dialog
    readonly property int showDialogDefaultWidth:   40  ///< Use for default dialog width

    function showComponentDialog(component, title, charWidth, buttons) {
        var dialogWidth = charWidth === showDialogFullWidth ? mainWindow.width : ScreenTools.defaultFontPixelWidth * charWidth
        mainWindowDialog.width = dialogWidth
        mainWindowDialog.dialogComponent = component
        mainWindowDialog.dialogTitle = title
        mainWindowDialog.dialogButtons = buttons
        mainWindowDialog.open()
    }

    Drawer {
        id:             mainWindowDialog
        y:              0
        height:         mainWindow.height
        edge:           Qt.RightEdge
        interactive:    false
        background: Rectangle {
            color:  "darkgray"
        }
        property var    dialogComponent: null
        property var    dialogButtons: null
        property string dialogTitle: ""
        Loader {
            id:             dlgLoader
            anchors.fill:   parent
            onLoaded: {
                item.setupDialogButtons()
            }
        }
        onOpened: {
            dlgLoader.source = "QGCViewDialogContainer.qml"
        }
        onClosed: {
            dlgLoader.source = ""
        }
    }

    /////DIALOG COMPATIBILITY END

    property var margin: 5
    property var m2: 3

    LoginController {
        id: loginController
    }

    Loader {
        id: rootWindowLoader
        asynchronous: true
        anchors.fill: parent
        visible: false
        parent: loginWindow
        onLoaded: {
            progressOverlay.close()
            loginWindow.hide()
        }
    }

    Rectangle {
        id: loginWindow
        color: "black"
        anchors.fill: parent

        Rectangle {
            color: "white"

            anchors.centerIn: parent
            width: parent.width / 3
            height: parent.width / 2

            ColumnLayout {

                anchors.fill: parent

                // anchors.margins: margin
                Rectangle {
                    Layout.fillWidth: true
                    Layout.preferredHeight: 45
                    Layout.alignment: Qt.AlignHCenter | Qt.AlignTop
                    Layout.topMargin: 0
                    //Layout.rightMargin: 10
                    //Layout.leftMargin: 10
                    color: "pink"
                    ColumnLayout {
                        anchors.fill: parent
                        Label {
                            text: "Veuillez vous connecter"
                            color: "white"
                            Layout.alignment: Qt.AlignCenter
                            font.bold: true
                        }
                    }
                }

                Image {
                    source: "/res/resources/icons/mainlogo.png"
                    fillMode: Image.Stretch

                    Layout.preferredWidth: parent.width
                    Layout.preferredHeight: parent.width * sourceSize.height / sourceSize.width
                }

                ColumnLayout {
                    Layout.fillWidth: true
                    Layout.alignment: Qt.AlignHCenter | Qt.AlignBottom
                    Label {
                        text: "User login"
                        color: "gray"
                        Layout.alignment: Qt.AlignCenter

                        //Layout.rightMargin: 20
                    }

                    ComboBox {
                        id: usernameCombo
                        Layout.alignment: Qt.AlignCenter
                        Layout.preferredWidth: passwordField.width
                        inputMethodHints: Qt.ImhNoAutoUppercase
                        enabled: usernameField.text === ""


                        model: loginController.users

                    }
                }

                ColumnLayout {
                    Layout.fillWidth: true
                    Layout.alignment: Qt.AlignHCenter | Qt.AlignBottom

                    Label {
                        text: "Admin login"
                        color: "gray"
                        Layout.alignment: Qt.AlignCenter

                        //Layout.rightMargin: 20
                    }

                    TextField {
                        id: usernameField
                        Layout.alignment: Qt.AlignCenter
                        inputMethodHints: Qt.ImhNoAutoUppercase
                    }

                    Label {
                        text: "Admin password"
                        color: "gray"
                        Layout.alignment: Qt.AlignCenter
                        //Layout.rightMargin: 20
                    }

                    TextField {
                        id: passwordField
                        Layout.alignment: Qt.AlignCenter
                        echoMode: TextInput.Password
                    }
                }

                Button {
                    Layout.alignment: Qt.AlignCenter
                    Layout.topMargin: 20
                    text: "Login"

                    onClicked: {
                        var username = usernameField.text === "" ? usernameCombo.currentText : usernameField.text
                        var role = loginController.getRole(username);
                        console.log("Connecting as user "+username+" with role "+role)
                            if (role === "Admin") {
                                if (loginController.login(username, passwordField.text)) {
                                    console.log("ADMIN LOGIN")
                                    adminSettings.open()
                                }
                                else {
                                    errorLogin.open()
                                }
                            } else if (role === "SuperAdmin") {
                                if(loginController.login(username, passwordField.text)) {
                                    console.log("SUPERADMIN LOGIN")
                                    superAdminSettings.open()
                                } else {
                                   errorLogin.open()
                                }
                            } else if (role === "User") {
                                if(loginController.login(username, "")) {
                                    progressOverlay.open()
                                    console.log("Logged in as user " + username)
                                    loginController.loadMainWindow()
                                    rootWindowLoader.setSource("")
                                    rootWindowLoader.setSource(
                                                "qrc:/qml/MainRootWindow.qml")
                                    rootWindowLoader.focus = true
                                }
                            }
                        usernameCombo.currentIndex=0
                        passwordField.text = ""
                        usernameField.text = ""
                    }
                }
            }
        }
    }

    Dialog {
        id: errorLogin
        modal: true
        title: "Error"
        standardButtons: Dialog.Ok
        x: (parent.width - width) / 2
        y: (parent.height - height) / 2

        Label {
            text: "User and password don't match."
        }
    }

    Popup {
        id: progressOverlay

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

    AdminSettings {
        id: adminSettings
        width: parent.width
        height: parent.height
        visible: false
    }

    SuperAdminSettings {
        id: superAdminSettings
        width: parent.width
        height: parent.height
        visible: false
        onSuperAdminClosed: {
            loginController.updateUsers()
        }
    }

    SimpleDialog {

        id: doneDialog
        title: "Ok"
    }
}
