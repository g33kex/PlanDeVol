#include "UserManagerController.h"
#include "DbManager.h"

extern DbManager *db;

/* Controller for the UserManager View, located in superadmin settings */

UserManagerController::UserManagerController()
{
}

void UserManagerController::addUser(SqlCustomModel *model, QString password, QString username, QString firstname, QString lastname, QString role, bool allowParcelCreation, int maximumParcelSurface) {
        QSqlRecord newRecord = model->record();
        newRecord.setValue("username", QVariant(username));
        QString pass = "";
        if(role != "User") { //Users don't have passwords, only admins and superadmins
            pass = QCryptographicHash::hash(password.toUtf8(), QCryptographicHash::Sha3_256);
        }
        newRecord.setValue("password", QVariant(pass));
        newRecord.setValue("firstname", QVariant(firstname));
        newRecord.setValue("lastname",QVariant(lastname));
        newRecord.setValue("role", QVariant(role));
        newRecord.setValue("allowParcelCreation", QVariant(allowParcelCreation ? "yes" : "no"));
        newRecord.setValue("maximumParcelSurface", QVariant(maximumParcelSurface));

        /*-1 is set to indicate that it will be added to the last row*/
        if(model->insertRecord(-1, newRecord)) {
            model->submitAll();
        }
}

void UserManagerController::deleteUsers(SqlCustomModel *model, QList<int> indexes) {
    for(int i=0; i<indexes.size();i++) {
        QString username = model->record(indexes[i]).value("username").toString();
        qDebug() << "remove all parcelle et mission from " << username;
        QList<QString> listParcelle = db->getAllParcelle(username);
        for (QList<QString>::iterator j = listParcelle.begin(); j != listParcelle.end(); ++j) {
            QFile file (*j);
            file.remove();
        }
        QList<QString> listMission = db->getAllMission(username);
        for (QList<QString>::iterator j = listParcelle.begin(); j != listParcelle.end(); ++j) {
            QFile file (*j);
            file.remove();
        }
        model->removeRow(indexes[i]);
    }
    model->submitAll();
}


void UserManagerController::modifyUser(SqlCustomModel *model, int index, QString password, QString firstname, QString lastname, QString role, bool allowParcelCreation, int maximumParcelSurface) {
    QSqlRecord record = model->record(index);

    record.setValue("firstname", QVariant(firstname));
    record.setValue("lastname",QVariant(lastname));
    record.setValue("role", QVariant(role));
    record.setValue("allowParcelCreation", QVariant(allowParcelCreation ? "yes" : "no"));
    record.setValue("maximumParcelSurface", QVariant(maximumParcelSurface));

    if(role=="User") { //Users don't have passwords, only admins and superadmins
        record.setValue("password", QVariant(""));
    }
    else if(password != "") { //Check if password should be changed
         QString pass = QCryptographicHash::hash(password.toUtf8(), QCryptographicHash::Sha3_256);
        record.setValue("password", QVariant(pass));
    }

    if(model->setRecord(index, record)) {
        model->submitAll();
        qDebug() << "Modified user!";
    }
    else {
        qDebug() << "Error in modifyUser" << model->lastError();
    }
}
