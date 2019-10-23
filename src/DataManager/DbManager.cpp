#include "DataManager/DbManager.h"
#include <QCryptographicHash>
#include "Admin/List_file.h"

extern List_file *nbParam;
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
   query.prepare("INSERT INTO Parcelle (owner, parcelleFile, type) VALUES (:owner, :parcelleFile, :type)");
   query.bindValue(":owner", owner);
   query.bindValue(":parcelleFile", polygon);
   query.bindValue(":type", type);
   if(query.exec()) success = true;
   else qDebug() << "addParcelle error:  " << query.lastError();

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

QList<QString> DbManager::getAllParcelle(QString username) {
    QList<QString> res = *new QList<QString>();
    QString foo = "SELECT parcelleFile FROM Parcelle WHERE owner = \""+ username + "\"";
    QSqlQuery query (foo);
    int idName = query.record().indexOf("parcelleFile");
    while (query.next()) {
        qDebug() << query.value(idName).toString();
        res.append(query.value(idName).toString());
    }
    qDebug() << "size of res " + QString::number(res.size());
    return res;
}

bool DbManager::addMission(const QString& owner, const QString& ordre) {
   bool success = false;
   if (owner == "" || ordre == "") return success;

   QSqlQuery query;
   query.prepare("INSERT INTO Mission (owner, missionFile) VALUES (:owner, :missionFile)");
   query.bindValue(":owner", owner);
   query.bindValue(":missionFile", ordre);
   if(query.exec()) success = true;
   else qDebug() << "addUMission error:  " << query.lastError();

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

QList<QString> DbManager::getAllMission(QString username) {
    QList<QString> res = *new QList<QString>();
    QString foo = "SELECT missionFile FROM Mission WHERE owner = \""+ username + "\"";
    QSqlQuery query (foo);
    int idName = query.record().indexOf("missionFile");
    while (query.next()) {
        qDebug() << query.value(idName).toString();
        res.append(query.value(idName).toString());
    }
    qDebug() << "size of res " + QString::number(res.size());
    return res;
}

QString DbManager::getPassword(const QString& user) {
    qDebug() << "----- getPassword -----";
    qDebug() << user;
    QSqlQuery query;
    query.prepare("SELECT * FROM Person WHERE username = (:username)");
    query.bindValue(":username", user);
    if(query.exec()) {
        //qDebug() << "status" << query.size() << query.lastError();
        query.first();
        QString password = query.value("password").toString();
        qDebug() << "query" << password;

        qDebug() << "------------";
        return password;
    }
    else {
        qDebug() << "getPassword error :" << query.lastError();
        qDebug() << "------------";
        return "";
    }

}

QSqlDatabase DbManager::getDB() {
    return m_db;
}


//we return false so that it block if the request come to an error
bool DbManager::verifNbMission(QString username) {
    QSqlQuery query;
    query.prepare("SELECT count(missionFile) FROM Mission WHERE owner = (:username)");
    query.bindValue(":username", username);
    if(query.exec()) {
        query.first();
        QString value = query.value("count(missionFile)").toString();
        qDebug() << "query" << value;
        return value.toInt() <= nbParam->at(2);
    }
    return false;
}

bool DbManager::verifNbParcelle(QString username) {
    QSqlQuery query;
    query.prepare("SELECT count(parcelleFile) FROM Parcelle WHERE owner = (:username)");
    query.bindValue(":username", username);
    if(query.exec()) {
        query.first();
        QString value = query.value("count(parcelleFile)").toString();
        qDebug() << "query" << value;
        return value.toInt() <= nbParam->at(1);
    }
    return false;
}

void DbManager::buildDB() {

    QString tablePerson = "CREATE TABLE \"Person\" ( \"username\"	TEXT NOT NULL UNIQUE, \"password\"	TEXT,  \"nom\"	TEXT, \"prenom\"	TEXT, PRIMARY KEY(\"username\") );";
    QString tableParcelle = "CREATE TABLE \"Parcelle\" (\"owner\"	TEXT NOT NULL, \"parcelleFile\"	TEXT NOT NULL UNIQUE,\"type\"	TEXT,\"speed\"	INTEGER NOT NULL CHECK(speed>0 and speed<4),FOREIGN KEY(\"owner\") REFERENCES \"Person\"(\"username\") ON UPDATE CASCADE ON DELETE CASCADE);";
    QString tableMission = "CREATE TABLE \"Mission\" ( \"owner\"	TEXT NOT NULL, \"missionFile\"	TEXT NOT NULL UNIQUE, PRIMARY KEY(\"missionFile\"), FOREIGN KEY(\"owner\") REFERENCES \"Person\"(\"username\") ON UPDATE CASCADE ON DELETE CASCADE );";

    QSqlQuery queryPerson(tablePerson);
    QSqlQuery queryParcelle(tableParcelle);
    QSqlQuery queryMission(tableMission);

    QString pass = QCryptographicHash::hash("admin", QCryptographicHash::Sha3_256);
    QString addAdmin = "INSERT INTO \"main\".\"Person\" (\"username\", \"password\") VALUES ('admin', '" + pass + "');";
    QSqlQuery queryAddAdmin(addAdmin);

}
