#include "QuestionFile.h"

QuestionFile::QuestionFile(QString file)
{
    filename = file;
    questions = *new QList<QString>();
    names = *new QList<QString>();
    questionsCombo = *new QList<QString>();
    namesCombo = *new QList<QString>();
    answers = *new QList<QList<QString>>();

    load();
}

QList<QString> QuestionFile::getQuestions() {
    return questions;
}

QList<QString> QuestionFile::getNames(){
    return names;
}

QList<QList<QString>> QuestionFile::getAnswers(){
    return answers;
}


QList<QString> QuestionFile::getQuestionsCombo() {
    return questionsCombo;
}

QList<QString> QuestionFile::getNamesCombo(){
    return namesCombo;
}

void QuestionFile::setQuestions(QList<QString> quest) {
    questions.clear();
    questions.append(quest);
}

void QuestionFile::setNames(QList<QString> newNames){
    names.clear();
    names.append(newNames);
}

void QuestionFile::setQuestionsCombo(QList<QString> quest){
    questionsCombo.clear();
    questionsCombo.append(quest);
}

void QuestionFile::setNamesCombo(QList<QString> names){
    namesCombo.clear();
    namesCombo.append(names);
}

void QuestionFile::setAnswers(QList<QList<QString>> newAnswers){
    answers.clear();
    answers.append(newAnswers);
}

void QuestionFile::save() {
    QFile file(filename);
    if (!file.open(QIODevice::WriteOnly)) {
        qDebug() << file.errorString();
        return;
    }
    QTextStream outStream(&file);

    for(int i = 0; i < names.length(); i++) {
        outStream << names[i] << ';' << questions[i] << ';' << '0' << endl;
    }
    for(int i = 0; i < namesCombo.length(); i++) {
        outStream << namesCombo[i] << ';' << questionsCombo[i] << ';' << '1';
        for(QString foo : answers.at(i)) {
            outStream << ';' << foo;
        }
        outStream << endl;
    }
}

void QuestionFile::load() {
    QFile file(filename);
    if (!file.open(QIODevice::ReadOnly)) {
        qDebug() << file.errorString();
        return;
    }

    while (!file.atEnd()) {
        QByteArray line = file.readLine();
        QList<QByteArray> lineParse = line.split(',');
        if (QString(lineParse[2]) == '1') {
            namesCombo.append(lineParse[0]);
            questionsCombo.append(lineParse[1]);
            QList<QString> foo = *new QList<QString>();
            for(int i = 3; i < lineParse.length(); i++) {
                foo.append(lineParse[i]);
            }
            answers.append(foo);
        }
        else {
            names.append(lineParse[0]);
            questions.append(lineParse[1]);
        }
    }
}
