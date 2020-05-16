import QtQuick 2.0
import QtQuick.Layouts 1.4
import QtQuick 2.1
import QtQuick.Controls 2.4
import QGroundControl 1.0
import QGroundControl.Controllers 1.0
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4

Item {
    property int margin: 6

    function save() {
        questionView.save(parcelleModel2)
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
                text: "Reponse par default"
            }
            Label {
                text: "Selection"
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
                id: parcelleModel2

                Component.onCompleted: {
                    setupForParcelle()
                }
            }

            Component.onCompleted: {
                populateQA(parcelleModel2, -1)
            }
        }

        RowLayout {
            Layout.alignment: Qt.AlignRight
            Layout.fillWidth: true
            Button {
                text: "Echange"
                Layout.margins: margin
                Layout.topMargin: 0
                onClicked: {
                    if (questionView.getNbChecked() === 2
                            && questionView.isCheckedValid()) {
                        questionView.exchangeQuestion()
                    } else {
                        tooManySelectionsDialog.open()
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
                        questionView.deleteChecked(parcelleModel2)
                        questionView.save(parcelleModel2)
                    } else {
                        tooManyDelDialog.open()
                    }
                }
            }
            Button {
                text: "Enregistrer"
                Layout.margins: margin
                Layout.topMargin: 0
                onClicked: {
                    questionView.save(parcelleModel2)
                    doneDialog.open()
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
                                                  parcelleModel2,
                                                  name_textField.text)
                } else {
                    questionView.addQuestion(question_textField.text,
                                             parcelleModel2,
                                             name_textField.text)
                }
                questionView.save(parcelleModel2)
                reset()
            } else {
                idExistsDialog.open()
            }
        }

        title: "Ajouter Question"

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
                text: "Nom du champ"
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
                text: "Question à choix multiple ?"
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

    Dialog {
        id: idExistsDialog
        standardButtons: Dialog.Ok
        x: (parent.width - width) / 2
        y: (parent.height - height) / 2
        modal: true
        title: "Error"
        Label {
            anchors.centerIn: parent
            text: "L'identifiant est deja utilisé"
        }
    }

    Dialog {
        id: tooManySelectionsDialog
        standardButtons: Dialog.Ok
        x: (parent.width - width) / 2
        y: (parent.height - height) / 2
        modal: true
        title: "Error"
        Label {
            anchors.centerIn: parent
            text: "Séléctionner que 2 questions de la même catégorie à échanger"
        }
    }

    Dialog {
        id: tooManyDelDialog
        standardButtons: Dialog.Ok
        x: (parent.width - width) / 2
        y: (parent.height - height) / 2
        modal: true
        title: "Error"
        Label {
            anchors.centerIn: parent
            text: "Séléctionner qu'une question a supprimer"
        }
    }

}
