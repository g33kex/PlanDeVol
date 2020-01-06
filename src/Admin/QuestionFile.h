#ifndef QUESTIONFILE_H
#define QUESTIONFILE_H


class QuestionFile
{
public:
    QuestionFile(QString);

    QList<QString> getQuestions();
    QList<QString> getNames();
    QMap<QString, QList<QString>> getAnswers();

    void save();
    void load();

private:
    QList<QString> questions;
    QList<QString> names;
    QMap<QString, QList<QString>> answers;
    QString filename;
};

#endif // QUESTIONFILE_H
