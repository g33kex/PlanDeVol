import QtQuick.Layouts 1.4
import QtQuick 2.6
import QtQuick.Controls 2.4
import QGroundControl 1.0
import QGroundControl.Controllers 1.0

//import QtQuick.Controls 1.4
//import QtQuick.Controls.Styles 1.4
import NewDrone.Controls 1.0
import NewDrone.Controllers 1.0

Item {

    property alias mainWindow: loginWindow
    id: rootItem

    //-------------------------------------------------------------------------
    //-- Global complex dialog

    /// Shows a QGCViewDialogContainer based dialog
    ///     @param component The dialog contents
    ///     @param title Title for dialog
    ///     @param charWidth Width of dialog in characters
    ///     @param buttons Buttons to show in dialog using StandardButton enum
    readonly property int showDialogFullWidth: -1 ///< Use for full width dialog
    readonly property int showDialogDefaultWidth: 40 ///< Use for default dialog width

    readonly property int margin: 10

    function showComponentDialog(component, title, charWidth, buttons) {
        var dialogWidth = charWidth === showDialogFullWidth ? mainWindow.width : ScreenTools.defaultFontPixelWidth * charWidth
        mainWindowDialog.width = dialogWidth
        mainWindowDialog.dialogComponent = component
        mainWindowDialog.dialogTitle = title
        mainWindowDialog.dialogButtons = buttons
        mainWindowDialog.open()
    }

    Drawer {
        id: mainWindowDialog
        y: 0
        height: mainWindow.height
        edge: Qt.RightEdge
        interactive: false
        background: Rectangle {
            color: "darkgray"
        }
        property var dialogComponent: null
        property var dialogButtons: null
        property string dialogTitle: ""
        Loader {
            id: dlgLoader
            anchors.fill: parent
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
    property var outerMargin: loginBoard.width / 5
    property var innerMargin: 3
    property var fieldHeight: 70
    property var spacerHeight: 50

    property var whiteColor: "#e3eff4"

    LoginController {
        id: loginController
    }

    Loader {
        id: rootWindowLoader
        asynchronous: false
        anchors.fill: parent
        visible: false
        parent: loginWindow
        onLoaded: {
            progressOverlay.close()
            hide()
        }
    }

    function show_login_window() {
        show()
    }

    Image {
        id: loginWindow
        source: "/res/AbelioField"
        anchors.fill: parent

        onVisibleChanged:
        {
            console.log("\n\n\n\nVISIBLE CHANGED\n\n\n\n")
        }

        Rectangle {
            color: "#a0ededef"
            id: loginBoard

            anchors.centerIn: parent
            width: 2 * parent.width / 5
            height: 5 * parent.height / 6

            radius: 5

            ColumnLayout {

                anchors.fill: parent

                Image {
                    source: "/res/AbelioFull"
                    fillMode: Image.Stretch

                    Layout.preferredWidth: parent.width
                    Layout.preferredHeight: parent.width * sourceSize.height / sourceSize.width
                }

                ComboBox {
                    id: usernameCombo

                    Layout.alignment: Qt.AlignCenter
                    Layout.fillWidth: true
                    Layout.leftMargin: outerMargin
                    Layout.rightMargin: outerMargin
                    Layout.bottomMargin: innerMargin
                    Layout.topMargin: innerMargin
                    Layout.minimumHeight: fieldHeight

                    currentIndex: -1
                    displayText: currentIndex === -1 ? "Select username..." : currentText
                    enabled: usernameField.text === ""

                    background: Rectangle {
                                        color: "transparent"
                                        radius: 5
                                        border.width: 2
                                        border.color: whiteColor
                                }

                    /*contentItem: Text {
                         leftPadding: 10
                         rightPadding: usernameCombo.indicator.width + usernameCombo.spacing

                         text: usernameCombo.displayText
                         font: usernameCombo.font
                         anchors.leftMargin: 40
                         verticalAlignment: Text.AlignVCenter
                         horizontalAlignment: Text.AlignLeft
                         color: whiteColor
                         elide: Text.ElideRight
                     }*/

                    popup: Popup {
                        y: usernameCombo.height - 1
                        width: usernameCombo.width
                        implicitHeight: listview.contentHeight
                        padding: 1

                        contentItem: ListView {
                            id: listview
                            clip: true
                            model: usernameCombo.popup.visible ? usernameCombo.delegateModel : null
                            currentIndex: usernameCombo.highlightedIndex

                            ScrollIndicator.vertical: ScrollIndicator { }
                        }

                        background: Rectangle {
                            border.color: whiteColor
                            color: "transparent"
                            radius: 5
                        }
                    }

                    inputMethodHints: Qt.ImhNoAutoUppercase
                    model: loginController.users
                }

                Item {
                    //Spacer
                    Layout.preferredHeight: spacerHeight
                    Layout.margins: innerMargin
                }

                TextField {
                    id: usernameField

                    Layout.alignment: Qt.AlignCenter
                    Layout.fillWidth: true
                    Layout.leftMargin: outerMargin
                    Layout.rightMargin: outerMargin
                    Layout.bottomMargin: innerMargin
                    Layout.topMargin: innerMargin
                    Layout.minimumHeight: fieldHeight

                    background: Rectangle {
                                        color: "transparent"
                                        radius: 5
                                        border.width: 2
                                        border.color: whiteColor
                                }

                    color: whiteColor
                    placeholderText: "Admin Login"
                    inputMethodHints: Qt.ImhNoAutoUppercase
                }

                TextField {
                    id: passwordField

                    Layout.alignment: Qt.AlignCenter
                    Layout.fillWidth: true
                    Layout.leftMargin: outerMargin
                    Layout.rightMargin: outerMargin
                    Layout.bottomMargin: innerMargin
                    Layout.topMargin: innerMargin
                    Layout.minimumHeight: fieldHeight

                    background: Rectangle {
                                        color: "transparent"
                                        radius: 5
                                        border.width: 2
                                        border.color: whiteColor
                                }

                    color: whiteColor
                    placeholderText: "Admin Password"
                    echoMode: TextInput.Password
                }

                Item {
                    //Spacer
                    Layout.preferredHeight: spacerHeight
                    Layout.margins: innerMargin
                }

                Button {
                    id: loginButton

                    Layout.alignment: Qt.AlignCenter
                    Layout.fillWidth: true
                    Layout.leftMargin: outerMargin
                    Layout.rightMargin: outerMargin
                    Layout.bottomMargin: innerMargin
                    Layout.topMargin: innerMargin
                    Layout.minimumHeight: fieldHeight

                    background: Rectangle {
                                        color: loginButton.enabled ? loginButton.pressed ? "#0d85bc": "#0eaff9" : "#b9c4c9"
                                        border.width: 0
                                        radius: 5
                                }
                    contentItem: Text {
                        text: loginButton.text
                        font: loginButton.font
                        opacity: enabled ? 1.0 : 0.3
                        color: loginButton.pressed ? "#c4ced3" : whiteColor
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                        elide: Text.ElideRight
                    }

                    text: "Login"
                    enabled: usernameCombo.currentIndex!==-1 || usernameField.text !== ""


                    onClicked: {
                        var username = usernameField.text
                                === "" ? usernameCombo.currentText : usernameField.text
                        var role = loginController.getRole(username)
                        console.log("Connecting as user " + username + " with role " + role)
                        if (role === "Admin") {
                            if (loginController.login(username,
                                                      passwordField.text)) {
                                console.log("ADMIN LOGIN")
                                adminSettings.open()
                            } else {
                                errorLogin.open()
                            }
                        } else if (role === "SuperAdmin") {
                            if (loginController.login(username,
                                                      passwordField.text)) {
                                console.log("SUPERADMIN LOGIN")
                                superAdminSettings.open()
                            } else {
                                errorLogin.open()
                            }
                        } else if (role === "User") {
                            if (loginController.login(username, "")) {
                                progressOverlay.open()
                                console.log("Logged in as user " + username)
                                loginController.loadMainWindow()
                                rootWindowLoader.setSource("")
                                rootWindowLoader.setSource("qrc:/qml/MainRootWindow.qml")
                                /*var component = Qt.createComponent("qrc:/qml/MainRootWindow.qml")
                                var mainRootWindow = component.createObject("root")*/
                            }
                        }
                        usernameCombo.currentIndex = 0
                        passwordField.text = ""
                        usernameField.text = ""
                    }
                }


                Item {
                    //Spacer
                    Layout.preferredHeight: spacerHeight
                    Layout.margins: innerMargin
                    Layout.bottomMargin: outerMargin
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
