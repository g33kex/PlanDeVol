#ifndef LOGIN_H
#define LOGIN_H

#include <QWidget>
#include "DataManager/dbmanager.h"


namespace Ui {
class login;
}

class login : public QWidget
{
    Q_OBJECT

public:
    explicit login(QWidget *parent = nullptr);
    explicit login(QWidget *parent = nullptr, DbManager *db = nullptr);
    ~login();

public slots:
    bool connection();

private:
    Ui::login *ui;
    DbManager *dbManager;
};

#endif // LOGIN_H
