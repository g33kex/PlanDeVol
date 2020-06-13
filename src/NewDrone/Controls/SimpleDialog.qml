import QtQuick 2.0
import QtQuick.Controls 2.4
import QtQuick.Layouts 1.3

Popup {
    x: (parent.width-width)/2
    y: (parent.height-height)/2
    modal: true
    closePolicy: Popup.NoAutoClose

    property var title: ""
    property var msg: ""

    function show(message) {
        msg = message
        open()
    }

    ColumnLayout {
        spacing: 30

        Label {
            Layout.alignment: Qt.AlignLeft
            Layout.preferredHeight: 5

            font.bold: true
            text: title

        }

        Label {
           text: msg
        }

        Button {
            Layout.alignment: Qt.AlignRight
            text: "Ok"
            onClicked: {
                close()
            }
        }

    }



}
