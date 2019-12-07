#ifndef QUESTIONSVIEWCONTROLLER_H
#define QUESTIONSVIEWCONTROLLER_H

#include <QObject>



class QuestionsViewController : public QObject
{
    Q_OBJECT

public:
    explicit QuestionsViewController();
    ~QuestionsViewController();

    Q_INVOKABLE QStringList getQuestions();

    QStringList questions;
};

#endif // QUESTIONSVIEWCONTROLLER_H
