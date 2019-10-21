#ifndef LOGINCONTROLLER_H
#define LOGINCONTROLLER_H

#include <QQmlApplicationEngine>
#include "DataManager/DbManager.h"
#include "SqlCustomModel.hpp"

class LoginController : public QObject {

    Q_OBJECT

public:
    explicit LoginController();
  //  explicit LoginController(DbManager *db = nullptr);

    Q_INVOKABLE void loadMainWindow(void);

    static QQmlApplicationEngine* qmlAppEngine;

    Q_INVOKABLE bool login(QString username, QString password);

    Q_INVOKABLE void deleteMission(SqlCustomModel *model, QList<int> indexes);

    Q_INVOKABLE void deleteUser(SqlCustomModel *model, QList<int> indexes);

    Q_INVOKABLE void addUser(SqlCustomModel *model, QString username, QString password, QString nom, int prenom);

    //TODO : implement these
    Q_INVOKABLE int getParamSpeed() {return 0;}
    Q_INVOKABLE int getParamAlt() {return 0;}
    Q_INVOKABLE QString getParamChecklist() {return "hello world";}
    Q_INVOKABLE void setParamSpeed(int speed) {}
    Q_INVOKABLE void setParamAlt(int alt) {}
    Q_INVOKABLE void setParamChecklist(QString checklist) {}

public slots:
    bool connection();

public slots:
    void onAdminClosed();

private:
    DbManager *dbManager;
};

#endif // LOGINCONTROLLER_H
