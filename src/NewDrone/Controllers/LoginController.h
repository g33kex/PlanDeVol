#ifndef LOGINCONTROLLER_H
#define LOGINCONTROLLER_H

#include <QQmlApplicationEngine>
#include "DbManager.h"
#include "SqlCustomModel.h"

class LoginController : public QObject {

    Q_OBJECT

public:
    explicit LoginController();

    Q_INVOKABLE void loadMainWindow(void);

    static QQmlApplicationEngine* qmlAppEngine;

    Q_INVOKABLE bool login(QString username, QString password);

    Q_INVOKABLE QString getRole(QString user);

    Q_INVOKABLE void deleteMission(SqlCustomModel *model, QList<int> indexes);

    Q_INVOKABLE void updateUsers();

 /*   Q_INVOKABLE void setParamSpeed(QString lowSpeed, QString medSpeed, QString HighSpeed);
    Q_INVOKABLE void setParamAlt(QString lowAlt, QString medAlt, QString HighAlt);
    Q_INVOKABLE void setParamLimit(QString session, QString parcelles, QString missions);
    Q_INVOKABLE void setParamChecklist(QString checklist);
    Q_INVOKABLE void setParamFlight(QString turn, QString tol, QString maxClimb, QString maxDescent);
    Q_INVOKABLE void setParamCamera(QString focale, QString sensorW, QString sensorH, QString imageW, QString imageH, int land);
    Q_INVOKABLE QString getSpeedLow();
    Q_INVOKABLE QString getSpeedMed();
    Q_INVOKABLE QString getSpeedHigh();
    Q_INVOKABLE QString getAltLow();
    Q_INVOKABLE QString getAltMed();
    Q_INVOKABLE QString getAltHigh();
    Q_INVOKABLE QString getParamChecklist();
    Q_INVOKABLE QString getTurn();
    Q_INVOKABLE QString getTolerance();
    Q_INVOKABLE QString getMaxClimbRate();
    Q_INVOKABLE QString getMaxDescentRate();
    Q_INVOKABLE QString getCameraFocale();
    Q_INVOKABLE QString getCameraSensorW();
    Q_INVOKABLE QString getCameraSensorH();
    Q_INVOKABLE QString getCameraImageW();
    Q_INVOKABLE QString getCameraImageH();
    Q_INVOKABLE int getCameraLand();*/


    Q_INVOKABLE void    exportToXML();

    Q_PROPERTY(QStringList users READ users NOTIFY usersChanged)

//public slots:
//    void onAdminClosed();

    QStringList users() const
    {
        return m_users;
    }


signals:
    void usersChanged();

private:
    QStringList m_users;
};

#endif // LOGINCONTROLLER_H
