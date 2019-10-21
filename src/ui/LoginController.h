#ifndef LOGINCONTROLLER_H
#define LOGINCONTROLLER_H

#include <QQmlApplicationEngine>
#include "DataManager/DbManager.h"

class LoginController : public QObject {

    Q_OBJECT

public:
    explicit LoginController();
  //  explicit LoginController(DbManager *db = nullptr);

    Q_INVOKABLE void loadMainWindow(void);

    static QQmlApplicationEngine* qmlAppEngine;

    Q_INVOKABLE bool login(QString username, QString password);

public slots:
    bool connection();

private:
    DbManager *dbManager;
};

#endif // LOGINCONTROLLER_H
