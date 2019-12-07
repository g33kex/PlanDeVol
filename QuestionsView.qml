import QtQuick 2.0
import QtQuick.Controls 2.0
import QtQuick.Controls 1.4
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

       /* ObjectModel {
            id: itemModel
            Rectangle { height: 30; width: 80; color: "red" }
            Rectangle { height: 30; width: 80; color: "green" }
            Repeater {
                  id: repeater
                  height: 40
                  width: 100
                  model: values
                  Rectangle {
                      width: 40
                      height: 100
                      color: "lightgray"
                      Row {
                        Label {
                            text: qsTr(modelData)
                        }

                        TextField {
                            id: textField
                            text: qsTr(modelData)
                            width: 30
                        }
                      }

                  }
            }
          Rectangle { height: 30; width: 80; color: "blue" }

        }

        ScrollView {

            anchors.fill: parent
            clip: true
        ListView {
            model: itemModel
        }
        }*/

        /*ScrollView {
            anchors.fill: parent
            clip: true
            frameVisible: true
            contentItem: column*/


          Column {
              id: column
              anchors.fill: parent

              Repeater {
                  id: repeater
                  model: values
                  Rectangle {
                      width: column.width
                      height: childrenRect.height+10
                      color: "lightgray"
                      Row {
                        Label {
                            text: qsTr(modelData)
                        }

                        TextField {
                            id: textField
                            text: qsTr(modelData)
                            width: column.width/2
                        }
                      }

                  }
              }
          }
     //   }


      /*  Rectangle {
            anchors.fill: parent
            width: 200; height: 200

            Component {
                id: elementDelegate
                Text { text: index }
            }

            Component {
                id: rowDelegate
                 Repeater {
                  id: repeater
                  model: values
                      Row {
                          anchors.fill: parent
                        Label {
                            text: qsTr(modelData)
                        }

                        TextField {
                            id: textField
                            text: qsTr(modelData)
                        }

                  }
                 }
              /*  Row {
                    spacing: 10
                    onWidthChanged: {
                        var maxWidth = 0;
                        for (var i = 0; i < listView.contentItem.children.length; i++) {
                            if( maxWidth < listView.contentItem.children[i].width ) {
                                maxWidth = listView.contentItem.children[i].width
                            }
                        }
                        listView.contentWidth = maxWidth
                    }

                    Text { text: "Before" }

                    Repeater {
                        model:15
                        delegate: elementDelegate
                    }
                    Text { text: "After" }
                }
            }

            Column {
                width: parent.width

                ScrollView {
                    id: scrollView
                    width: parent.width
                    height: 60
                    ListView {
                        id: listView
                        clip: true
                        model: 10
                        delegate: rowDelegate
                    }
                }

            }
        }*/

}
