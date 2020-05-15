#include <QList>
#include <QString>

#ifndef CHECKLISTCONTROLLER_H
#define CHECKLISTCONTROLLER_H


class List_file : public QList<QString>
{
public:
    List_file(QString file);
    bool load();
    void save();

private:
    QString _file;
};

#endif // CHECKLISTCONTROLLER_H
