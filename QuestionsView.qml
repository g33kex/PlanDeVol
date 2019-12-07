import QtQuick 2.0
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.0
import QGroundControl.Controllers 1.0
import QtQml.Models 2.1

Rectangle {
        width: 100
        height: 50
        id: rectangle

        QuestionsViewController {
            id: _questionsViewController
        }

        function getAnswers() {
            return "hello";
        }

        Component.onCompleted: {

            var questions = _questionsViewController.getQuestions();
            console.log("-----QuestionView.qml-------\nquestion size:"+questions.length)

           /* var obj = "
            import QtQuick 2.0
            import QtQuick.Controls 2.0
            import QtQuick.Controls	1.4
            import QtQuick.Layouts	1.0

            ScrollView {
            GridLayout {
                columns:2
                anchors.fill: parent
            "

            for(var i=0; i<questions.length; i++) {
                console.log(questions[i])
            obj+="
            Label {
                text:\""+questions[i]+"\"
            }
            TextField {
                id:answer"+i+"
            }
            "
            }

            obj+="}}";

            Qt.createQmlObject(obj, rectangle, "question_block"+i);*/

        }

        property var values:  ["hello", "world", "this", "is", "a very long test", "i am done now", "actually not", "just a few more", "bla bla", "ok im bored"];


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
                  model: values
                  width: column.width

                  RowLayout {
                      width: column.width

                        Label {
                            text: qsTr(modelData)
                        }

                        TextField {
                            id: textField
                            text: qsTr(modelData)
                            Layout.alignment: Qt.AlignRight
                            Layout.preferredWidth: column.width/2
                        }
                      }
                }
              }
        }

}
