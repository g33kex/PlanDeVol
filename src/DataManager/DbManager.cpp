#include "DataManager/DbManager.h"
#include <QCryptographicHash>
#include "Admin/List_file.h"
#include <QtXml>
#include <QDateTime>
#include <QList>

extern List_file *nbParam;
extern List_file *lColumn;

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

bool DbManager::addParcelle(const QString& owner, const QString& file, const QString& type, int speed) {
   bool success = false;
   if (owner == "" || file == "") return success;

   QSqlQuery query;
   query.prepare("INSERT INTO Parcelle (owner, parcelleFile, name, type, speed) VALUES (:owner, :parcelleFile, :name, :type, :speed)");
   query.bindValue(":owner", owner);
   query.bindValue(":parcelleFile", file);
   qDebug() << "--------- add Parcelle";
   qDebug() << file.split("/").last();
   query.bindValue(":name", file.split("/").last());
   query.bindValue(":type", type);
   query.bindValue(":speed", speed);
   if(query.exec()) success = true;
   else qDebug() << "addParcelle error:  " << query.lastError();

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

bool DbManager::addMission(const QString& owner, const QString& file) {
   bool success = false;
   if (owner == "" || file == "") return success;

   QSqlQuery query;
   query.prepare("INSERT INTO Mission (owner, missionFile, name) VALUES (:owner, :missionFile, :name)");
   query.bindValue(":owner", owner);
   query.bindValue(":missionFile", file);
   query.bindValue(":name", file.split("/").last());
   if(query.exec()) success = true;
   else qDebug() << "addUMission error:  " << query.lastError();

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
        return value.toInt() < nbParam->at(2).toInt();
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
        qDebug() << nbParam->at(1);
        return value.toInt() < nbParam->at(1).toInt();
    }
    return false;
}

//we return false so that it block if the request come to an error
bool DbManager::verifNbUser() {
    qDebug() << "verif nb user";
    QSqlQuery query("SELECT count(username) FROM Person");
    query.first();
    QString value = query.value("count(username)").toString();
    qDebug() << "query" << value;
    //here, we have a "<=" to include the admin !
    return value.toInt() <= nbParam->at(0).toInt();
}

void DbManager::buildDB() {

    QString tablePerson = "CREATE TABLE \"Person\" ( \"username\"	TEXT NOT NULL UNIQUE, \"password\"	TEXT,  \"nom\"	TEXT, \"prenom\"	TEXT, PRIMARY KEY(\"username\") );";
    QString tableParcelle = "CREATE TABLE \"Parcelle\" (\"owner\"	TEXT NOT NULL, \"parcelleFile\"	TEXT NOT NULL UNIQUE, \"name\" TEXT NOT NULL UNIQUE, \"type\"	TEXT,\"speed\"	INTEGER NOT NULL CHECK(speed>0 and speed<4),FOREIGN KEY(\"owner\") REFERENCES \"Person\"(\"username\") ON UPDATE CASCADE ON DELETE CASCADE);";
    QString tableMission = "CREATE TABLE \"Mission\" ( \"owner\"	TEXT NOT NULL, \"missionFile\"	TEXT NOT NULL UNIQUE, \"name\" TEXT NOT NULL UNIQUE, PRIMARY KEY(\"missionFile\"), FOREIGN KEY(\"owner\") REFERENCES \"Person\"(\"username\") ON UPDATE CASCADE ON DELETE CASCADE );";

    QSqlQuery queryPerson(tablePerson);
    QSqlQuery queryParcelle(tableParcelle);
    QSqlQuery queryMission(tableMission);

    QString pass = QCryptographicHash::hash("admin", QCryptographicHash::Sha3_256);
    QString addAdmin = "INSERT INTO \"main\".\"Person\" (\"username\", \"password\") VALUES ('admin', '" + pass + "');";
    QSqlQuery queryAddAdmin(addAdmin);

}

//Returns true if file doesn't exists
bool DbManager::checkIfExist(QString file) {
    qDebug() << "--------- check if exist";
    qDebug() << file;
    QSqlQuery queryTest;
    queryTest.prepare("SELECT COUNT(*) as foo FROM Parcelle WHERE parcelleFile = (:file)");
    queryTest.bindValue(":file", file);
    if(queryTest.exec()) {
        queryTest.first();
        QString value = queryTest.value("foo").toString();
        qDebug() << "query " << value;
        return value.toInt() == 0;
    }
    return false;
}


void DbManager::saveToXML(QString path) {

    QString filename = path + QDateTime::currentDateTime().toString("ddMMyyyy-hhmmss")+".xml";

    QFile file(filename);
    file.open(QIODevice::WriteOnly);

    QXmlStreamWriter xmlWriter(&file);
    xmlWriter.setAutoFormatting(true);
    xmlWriter.writeStartDocument();


    // root : Database
    xmlWriter.writeStartElement("Database");
    xmlWriter.writeTextElement("Date", QDateTime::currentDateTime().toString("ddMMyyyy-hhmmss") );

    QString reqUser = "SELECT username FROM Person";
    QSqlQuery UserQuery (reqUser);

    while (UserQuery.next()) {
        //list of username
        xmlWriter.writeStartElement("User");
        xmlWriter.writeTextElement("username", UserQuery.value(0).toString());

        QString reqParcelle = "SELECT * FROM Parcelle WHERE owner = \""+ UserQuery.value(0).toString() + "\"";
        QSqlQuery ParcelleQuery (reqParcelle);

        while (ParcelleQuery.next()) {
            //list of parcelle of the corresponding username
            xmlWriter.writeStartElement("Parcelle");

            // write main element of the parcelle
            xmlWriter.writeTextElement("filename", ParcelleQuery.value("name").toString());
            xmlWriter.writeTextElement("pathTo", ParcelleQuery.value("parcelleFile").toString());

            //list of different value of the row (other than owner, name, file and speed)
            for (QList<QString>::iterator i = lColumn->begin(); i!= lColumn->end(); ++i) {
                xmlWriter.writeTextElement(*i, ParcelleQuery.value(*i).toString());
            }

            // close the Parcelle
            xmlWriter.writeEndElement();
        }

        // close the Username
        xmlWriter.writeEndElement();
    }

    // close the Database
    xmlWriter.writeEndElement();

    file.close();

}
