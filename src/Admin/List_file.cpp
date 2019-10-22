#include "List_file.h"
#include <QFile>
#include <QList>
#include <QString>
#include <QTextStream>


List_file::List_file(QString file) :
    QList<QString> (),
    _file(file)
{ ; }



void List_file::save() {
    QFile file(_file);
    qDebug() << " ---- in save ---- ";
    if (!file.open(QIODevice::WriteOnly | QIODevice::Text)) {
        qDebug() << "error opening save file";
        return;
    }
    qDebug() << "file open";

    file.resize(0);

    qDebug() << "file resize";

    QTextStream out(&file);
    for (QList<QString>::iterator i = this->begin(); i != this->end(); ++i) {
        out << *i;
        out << "\n";
    }

    file.close();
}

bool List_file::load() {
    this->clear();
    QFile file(_file);
    if (!file.open(QIODevice::ReadOnly | QIODevice::Text))
        return false;

    QTextStream in(&file);
    while (!in.atEnd()) {
        QString line = in.readLine();
        this->append(line);
    }
    file.close();
    if (this->count() == 0)  return false;
    return true;
}

