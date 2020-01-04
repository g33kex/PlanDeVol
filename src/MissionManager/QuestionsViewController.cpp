#include "QuestionsViewController.h"
#include <QVariant>

QuestionsViewController::QuestionsViewController() {
    this->questions=QStringList();
    possibleAnswers=QVariantList();

    for(int i=0;i<10;i++) {
        this->questions.append("Hello world "+QString::number(i));
        this->selectedAnswers.append(1);
        QStringList s = QStringList();
        for(int j=0; j<5; j++) {
            s.append("This is a test "+QString::number(j)+ " from line "+QString::number(i));
        }
        this->possibleAnswers.append(QVariant::fromValue(s));
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

//TODO : add Q&A
//Get questions for combobox questions
QStringList QuestionsViewController::getComboQuestions(SqlCustomModel *model, int index) {
    return this->questions;
}

QVariantList QuestionsViewController::getPossibleAnswers(SqlCustomModel *model, int index) {
    return this->possibleAnswers;
}

QList<int> QuestionsViewController::getSelectedAnswers(SqlCustomModel *model, int index) {
    return this->selectedAnswers;
}
