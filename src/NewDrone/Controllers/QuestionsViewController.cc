#include "QuestionsViewController.h"
#include <QVariant>

#include "QuestionFile.h"
#include "DbManager.h"

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

//get non combo question
//We do not need to distinguate the index with question
QStringList QuestionsViewController::getQuestions(SqlCustomModel *model, int index) {
    return this->questions;
}

//get non combo default anwser
QStringList QuestionsViewController::getAnswers(SqlCustomModel *model, int index) {
    if(index == -1) {
        return defaultAnswers;
    }
    else {
        QStringList res = *new QStringList();
        for(QString role : names) {
            res.append(model->getRecordValue(index, role).toString());
        }
        return res;
    }
}

//get combo question
//We do not need to distinguate the index with question
QStringList QuestionsViewController::getComboQuestions(SqlCustomModel *model, int index) {
    return this->questionsCombo;
}

//get possible combo answer
//We do not need to distinguate the index with possible Answers
QVariantList QuestionsViewController::getPossibleAnswers(SqlCustomModel *model, int index) {
    return this->possibleAnswers;
}

//get default combo answer
QList<int> QuestionsViewController::getSelectedAnswers(SqlCustomModel *model, int index) {
    if(index == -1) {
        return this->selectedAnswers;
    }
    else {
        QList<int> res = *new QList<int>();
        QList<QList<QString>> foo = *new QList<QList<QString>>();
        for(QVariant bar : possibleAnswers) {
            foo.append(bar.toStringList());
        }
        for(int i = 0; i < namesCombo.length(); i++) {
            int ind = foo.at(i).indexOf(model->getRecordValue(index, namesCombo[i]).toString());
            res.append(ind);
        }
        return res;
    }
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

QList<QString> QuestionsViewController::swapItemsAt(QList<QString> inp, int i, int j){
    QString buf;
    buf = inp[i];
    inp[i] = inp[j];
    inp[j] = buf;
    return inp;
}

void QuestionsViewController::exchangeQuestion(QList<int> index) {
    //here we assume that we only have index.length == 2 and in the same categories
    int i0 = index[0];
    int i1 = index[1];
    qDebug() << i0;
    qDebug() << i1;
    if (index[0] < questions.length()) {
        names = swapItemsAt(names, i0, i1);
        questions = swapItemsAt(questions, i0, i1);
        defaultAnswers = swapItemsAt(defaultAnswers, i0, i1);
    }
    else {
        i0 = i0 - questions.length();
        i1 = i1 - questions.length();
        questionsCombo = swapItemsAt(questionsCombo, i0, i1);
        namesCombo = swapItemsAt(namesCombo, i0, i1);
        int buf = selectedAnswers[i0];
        selectedAnswers[i0] = selectedAnswers[i1];
        selectedAnswers[i1] = buf;

        QVariant buf2 = possibleAnswers[i0];
        possibleAnswers[i0] = possibleAnswers[i1];
        possibleAnswers[i1] = buf2;
    }
}


void QuestionsViewController::addQuestion(SqlCustomModel *model, QString name, QString question) {
    //formatage de l'identifiant
    name.replace(" ", "_");
    name.replace(";", "_");
    name.replace("-", "_");
    question.replace(";", "_");
    db->addQuestion(name);
    names.append(name);
    questions.append(question);
    defaultAnswers.append("");
}

void QuestionsViewController::addQuestionCombo(SqlCustomModel *model, QString name, QString question, QString answers) {
    //formatage de l'identifiant
    name.replace(" ", "_");
    name.replace(";", "_");
    name.replace("-", "_");
    question.replace(";", "_");
    answers.replace(";", "_");
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

bool QuestionsViewController::checkIfValid(QString name) {
    name.replace(" ", "_");
    name.replace(";", "_");
    name.replace("-", "_");
    return !(names.contains(name) || namesCombo.contains(name));
}

void QuestionsViewController::setDefaultAnswers(QStringList def) {
    defaultAnswers.clear();
    defaultAnswers.append(def);
}

void QuestionsViewController::setComboAnswers(QList<int> def) {
    selectedAnswers.clear();
    selectedAnswers.append(def);
}
