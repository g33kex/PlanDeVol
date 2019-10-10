#ifndef ADMIN_H
#define ADMIN_H

#include <QWidget>
#include "DataManager/DbManager.h"
#include <QSqlTableModel>

namespace Ui {
class Admin;
}

class Admin : public QWidget
{
    Q_OBJECT

public:
    explicit Admin(QWidget *parent = nullptr);
    explicit Admin(QWidget *parent = nullptr, DbManager *db = nullptr);
    ~Admin();

public slots:
    void disconnect();
    void addUser();
    void saveUser();
    void deleteUser();
//    void saveFlightParam();

private:
    Ui::Admin *ui;
    QVector<QString> list_User;
    DbManager *db;
    QSqlTableModel *SqlPersonmodel;

};

#endif // ADMIN_H
