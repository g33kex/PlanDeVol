import QtQuick 2.0
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.0
import QGroundControl.Controllers 1.0
import QtQml.Models 2.1

Rectangle {
        width: 100
        height: 50
        id: rectangle

        property var allowAnswers: true
        property var selectable: false

        QuestionsViewController {
            id: _questionsViewController
        }

        function getAnswers() {
            var res=[];
            console.log("-----QuestionView.qml-------")
            for(var i=0; i<repeater.model.count; i++) {
                console.log(repeater.itemAt(i).children[1].text)
                console.log(i)
                res.push(repeater.model.get(i).answer);
            }
            return res;
        }

        function getComboAnswers() {
            var res=[]
            for(var i=0; i<repeater2.model.count; i++) {
                res.push(repeater2.itemAt(i).children[1].currentIndex)
            }
            return res;
        }

        function clear() {
            repeater.model.clear()
            repeater2.model.clear()
        }

        function getChecked() {
            var index=0;
            for(var i=0; i<repeater.model.count; i++) {
                if(repeater.itemAt(i).children[2].checked) {
                    return index;
                }
                index++;
            }
            for(i=0; i<repeater2.model.count; i++) {
                if(repeater2.itemAt(i).children[2].checked) {
                    return index;
                }
                index++;
            }
            return -1;
        }

        function deleteChecked(parcelleModel) {
            _questionsViewController.deleteQuestion(parcelleModel, getChecked())
            populateQA(parcelleModel, -1);
        }

        function addQuestion(question, parcelleModel, name) {
            _questionsViewController.addQuestion(parcelleModel, name, question);
            populateQA(parcelleModel, -1)
        }

        function addQuestionCombo(question, answers, parcelleModel, name) {
            _questionsViewController.addQuestionCombo(parcelleModel, name, question, answers);
            populateQA(parcelleModel, -1)
        }


        function save(parcelleModel) {
            _questionsViewController.save()
        }

        function populateQA(parcelleModel, index) {
            clear()
            var questions = _questionsViewController.getQuestions(parcelleModel, index);
            var answers = _questionsViewController.getAnswers(parcelleModel, index);
//            console.log("-----QuestionView.qml-------\nquestion size:"+questions.length)
            for(var i=0; i<questions.length; i++) {
                repeater.model.append({"question": questions[i], "answer": answers[i]});
//                console.log(questions[i]+" answer : "+answers[i]);
            }

            var comboQuestions = _questionsViewController.getComboQuestions(parcelleModel, index);
            var possibleAnswers = _questionsViewController.getPossibleAnswers(parcelleModel, index);
            var selectedAnswers = _questionsViewController.getSelectedAnswers(parcelleModel, index);
            for(i=0; i<comboQuestions.length; i++) {
                var array =possibleAnswers[i];

//                console.log(comboQuestions[i]+" answer : "+possibleAnswers[i]+ " selected : "+selectedAnswers[i]);
                repeater2.model.append({"question": comboQuestions[i], "answer": array});
                repeater2.itemAt(i).children[1].model=array;
                repeater2.itemAt(i).children[1].currentIndex=selectedAnswers[i];
            }
            if(questions.length>0) {
                repeater.itemAt(0).children[2].checked=true;
            }

            //Answer as a list doens't seem to fill the model...
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
                clip:true
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

              ButtonGroup {
                  id: selectionGroup
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
                            Layout.preferredWidth: column.width/2
                            Layout.margins : margin
                            enabled: allowAnswers
                        }

                      RadioButton {
                          Layout.alignment: Qt.AlignRight
                          Layout.margins: margin
                          enabled: selectable
                          ButtonGroup.group: selectionGroup
                      }
                  }
            }


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
                        Layout.preferredWidth: column.width/2
                        Layout.margins : margin
                        enabled: allowAnswers
                    }

                    RadioButton {
                        Layout.alignment: Qt.AlignRight
                        Layout.margins: margin
                        enabled: selectable
                        ButtonGroup.group: selectionGroup
                    }


                  }
            }
          }
        }

}
