#ifndef QUESTIONFILE_H
#define QUESTIONFILE_H


class QuestionFile
{
public:
    QuestionFile(QString);

    QList<QString> getQuestions();
    QList<QString> getNames();
    QList<QString> getQuestionsCombo();
    QList<QString> getNamesCombo();
    QList<QString> getDefaultAnswer();
    QList<QList<QString>> getAnswers();
    QList<int> getSelected();

    void setQuestions(QList<QString>);
    void setSelected(QList<int>);
    void setDefaultAnswer(QList<QString>);
    void setNames(QList<QString>);
    void setQuestionsCombo(QList<QString>);
    void setNamesCombo(QList<QString>);
    void setAnswers(QList<QList<QString>>);

    void save();
    void load();

    void setTest();

private:
    QList<QString> questions;
    QList<QString> names;
    QList<QString> questionsCombo;
    QList<QString> namesCombo;
    QList<int> selected;
    QList<QString> defaultAnswer;
    QList<QList<QString>> answers;
    QString filename;
};

#endif // QUESTIONFILE_H
