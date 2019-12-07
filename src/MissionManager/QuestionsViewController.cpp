#include "QuestionsViewController.h"
#include <QVariant>

QuestionsViewController::QuestionsViewController() {
    this->questions=QStringList();

    for(int i=0;i<10;i++) {
        this->questions.append("Hello world "+QString::number(i));
    }



}

QuestionsViewController::~QuestionsViewController() {

}

QStringList QuestionsViewController::getQuestions() {
   return this->questions;
}
