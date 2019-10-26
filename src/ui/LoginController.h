#ifndef LOGINCONTROLLER_H
#define LOGINCONTROLLER_H

#include <QQmlApplicationEngine>
#include "DataManager/DbManager.h"
#include "SqlCustomModel.hpp"

class LoginController : public QObject {

    Q_OBJECT

public:
    explicit LoginController();

    Q_INVOKABLE void loadMainWindow(void);

    static QQmlApplicationEngine* qmlAppEngine;

    Q_INVOKABLE bool login(QString username, QString password);

    Q_INVOKABLE void deleteMission(SqlCustomModel *model, QList<int> indexes);

    Q_INVOKABLE void deleteUser(SqlCustomModel *model, QList<int> indexes);

    Q_INVOKABLE void addUser(SqlCustomModel *model, QString username, QString password, QString nom, QString prenom);

    Q_INVOKABLE void setParamSpeed(QString lowSpeed, QString medSpeed, QString HighSpeed);
    Q_INVOKABLE void setParamLimit(QString session, QString parcelles, QString missions);
    Q_INVOKABLE void setParamChecklist(QString checklist);
    Q_INVOKABLE QString getSpeedLow();
    Q_INVOKABLE QString getSpeedMed();
    Q_INVOKABLE QString getSpeedHigh();
    Q_INVOKABLE QString getNbSession();
    Q_INVOKABLE QString getNbParcelle();
    Q_INVOKABLE QString getNbMission();
    Q_INVOKABLE QString getParamChecklist();
    Q_INVOKABLE bool modifyPassword(SqlCustomModel *model, int index, QString username, QString oldPass, QString newPass);

    Q_INVOKABLE bool    nbUser              ();


public slots:
    void modifyUser(SqlCustomModel *model, int index, QString username, QString nom, QString prenom);

public slots:
    void onAdminClosed();

private:
};

#endif // LOGINCONTROLLER_H
