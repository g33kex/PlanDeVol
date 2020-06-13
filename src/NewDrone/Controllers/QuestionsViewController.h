#ifndef QUESTIONSVIEWCONTROLLER_H
#define QUESTIONSVIEWCONTROLLER_H

#include "SqlCustomModel.h"

#include <QObject>



class QuestionsViewController : public QObject
{
    Q_OBJECT

public:
    explicit QuestionsViewController();
    ~QuestionsViewController();

    Q_INVOKABLE QStringList getQuestions(SqlCustomModel *model, int index);
    Q_INVOKABLE QStringList getAnswers(SqlCustomModel *model, int index);
    Q_INVOKABLE QStringList getComboQuestions(SqlCustomModel *model, int index);
    Q_INVOKABLE QVariantList getPossibleAnswers(SqlCustomModel *model, int index);
    Q_INVOKABLE QList<int>  getSelectedAnswers(SqlCustomModel *model, int index);
    Q_INVOKABLE void        deleteQuestion(SqlCustomModel *model, int i);
    Q_INVOKABLE void        exchangeQuestion(QList<int> index);
    Q_INVOKABLE void        addQuestion(SqlCustomModel *model, QString name, QString question);
    Q_INVOKABLE void        addQuestionCombo(SqlCustomModel *model, QString name, QString question, QString answers);
    Q_INVOKABLE void        save();
    Q_INVOKABLE bool        checkIfValid(QString name);
    Q_INVOKABLE void        setDefaultAnswers(QStringList def);
    Q_INVOKABLE void        setComboAnswers(QList<int> def);

    Q_INVOKABLE void loadAndReset();

private :

    QList<QString> swapItemsAt(QList<QString> inp, int i, int j);
    QStringList questions;
    QStringList questionsCombo;
    QStringList names;
    QStringList namesCombo;
    QVariantList possibleAnswers;
    QList<int> selectedAnswers;
    QList<QString> defaultAnswers;
};

#endif // QUESTIONSVIEWCONTROLLER_H
