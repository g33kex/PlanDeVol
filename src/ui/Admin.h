#ifndef ADMIN_H
#define ADMIN_H

#include <QWidget>
#include "DataManager/dbmanager.h"
#include <QSqlTableModel>

namespace Ui {
class admin;
}

class admin : public QWidget
{
    Q_OBJECT

public:
    explicit admin(QWidget *parent = nullptr);
    explicit admin(QWidget *parent = nullptr, DbManager *db = nullptr);
    ~admin();

public slots:
    void disconnect();
    void addUser();
    void saveUser();
    void deleteUser();
//    void saveFlightParam();

private:
    Ui::admin *ui;
    QVector<QString> list_User;
    DbManager *db;
    QSqlTableModel *SqlPersonmodel;

};

#endif // ADMIN_H
