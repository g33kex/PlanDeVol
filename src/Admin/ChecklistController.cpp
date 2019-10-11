#include "ChecklistController.h"
#include <QFile>
#include <QList>
#include <QString>
#include <QTextStream>


ChecklistController::ChecklistController()
{
    listCheck = *new QList<QString>();
    QFile file("Checklist");
    if (!file.open(QIODevice::ReadOnly | QIODevice::Text))
        return;

    QTextStream in(&file);
    while (!in.atEnd()) {
        QString line = in.readLine();
        listCheck.append(line);
    }
    file.close();
}



void ChecklistController::saveToFile(QList<QString> to_write) {
    listCheck = to_write;
    QFile file("Checklist");
    file.resize(0);
    if (!file.open(QIODevice::WriteOnly | QIODevice::Text))
            return;

    QTextStream out(&file);
    for (QList<QString>::iterator i = to_write.begin(); i != to_write.end(); ++i) {
        out << *i;
        out << "\n";
    }

    file.close();
}
