#ifndef USERMANAGERCONTROLLER_H
#define USERMANAGERCONTROLLER_H

#include <QObject>
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
};

#endif // USERMANAGERCONTROLLER_H
