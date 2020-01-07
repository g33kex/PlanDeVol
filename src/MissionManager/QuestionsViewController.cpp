#include "QuestionsViewController.h"
#include <QVariant>

#include "Admin/QuestionFile.h"
#include "DataManager/DbManager.h"

extern DbManager *db;
extern QuestionFile *questionFile;

QuestionsViewController::QuestionsViewController() {
    this->questions = questionFile->getQuestions();
    this->names = questionFile->getNames();
    this->defaultAnswers = questionFile->getDefaultAnswer();

    this->questionsCombo = questionFile->getQuestionsCombo();
    this->namesCombo = questionFile->getNamesCombo();
    this->selectedAnswers = questionFile->getSelected();
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

//get non combo question
QStringList QuestionsViewController::getQuestions(SqlCustomModel *model, int index) {
   return this->questions;
}

//get non combo default anwser
QStringList QuestionsViewController::getAnswers(SqlCustomModel *model, int index) {
   return defaultAnswers;
}

//get combo question
QStringList QuestionsViewController::getComboQuestions(SqlCustomModel *model, int index) {
    return this->questionsCombo;
}

//get possible combo answer
QVariantList QuestionsViewController::getPossibleAnswers(SqlCustomModel *model, int index) {
    return this->possibleAnswers;
}

//get default combo answer
QList<int> QuestionsViewController::getSelectedAnswers(SqlCustomModel *model, int index) {
    return this->selectedAnswers;
}

void QuestionsViewController::deleteQuestion(SqlCustomModel *model, int i) {
    if (i < questions.length()) {
        questions.removeAt(i);
        names.removeAt(i);
        defaultAnswers.removeAt(i);
    }
    else {
        i = i - questions.length();
        questionsCombo.removeAt(i);
        namesCombo.removeAt(i);
        possibleAnswers.removeAt(i);
        selectedAnswers.removeAt(i);
    }

    db->deleteQuestion(names + namesCombo);
}


void QuestionsViewController::addQuestion(SqlCustomModel *model, QString name, QString question) {
    db->addQuestion(name);
    names.append(name);
    questions.append(question);
    defaultAnswers.append("");
}

void QuestionsViewController::addQuestionCombo(SqlCustomModel *model, QString name, QString question, QString answers) {
        db->addQuestion(name);
        namesCombo.append(name);
        questionsCombo.append(question);
        possibleAnswers.append(answers.split('\n'));
        selectedAnswers.append(0);
}

void QuestionsViewController::save() {
    QList<QList<QString>> foo = *new QList<QList<QString>>();
    for(QVariant bar : possibleAnswers) {
        foo.append(bar.toStringList());
    }
    questionFile->setAnswers(foo);
    questionFile->setNames(names);
    questionFile->setSelected(selectedAnswers);
    questionFile->setQuestions(questions);
    questionFile->setNamesCombo(namesCombo);
    questionFile->setDefaultAnswer(defaultAnswers);
    questionFile->setQuestionsCombo(questionsCombo);
    questionFile->save();
}
