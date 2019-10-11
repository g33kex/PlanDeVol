#include <QList>
#include <QString>

#ifndef CHECKLISTCONTROLLER_H
#define CHECKLISTCONTROLLER_H


class ChecklistController : public QList<QString>
{
public:
    ChecklistController();
    void initFromFile();
    void saveToFile();
};

#endif // CHECKLISTCONTROLLER_H
