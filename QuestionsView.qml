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

        QuestionsViewController {
            id: _questionsViewController
        }

        function getAnswers() {
            var res=[];
            for(var i=0; i<repeater.model.count; i++) {
                res.push(repeater.model.get(i).answer);
            }
            return res;
        }

        function clear() {
            repeater.model.clear()
        }



        function populateQA(parcelleModel, index) {
            clear()
            var questions = _questionsViewController.getQuestions(parcelleModel, index);
            var answers = _questionsViewController.getAnswers(parcelleModel, index);
            console.log("-----QuestionView.qml-------\nquestion size:"+questions.length)
            for(var i=0; i<questions.length; i++) {
                repeater.model.append({"question": questions[i], "answer": answers[i]});
                console.log(questions[i]+" answer : "+answers[i]);
            }
        }

        ListModel {
            id: listModel
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


          Column {
              id: column
              anchors.left: parent.left
              anchors.right: parent.right

              Repeater {

                  id: repeater
                  model: listModel
                  width: column.width

                  RowLayout {
                      width: column.width

                        Label {
                            text: qsTr(question)
                        }

                        TextField {
                            id: textField
                            text: qsTr(answer)
                            Layout.alignment: Qt.AlignRight
                            Layout.preferredWidth: column.width/2
                            enabled: allowAnswers
                        }
                      }
                }
              }
        }

}
