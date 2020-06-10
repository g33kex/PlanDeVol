import QtQuick 2.0
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.0
import QGroundControl.Controllers 1.0
import QtQml.Models 2.1
import NewDrone.Controllers 1.0

Rectangle {
    id: rectangle

    property var allowAnswers: true
    property var selectable: false

    QuestionsViewController {
        id: _questionsViewController
    }

    function getAnswers() {
        var res = []
        //            console.log("-----QuestionView.qml-------")
        for (var i = 0; i < repeater.model.count; i++) {
            //                console.log(repeater.itemAt(i).children[1].text)
            //                console.log(i)
            res.push(repeater.itemAt(i).children[1].text)
        }
        return res
    }

    function getComboAnswers() {
        var res = []
        for (var i = 0; i < repeater2.model.count; i++) {
            res.push(repeater2.itemAt(i).children[1].currentIndex)
        }
        return res
    }

    function clear() {
        repeater.model.clear()
        repeater2.model.clear()
    }

    function getChecked() {
        var index = 0
        for (var i = 0; i < repeater.model.count; i++) {
            if (repeater.itemAt(i).children[2].checked) {
                return index
            }
            index++
        }
        for (i = 0; i < repeater2.model.count; i++) {
            if (repeater2.itemAt(i).children[2].checked) {
                return index
            }
            index++
        }
        return -1
    }

    function getCheckedMult() {
        var index = 0
        var ret = []
        for (var i = 0; i < repeater.model.count; i++) {
            if (repeater.itemAt(i).children[2].checked) {
                ret.push(index)
            }
            index++
        }
        for (i = 0; i < repeater2.model.count; i++) {
            if (repeater2.itemAt(i).children[2].checked) {
                ret.push(index)
            }
            index++
        }
        return ret
    }

    function getNbChecked() {
        var index = 0
        var ret = []
        for (var i = 0; i < repeater.model.count; i++) {
            if (repeater.itemAt(i).children[2].checked) {
                ret.push(index)
            }
            index++
        }
        for (i = 0; i < repeater2.model.count; i++) {
            if (repeater2.itemAt(i).children[2].checked) {
                ret.push(index)
            }
            index++
        }
        return ret.length
    }

    function isCheckedValid() {
        var res1 = false
        var res2 = false
        for (var i = 0; i < repeater.model.count; i++) {
            if (repeater.itemAt(i).children[2].checked) {
                res1 = true
                break
            }
        }
        for (i = 0; i < repeater2.model.count; i++) {
            if (repeater2.itemAt(i).children[2].checked) {
                if (res1 === true) {
                    return false
                }
            }
        }
        return true
    }

    function deleteChecked(parcelleModel) {
        _questionsViewController.deleteQuestion(parcelleModel, getChecked())
        populateQA(parcelleModel, -1)
    }

    function exchangeQuestion() {
        _questionsViewController.exchangeQuestion(getCheckedMult())
        clear()
        populateQA(parcelleModel, -1)
    }

    function addQuestion(question, parcelleModel, name) {
        _questionsViewController.addQuestion(parcelleModel, name, question)
        populateQA(parcelleModel, -1)
    }

    function addQuestionCombo(question, answers, parcelleModel, name) {
        _questionsViewController.addQuestionCombo(parcelleModel, name,
                                                  question, answers)
        populateQA(parcelleModel, -1)
    }

    function checkIfValid(name) {
        return _questionsViewController.checkIfValid(name)
    }

    function save(parcelleModel) {
        _questionsViewController.setDefaultAnswers(getAnswers())
        _questionsViewController.setComboAnswers(getComboAnswers())
        _questionsViewController.save()
    }

    function populateQA(parcelleModel, index) {
        clear()
        var questions = _questionsViewController.getQuestions(parcelleModel,
                                                              index)
        var answers = _questionsViewController.getAnswers(parcelleModel, index)
        //            console.log("-----QuestionView.qml-------\nquestion size:"+questions.length)
        for (var i = 0; i < questions.length; i++) {
            repeater.model.append({
                                      "question": questions[i],
                                      "answer": answers[i]
                                  })
            //                console.log(questions[i]+" answer : "+answers[i]);
        }

        var comboQuestions = _questionsViewController.getComboQuestions(
                    parcelleModel, index)
        var possibleAnswers = _questionsViewController.getPossibleAnswers(
                    parcelleModel, index)
        var selectedAnswers = _questionsViewController.getSelectedAnswers(
                    parcelleModel, index)
        for (i = 0; i < comboQuestions.length; i++) {
            var array = possibleAnswers[i]

            //                console.log(comboQuestions[i]+" answer : "+possibleAnswers[i]+ " selected : "+selectedAnswers[i]);
            repeater2.model.append({
                                       "question": comboQuestions[i],
                                       "answer": array
                                   })
            repeater2.itemAt(i).children[1].model = array
            repeater2.itemAt(i).children[1].currentIndex = selectedAnswers[i]
        }
    }

    ListModel {
        id: listModel
    }

    ListModel {
        id: listModel2
    }

    Flickable {
        id: flickable
        anchors.fill: parent
        contentHeight: column.height
        clip: true
        ScrollBar.vertical: ScrollBar {
            parent: flickable.parent
            anchors.top: flickable.top
            anchors.left: flickable.right
            anchors.bottom: flickable.bottom
        }

        property int margin: 6

        Column {
            id: column
            anchors.left: parent.left
            anchors.right: parent.right

            Repeater {

                id: repeater2
                model: listModel2
                width: column.width

                RowLayout {
                    width: column.width

                    Label {
                        text: qsTr(question)
                        Layout.margins: margin
                    }

                    ComboBox {
                        id: comboBox

                        //text: qsTr(answer)
                        model: ["hello", "world"]
                        Layout.alignment: Qt.AlignRight
                        Layout.preferredWidth: column.width / 2
                        Layout.margins: margin
                        enabled: allowAnswers
                    }

                    CheckBox {
                        Layout.alignment: Qt.AlignRight
                        Layout.margins: margin
                        checked: false
                        visible: selectable
                    }
                }
            }

            Repeater {

                id: repeater
                model: listModel
                width: column.width

                RowLayout {
                    width: column.width

                    Label {
                        text: qsTr(question)
                        Layout.margins: margin
                    }

                    TextField {
                        id: textField
                        text: qsTr(answer)
                        Layout.alignment: Qt.AlignRight
                        Layout.preferredWidth: column.width / 2
                        Layout.margins: margin
                        enabled: allowAnswers
                    }

                    CheckBox {
                        Layout.alignment: Qt.AlignRight
                        Layout.margins: margin
                        checked: false
                        visible: selectable
                    }
                }
            }
        }
    }
}
