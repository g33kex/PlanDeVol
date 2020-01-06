#include "QuestionFile.h"

QuestionFile::QuestionFile(QString file)
{
    filename = file;
    questions = *new QList<QString>() ;
    names = *new QList<QString>() ;
    answers = *new QMap<QString, QList<QString>>() ;
}

QList<QString> QuestionFile::getQuestions() {
    return questions;
}
QList<QString> QuestionFile::getNames(){
    return names;
}
QMap<QString, QList<QString>> QuestionFile::getAnswers(){
    return answers;
}

void QuestionFile::save() {
    QFile file(filename);
    if (!file.open(QIODevice::WriteOnly)) {
        qDebug() << file.errorString();
        return;
    }
    QTextStream outStream(&file);

    for(int i = 0; i < names.length(); i++) {
        outStream << names[i] << ';' << questions[i] << ';';
        if(answers.contains(names[i])) {
            outStream << '1';
            for (QString foo : answers.value(names[i])) {
                outStream << ';' << foo;
            }
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
        names.append(lineParse[0]);
        questions.append(lineParse[1]);
        if (QString(lineParse[2]) == '1') {
            QList<QString> foo = *new QList<QString>();
            for(int i = 3; i < lineParse.length(); i++) {
                foo.append(lineParse[i]);
            }
            answers.insert(lineParse[0], foo);
        }
    }
}
