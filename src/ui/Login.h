#ifndef LOGIN_H
#define LOGIN_H

#include <QWidget>
#include "DataManager/DbManager.h"


namespace Ui {
class Login;
}

class Login : public QWidget
{
    Q_OBJECT

public:
    explicit Login(QWidget *parent = nullptr);
    explicit Login(QWidget *parent = nullptr, DbManager *db = nullptr);
    ~Login();

public slots:
    bool connection();

private:
    Ui::Login *ui;
    DbManager *dbManager;
};

#endif // LOGIN_H
