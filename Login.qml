import QtQuick 2.0
import QtQuick.Layouts 1.0
import QtQuick.Controls 2.0
import QGroundControl 1.0
import QGroundControl.Controllers 1.0
import QtQuick.Dialogs 1.2

Item {


    property var margin: 5

    LoginController {
        id: _loginController
    }
    Rectangle {
        color: "black"
        anchors.fill: parent

    Rectangle {
        color: "white"
        anchors.fill: parent
        anchors.bottomMargin: parent.height/6
        anchors.topMargin: parent.height/6
        anchors.leftMargin: parent.width/3
        anchors.rightMargin: parent.width/3

    ColumnLayout {

        anchors.fill: parent
        anchors.margins: margin

        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: 30
            Layout.alignment: Qt.AlignHCenter
            Layout.rightMargin: 10
            Layout.leftMargin: 10
            color: "pink"
            ColumnLayout {
                anchors.fill: parent
            Label {
                text: "Please Login!"
                color: "white"
                Layout.alignment: Qt.AlignCenter
                font.bold: true

            }
            }

        }

        Image {
            source:"/res/resources/icons/mainlogo.png"
            fillMode: Image.PreserveAspectFit
            Layout.alignment: Qt.AlignHCenter
            Layout.fillWidth:true
        }

        Label {
            text: "Username"
            color: "gray"
            Layout.alignment: Qt.AlignHCenter
            Layout.rightMargin: 20
        }

        TextField {
            id: usernameField
            Layout.alignment: Qt.AlignHCenter

        }

        Label {
            text: "Password"
            color: "gray"
            Layout.alignment: Qt.AlignHCenter
            Layout.rightMargin: 20
        }

        TextField {
            id: passwordField
            Layout.alignment: Qt.AlignHCenter
            echoMode: TextInput.Password
        }

        Button {
            Layout.alignment: Qt.AlignHCenter
            text : "Login"

        onClicked: {
            var username=usernameField.text
            if(_loginController.login(username, passwordField.text))
            {
                if(username==="admin")
                {
                    console.log("ADMIN LOGIN DETECTED")
                }
                else {
                    console.log("Logged in as user "+username)
                    _loginController.loadMainWindow()
                    loginMainWindow.close()
                }
            }
            else {
                errorLogin.open()
            }
        }
    }
    }
    }
    }
    Dialog {
        id: errorLogin
        title: "Error"
        Label{
            text: "Invalid username or password!"
        }

    }

}
