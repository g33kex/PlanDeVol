import QtQuick 2.0
import QtQuick.Layouts 1.4
import QtQuick 2.1
import QtQuick.Controls 2.4
import QGroundControl 1.0
import QGroundControl.Controllers 1.0
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4
import NewDrone 1.0

Item {
    property int margin: 6

    property bool showAllUsers: true

    function onClosed() {
        save()
        questionView.loadAndReset()
    }

    function save() {
        questionView.save(parcelModel2)
    }

    ColumnLayout {
        anchors.fill: parent
        id: column
        RowLayout {
            Layout.fillWidth: true
            Label {
                Layout.topMargin: margin
                Layout.leftMargin: margin
                Layout.bottomMargin: 0
                Layout.preferredWidth: column.width / 2 - 2 * margin
                text: "Question"
            }
            Label {
                Layout.topMargin: margin
                Layout.fillWidth: true
                text: "Default answer"
            }
            Label {
                text: "Select"
                Layout.topMargin: margin
                Layout.rightMargin: margin
            }
        }

        QuestionsView {
            id: questionView
            Layout.fillHeight: true
            Layout.fillWidth: true
            selectable: true

            SqlCustomModel {
                id: parcelModel2

                Component.onCompleted: {
                    setupForParcel(showAllUsers)
                }
            }

            Component.onCompleted: {
                populateQA(parcelModel2, -1)
            }
        }

        RowLayout {
            Layout.alignment: Qt.AlignRight
            Layout.fillWidth: true
            Button {
                text: "Swap"
                Layout.margins: margin
                Layout.topMargin: 0
                onClicked: {
                    if (questionView.getNbChecked() === 2
                            && questionView.isCheckedValid()) {
                        questionView.exchangeQuestion()
                    } else {
                        errorDialog.show("Please select two questions of the same category to swap.")
                    }
                }
            }
            Button {
                text: "+"
                Layout.margins: margin
                Layout.topMargin: 0
                onClicked: {
                    addQuestionDialog.open()
                }
            }
            Button {
                text: "-"
                Layout.margins: margin
                Layout.topMargin: 0
                onClicked: {
                    if (questionView.getNbChecked() === 1) {
                        questionView.deleteChecked(parcelModel2)
                        questionView.save(parcelModel2)
                    } else {
                        errorDialog.show("Please select ONE question to delete.")
                        tooManyDelDialog.open()
                    }
                }
            }
            Button {
                text: "Save"
                Layout.margins: margin
                Layout.topMargin: 0
                onClicked: {
                    save()
                    doneDialog.show("Done.")
                }
            }
        }
    }

    Dialog {
        id: addQuestionDialog
        modal: true
        width: 3 * parent.width / 4
        height: 3 * parent.height / 4

        onAccepted: {
            if (questionView.checkIfValid(name_textField.text)
                    && question_textField.length > 0
                    && name_textField.length > 0) {
                if (combo_checkbox.checked) {
                    questionView.addQuestionCombo(question_textField.text,
                                                  possibleChoiceArea.text,
                                                  parcelModel2,
                                                  name_textField.text)
                } else {
                    questionView.addQuestion(question_textField.text,
                                             parcelModel2,
                                             name_textField.text)
                }
                questionView.save(parcelModel2)
                reset()
            } else {
                errorDialog.show("The question name is already used!")
            }
        }

        title: "Add Question"

        function reset() {
            possibleChoiceArea.text = ""
            question_textField.text = ""
            name_textField.text = ""
            combo_checkbox.checked = false
        }

        standardButtons: Dialog.Ok | Dialog.Cancel
        x: (parent.width - width) / 2
        y: (parent.height - height) / 2

        ColumnLayout {
            anchors.fill: parent

            Label {
                text: "Question Name"
            }
            TextField {
                id: name_textField
                Layout.fillWidth: true
            }
            Label {
                text: "Question"
            }
            TextField {
                id: question_textField
                Layout.fillWidth: true
            }
            CheckBox {
                text: "Multiple choice question"
                id: combo_checkbox
            }
            TextArea {
                id: possibleChoiceArea
                Layout.fillWidth: true
                Layout.fillHeight: true
                visible: combo_checkbox.checked
            }
        }
    }

    SimpleDialog {
        id: errorDialog
        title: "Error"
    }
}
