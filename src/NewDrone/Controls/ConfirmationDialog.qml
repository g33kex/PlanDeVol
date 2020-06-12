import QtQuick 2.0
import QtQuick.Controls 2.4

Dialog {
    modal: true
    closePolicy: Popup.NoAutoClose

    title: "Confirm"
    standardButtons: Dialog.Cancel | Dialog.Yes
    x: (parent.width - width) / 2
    y: (parent.height - height) / 2

    property var toDelete

    function show(text) {
        label.text = text
        open()
    }

    Label {
        id: label
    }
}
