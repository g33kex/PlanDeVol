#ifndef QUESTIONSVIEWCONTROLLER_H
#define QUESTIONSVIEWCONTROLLER_H

#include "SqlCustomModel.hpp"

#include <QObject>



class QuestionsViewController : public QObject
{
    Q_OBJECT

public:
    explicit QuestionsViewController();
    ~QuestionsViewController();

    Q_INVOKABLE QStringList getQuestions(SqlCustomModel *model, int index);
    Q_INVOKABLE QStringList getAnswers(SqlCustomModel *model, int index);

    QStringList questions;
};

#endif // QUESTIONSVIEWCONTROLLER_H
