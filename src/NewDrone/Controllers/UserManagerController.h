#ifndef USERMANAGERCONTROLLER_H
#define USERMANAGERCONTROLLER_H

#include "DbManager.h"
#include "SqlCustomModel.h"

class UserManagerController : public QObject {

    Q_OBJECT

public:
    explicit UserManagerController();

    /// Adds a new user to the database and updates the current model shown in the UserManager view
    Q_INVOKABLE void addUser(SqlCustomModel *model, QString password, QString username, QString firstname, QString lastname, QString role, bool allowParcelCreation, int maximumParcelSurface);

    /// Delete an user from the database and updates the current model shown in the UserManager view
    Q_INVOKABLE void deleteUsers(SqlCustomModel *model, QList<int> indexes);

    /// Modifies an user in the database and updates the current model shown in the UserManager view
    Q_INVOKABLE void modifyUser(SqlCustomModel *model, int index, QString password, QString firstname, QString lastname, QString role, bool allowParcelCreation, int maximumParcelSurface);

    /*Q_INVOKABLE bool login(QString username, QString password);

    Q_INVOKABLE void deleteMission(SqlCustomModel *model, QList<int> indexes);




    Q_INVOKABLE void setParamSpeed(QString lowSpeed, QString medSpeed, QString HighSpeed);
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
    Q_INVOKABLE QString getNbSession();
    Q_INVOKABLE QString getNbParcelle();
    Q_INVOKABLE QString getNbMission();
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
    Q_INVOKABLE int getCameraLand();

    Q_INVOKABLE bool modifyPassword(SqlCustomModel *model, int index, QString username, QString oldPass, QString newPass);

    Q_INVOKABLE void    exportToXML();
    Q_INVOKABLE bool    nbUser              ();*/

};

#endif // USERMANAGERCONTROLLER_H
