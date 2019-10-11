#include <QList>
#include <QString>

#ifndef CHECKLISTCONTROLLER_H
#define CHECKLISTCONTROLLER_H


class ChecklistController
{
public:
    ChecklistController();
    QList<QString> getList() {return listCheck;}
    void saveToFile(QList<QString>);
private:
    QList<QString> listCheck;
};

#endif // CHECKLISTCONTROLLER_H
