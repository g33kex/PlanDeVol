#include "QuestionsViewController.h"
#include <QVariant>

QuestionsViewController::QuestionsViewController() {
    this->questions=QStringList();

    for(int i=0;i<10;i++) {
        this->questions.append("Hello world "+QString::number(i));
    }



}

QuestionsViewController::~QuestionsViewController() {

}

//Warning : Model might be null if index=-1

//TODO : add Q&A
//Gets the questions for the parcel at index of the model. (Index = -1 when adding a new parcelle)
QStringList QuestionsViewController::getQuestions(SqlCustomModel *model, int index) {
   return this->questions;
}

//TODO : add Q&A
//Gets the answers for the parcel at index of the model. (Index = -1 when adding a new parcelle)
//There should always be the same number of questions as answers and they should be in the same order
//if index=-1, just return the default answers for the questions.
QStringList QuestionsViewController::getAnswers(SqlCustomModel *model, int index) {
   return this->questions;
}
