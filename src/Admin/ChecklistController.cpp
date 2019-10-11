#include "ChecklistController.h"
#include <QFile>
#include <QList>
#include <QString>
#include <QTextStream>


ChecklistController::ChecklistController() :
    QList<QString> ()
{ ; }



void ChecklistController::saveToFile() {
    QFile file("Checklist");
    file.resize(0);
    if (!file.open(QIODevice::WriteOnly | QIODevice::Text))
            return;

    QTextStream out(&file);
    for (QList<QString>::iterator i = this->begin(); i != this->end(); ++i) {
        out << *i;
        out << "\n";
    }

    file.close();
}

void ChecklistController::initFromFile() {
    this->clear();
    QFile file("Checklist");
    if (!file.open(QIODevice::ReadOnly | QIODevice::Text))
        return;

    QTextStream in(&file);
    while (!in.atEnd()) {
        QString line = in.readLine();
        this->append(line);
    }
    file.close();
}

