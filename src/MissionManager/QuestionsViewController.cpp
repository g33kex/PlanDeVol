#include "QuestionsViewController.h"
#include <QVariant>

#include "Admin/QuestionFile.h"
#include "DataManager/DbManager.h"

extern DbManager *db;
extern QuestionFile *questionFile;

QuestionsViewController::QuestionsViewController() {
    this->questions=questionFile->getQuestions();
    this->questionsCombo=questionFile->getQuestionsCombo();
    this->names=questionFile->getNames();
    this->namesCombo=questionFile->getNamesCombo();

    QList<QList<QString>> lQuest = questionFile->getAnswers();
    this->possibleAnswers = QVariantList();
    // Conversion QList<QList>> in QList<QVarient>>
    for(QList<QString> foo : lQuest) {
        QStringList s = QStringList();
        for(QString str : foo) {
            s.append(str);
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
    return this->questionsCombo;
}

QVariantList QuestionsViewController::getPossibleAnswers(SqlCustomModel *model, int index) {
    return this->possibleAnswers;
}

QList<int> QuestionsViewController::getSelectedAnswers(SqlCustomModel *model, int index) {
    return this->selectedAnswers;
}

//TODO : add Q&A
//For admin part : delete a question, i is the number of the question, questions are ordered as returned by getQuestions and then getComboQuestions for index=-1
void QuestionsViewController::deleteQuestion(SqlCustomModel *model, int i) {
    if (i < questions.length()) {
        questions.removeAt(i);
        names.removeAt(i);
    }
    else {
        i = i - questions.length();
        questionsCombo.removeAt(i);
        namesCombo.removeAt(i);
        possibleAnswers.removeAt(i);
    }

    db->deleteQuestion(names + namesCombo);
}

//TODO : add check if good or not
//For admin part : add a new question
void QuestionsViewController::addQuestion(SqlCustomModel *model, QString name, QString question, bool isMultipleChoices, QString choices) {
    if(isMultipleChoices) {
        db->addQuestion(name);
        namesCombo.append(name);
        questionsCombo.append(question);
        possibleAnswers.append(choices);
    }
    else {
        db->addQuestion(name);
        namesCombo.append(name);
        questionsCombo.append(question);
        possibleAnswers.append(choices);
    }
}
