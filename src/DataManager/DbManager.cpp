#include "DataManager/DbManager.h"
#include <QCryptographicHash>


//TODO : valeur par defaut a mettre

DbManager::DbManager() {
   m_db = QSqlDatabase::addDatabase("QSQLITE");
   m_db.setDatabaseName("database.sqlite3");



   if (!m_db.open()) {
      qDebug() << "Error: connection with database fail";
   }
   else {
      QSqlQuery pragma("PRAGMA foreign_keys = ON");
      pragma.exec();
      qDebug() << "Database: connection ok";
   }
}

bool DbManager::addUser(const QString& username, const QString& password, const QString& nom, const QString& prenom) {
   bool success = false;
   if (username == "" ) return success;
   QString hashpassword = QCryptographicHash::hash(password.toUtf8(), QCryptographicHash::Sha3_256);
   QSqlQuery query;
   if( ! query.prepare("INSERT INTO Person (username, password, nom, prenom) VALUES (:username, :password, :nom, :prenom)")) {
       qDebug() << "error prepare" << query.lastError();
   }
   query.bindValue(":username", username);
   query.bindValue(":password", hashpassword);
   query.bindValue(":nom", nom);
   query.bindValue(":prenom", prenom);

   if(query.exec()) success = true;
   else qDebug() << "addUser error:  " << query.lastError();
   return success;
}

bool DbManager::deleteUser(const QString& username) {
    bool success = false;
    QSqlQuery query;
    query.prepare("DELETE FROM Person WHERE username = (:name) ");
    query.bindValue(":name", username);
    if(query.exec()) success = true;
    else qDebug() << "deleteUser error :" << query.lastError();

    return success;
}

bool DbManager::modifyUser(const QString& username, const QString& nom, const QString& prenom) {
    bool success = false;
    if (username == "") return success;

    QSqlQuery query;

    if (nom != "" && prenom != "") {
        query.prepare("UPDATE Person SET nom = (:nom), prenom = (:prenom) WHERE username = (:username)");
        query.bindValue(":nom", nom);
        query.bindValue(":prenom", prenom);
        query.bindValue(":username", username);
        if(query.exec()) success = true;
        else qDebug() << "deleteUser error :" << query.lastError();
        return success;
    }

    if (prenom != "" )
    {
        query.prepare("UPDATE Person SET prenom = (:prenom) WHERE username = (:username)");
        query.bindValue(":prenom", prenom);
        query.bindValue(":username", username);
        if(query.exec()) success = true;
        else qDebug() << "deleteUser error :" << query.lastError();
        return success;
    }

    if (nom != "" )
    {
        query.prepare("UPDATE Person SET nom = (:nom) WHERE username = (:username)");
        query.bindValue(":nom", prenom);
        query.bindValue(":username", username);
        if(query.exec()) success = true;
        else qDebug() << "deleteUser error :" << query.lastError();
        return success;
    }



    return success;
}

QVector<QString> * DbManager::getAllUser() {
    QVector<QString>* res = new QVector<QString>();
    QSqlQuery query("SELECT * FROM Person");
    int idName = query.record().indexOf("username");
    while (query.next()) {
        res->append(query.value(idName).toString());
    }

    return res;
}

bool DbManager::addParcelle(const QString& owner, const QString& polygon, const QString& type) {
   bool success = false;
   if (owner == "" || polygon == "") return success;

   QSqlQuery query;
   query.prepare("INSERT INTO Parcelle (owner, polygon, type) VALUES (:owner, :polygon, :type)");
   query.bindValue(":owner", owner);
   query.bindValue(":polygon", polygon);
   query.bindValue(":type", type);
   if(query.exec()) success = true;
   else qDebug() << "addUser error:  " << query.lastError();

   return success;
}

// TODO : faire une cascade sur les parcelles dans mission
// (quand on supprime une parcelle, supprimer les missions qui la contienne)
bool DbManager::deleteParcelle(const int id) {
    bool success = false;
    QSqlQuery query;
    query.prepare("DELETE FROM Parcelle WHERE id = (:id)");
    query.bindValue(":id", id);
    if(query.exec()) success = true;
    else qDebug() << "deleteUser error :" << query.lastError();

    return success;
}


bool DbManager::modifyTypeParcelle(const int id, const QString& type) {
    bool success = false;
    if (id == 0) return success;

    QSqlQuery query;
    query.prepare("UPDATE Parcelle SET type=(:type) WHERE id = (:id)");
    query.bindValue(":type", type);
    query.bindValue(":id", id);
    if(query.exec()) success = true;
    else qDebug() << "deleteUser error :" << query.lastError();

    return success;

}

QMap<QString, int>* DbManager::getAllParcelle() {
    QMap<QString, int>* res = new QMap<QString, int>();
    QSqlQuery query("SELECT * FROM Person");
    int idName = query.record().indexOf("username");
    int idId = query.record().indexOf("id");
    while (query.next()) {
        res->insert(query.value(idName).toString(), query.value(idId).toInt());
    }

    return res;
}

bool DbManager::addMission(const QString& owner, const QString& ordre) {
   bool success = false;
   if (owner == "" || ordre == "") return success;

   QSqlQuery query;
   query.prepare("INSERT INTO Mission (owner, ordre) VALUES (:owner, :ordre)");
   query.bindValue(":owner", owner);
   query.bindValue(":ordre", ordre);
   if(query.exec()) success = true;
   else qDebug() << "addUser error:  " << query.lastError();

   return success;
}

bool DbManager::deleteMission(const int id) {
    bool success = false;
    QSqlQuery query;
    query.prepare("DELETE FROM Mission WHERE id = (:id)");
    query.bindValue(":id", id);
    if(query.exec()) success = true;
    else qDebug() << "deleteUser error :" << query.lastError();

    return success;
}

bool DbManager::modifyMission(const int id, const QString& ordre) {
    bool success = false;

    QSqlQuery query;
    query.prepare("UPDATE Mission SET ordre = (:ordre) WHERE id = (:id)");
    query.bindValue(":id", id);
    query.bindValue(":ordre", ordre);
    if(query.exec()) success = true;
    else qDebug() << "deleteUser error :" << query.lastError();
    return success;
}

QMap<QString, int> * DbManager::getAllMission() {
    QMap<QString, int>* res = new QMap<QString, int>();
    QSqlQuery query("SELECT * FROM Person");
    int idName = query.record().indexOf("username");
    int idId = query.record().indexOf("id");
    while (query.next()) {
        res->insert(query.value(idName).toString(), query.value(idId).toInt());
    }

    return res;
}

QString DbManager::getPassword(const QString& user) {
    //qDebug() << "in getPassword" << user;
    QSqlQuery query;
    query.prepare("SELECT * FROM Person WHERE username = (:username)");
    query.bindValue(":username", user);
    if(query.exec()) {
        //qDebug() << "status" << query.size() << query.lastError();
        query.first();
        QString password = query.value("password").toString();
        qDebug() << "query" << password;
        return password;
    }
    else {
        qDebug() << "getPassword error :" << query.lastError();
        return "";
    }

}

QSqlDatabase DbManager::getDB() {
    return m_db;
}
