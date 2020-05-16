import QtQuick 2.0
import QtQuick.Layouts 1.4
import QtQuick 2.1
import QtQuick.Controls 2.4
import QGroundControl 1.0
import QGroundControl.Controllers 1.0
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4

ColumnLayout {

    function getCheckList() {
        return checklistArea.text;
    }

    Label {
        text: "Checklist"
        color: "gray"
        Layout.margins: m2
    }

    TextArea {
        id: checklistArea
        Layout.fillWidth: true
        Layout.fillHeight: true
        text: loginController.getParamChecklist()
        Layout.margins: m2
    }

    Button {
        text: "Enregistrer"
        Layout.margins: m2
        onClicked: {
            loginController.setParamChecklist(checklistArea.text)
            doneDialog.open()
        }
    }
}
