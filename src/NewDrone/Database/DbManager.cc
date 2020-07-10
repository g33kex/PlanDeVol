#include "DbManager.h"
#include <QCryptographicHash>
#include "QuestionFile.h"
#include <QtXml>
#include <QDateTime>
#include <QList>
#include "AppSettings.h"

//extern List_file *lColumn;
extern AppSettings* sett;
extern QuestionFile *questionFile;

DbManager::DbManager() {
    m_db = QSqlDatabase::addDatabase("QSQLITE");
    m_db.setDatabaseName(sett->savePath()->rawValue().toString()+"/database.sqlite3");



    if (!m_db.open()) {
        qDebug() << "Error: connection with database fail";
    }
    else {
        QSqlQuery pragma("PRAGMA foreign_keys = ON");
        pragma.exec();
    }
}

bool DbManager::addUser(const QString& username, const QString& password, const QString& nom, const QString& prenom) {
    bool success = false;
    if (username == "" ) return success;
    QString hashpassword = QCryptographicHash::hash(password.toUtf8(), QCryptographicHash::Sha3_256);
    QSqlQuery query;
    if( ! query.prepare("INSERT INTO Users (username, password, nom, prenom) VALUES (:username, :password, :nom, :prenom)")) {
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

//TODO WARNING : this function is vulnerable to trivial SQL injection attacks...
bool DbManager::addParcel(const QString& owner, const QString& file,QString surface, QStringList answers, QList<int> comboAnswers) {
   bool success = false;
   if (owner == "" || file == "") return success;

   QString prep = "INSERT INTO Parcel (owner, parcelFile, name, surface";
   QSqlQuery query;
   QString posVal = "(?,?,?,?";

   QList<QString> names = questionFile->getNames();
   for(int i = 0; i < names.length(); i++){
       prep = prep + "," + names[i];
       posVal = posVal + ",?";
   }

   QList<QString> namesCombo = questionFile->getNamesCombo();
   for(int i = 0; i < namesCombo.length(); i++){
       prep = prep + "," + namesCombo.at(i);
       posVal = posVal + ",?";
   }

   prep = prep + ") VALUES " + posVal +")";

   query.prepare(prep);
   query.addBindValue(owner);
   query.addBindValue(file);
   query.addBindValue(file.split("/").last());
   query.addBindValue(surface);

   for(int i = 0; i < answers.length(); i++){
       query.addBindValue(answers[i]);
   }

   for(int i = 0; i < comboAnswers.length(); i++){
       QList<QString> repPossible = questionFile->getAnswers().at(i);
       query.addBindValue(repPossible.at(comboAnswers[i]));
   }

   if(query.exec()) success = true;
   else qDebug() << "addParcel error:  " << query.lastError() << query.lastQuery() << "Answer length : " << answers.length() << "Combo lenght" << comboAnswers.length();

   return success;
}


QList<QString> DbManager::getAllParcel(QString username) {
    QList<QString> res = *new QList<QString>();
    QString foo = "SELECT parcelFile FROM Parcel WHERE owner = \""+ username + "\"";
    QSqlQuery query (foo);
    int idName = query.record().indexOf("parcelFile");
    while (query.next()) {
        res.append(query.value(idName).toString());
    }
    return res;
}

QList<QString> DbManager::getAllParcel() {
    QList<QString> res = *new QList<QString>();
    QString foo = "SELECT parcelFile FROM Parcel";
    QSqlQuery query (foo);
    int idName = query.record().indexOf("parcelFile");
    while (query.next()) {
        res.append(query.value(idName).toString());
    }
    return res;
}

QList<QString> DbManager::getAllParcelNames(QString username) {
    QList<QString> res = *new QList<QString>();
    QString foo = "SELECT name FROM Parcel WHERE owner = \""+ username + "\"";
    QSqlQuery query (foo);
    int idName = query.record().indexOf("name");
    while (query.next()) {
        res.append(query.value(idName).toString());
    }
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
        res.append(query.value(idName).toString());
    }
    qDebug() << "size of res " + QString::number(res.size());
    return res;
}

QString DbManager::getPassword(const QString& user) {
    QSqlQuery query;
    query.prepare("SELECT * FROM Users WHERE username = (:username)");
    query.bindValue(":username", user);
    if(query.exec()) {
        query.first();
        QString password = query.value("password").toString();
        return password;
    }
    else {
        qDebug() << "getPassword error :" << query.lastError();
        return "";
    }

}

QString DbManager::getRole(const QString& user) {
    QSqlQuery query;
    query.prepare("SELECT * FROM Users WHERE username = (:username)");
    query.bindValue(":username", user);
    if(query.exec()) {
        query.first();
        QString role = query.value("role").toString();
        return role;
    }
    else {
        qDebug() << "getRole error :" << query.lastError();
        return "";
    }
}

QSqlDatabase DbManager::getDB() {
    return m_db;
}


//we return false so that it block if the request come to an error
//TODO : phase 4
bool DbManager::verifNbMission(QString username) {
    return true;
   /* QSqlQuery query;
    query.prepare("SELECT count(missionFile) FROM Mission WHERE owner = (:username)");
    query.bindValue(":username", username);
    if(query.exec()) {
        query.first();
        QString value = query.value("count(missionFile)").toString();
        return value.toInt() < nbParam->at(2).toInt();
    }
    return false;*/
}

bool DbManager::verifNbParcel(QString username) {
    return true;
   /* QSqlQuery query;
    query.prepare("SELECT count(parcelFile) FROM Parcel WHERE owner = (:username)");
    query.bindValue(":username", username);
    if(query.exec()) {
        query.first();
        QString value = query.value("count(parcelFile)").toString();
        return value.toInt() < nbParam->at(1).toInt();
    }
    return false;*/
}

//we return false so that it block if the request come to an error
bool DbManager::verifNbUser() {
    return true;
    /*QSqlQuery query("SELECT count(username) FROM Users");
    query.first();
    QString value = query.value("count(username)").toString();
    //here, we have a "<=" to include the admin !
    return value.toInt() <= nbParam->at(0).toInt()+1;*/
}

bool DbManager::canCreateParcel(QString username) {
    QSqlQuery query("SELECT allowParcelCreation FROM Users WHERE username = (?)");
    query.addBindValue(username); //Always use addBindValue instead of bindValue to avoid "Parameter count mismatch" issue
    if(query.exec()) {

        query.first();
        QString value = query.value("allowParcelCreation").toString();
        if(value == "yes") {
            return true;
        }
    }
    qDebug() << "Can create parcel returns false, error is " << query.lastError();
    return false;
}

bool DbManager::canCreateParcel(QString username, double surface) {
    QSqlQuery query("SELECT SUM(CAST(surface as decimal)) AS totalSurface FROM Parcel WHERE owner = (?)");
    query.addBindValue(username);
    if(query.exec()) {
        query.first();
        double value = query.value("totalSurface").toDouble();
        qDebug() << "Total surface = " << value << " max surface = " << getMaximumParcelSurface(username) << " parcel surface = " << surface;
        if(surface+value <= getMaximumParcelSurface(username)) {
            return true;
        }
    }
    return false;
}

double DbManager::getMaximumParcelSurface(QString username) {
    QSqlQuery query("SELECT maximumParcelSurface FROM Users WHERE username = (?)");
    query.addBindValue(username);
    if(query.exec()) {
        query.first();
        double value = query.value("maximumParcelSurface").toDouble();
        return value;
    }
    return 0;
}

QStringList *DbManager::getUsers() {
    qDebug() << "In getUsers";
    QSqlQuery query("SELECT username FROM Users WHERE role = 'User'");
    QStringList *list = new QStringList();
    while(query.next()) {
        list->append(query.value("username").toString());
        qDebug() << "Adding user " << query.value("username").toString();
    }
    return list;
}



void DbManager::buildDB() {

    QString tableUsers = "CREATE TABLE IF NOT EXISTS Users("
                          "username TEXT NOT NULL UNIQUE PRIMARY KEY, "
                          "password TEXT, "
                          "firstname TEXT, "
                          "lastname TEXT, "
                          "role TEXT CHECK(role IN ('User', 'Admin', 'SuperAdmin')) DEFAULT 'User', "
                          "allowParcelCreation TEXT DEFAULT('no') CHECK(allowParcelCreation = 'no' or (allowParcelCreation = 'yes' and role = 'User')), "
                          "maximumParcelSurface INTEGER DEFAULT 0"
                          ");";

    QString tableParcel = "CREATE TABLE IF NOT EXISTS Parcel("
                            "owner TEXT NOT NULL, "
                            "parcelFile TEXT NOT NULL UNIQUE, "
                            "name TEXT NOT NULL UNIQUE, "
                            "surface TEXT, "
                            "FOREIGN KEY(owner) REFERENCES Users(username) ON UPDATE CASCADE ON DELETE CASCADE);";

    QString tableMission = "CREATE TABLE IF NOT EXISTS Mission("
                           "owner TEXT NOT NULL, "
                           "missionFile TEXT NOT NULL UNIQUE PRIMARY KEY, "
                           "name TEXT NOT NULL UNIQUE, "
                           "FOREIGN KEY(owner) REFERENCES Users(username) ON UPDATE CASCADE ON DELETE CASCADE);";

    QSqlQuery queryUsers(tableUsers);
    QSqlQuery queryParcel(tableParcel);
    QSqlQuery queryMission(tableMission);

#ifdef QT_DEBUG
    QString adminPass = QCryptographicHash::hash("admin", QCryptographicHash::Sha3_256);
    QString addAdmin = "INSERT INTO main.Users(username, password, role) VALUES ('admin', '" + adminPass + "', 'Admin');";
    QString addTestUser = "INSERT INTO main.Users(username, firstname, lastname, role, allowParcelCreation, maximumParcelSurface) VALUES ('john', 'John', 'Smith', 'User', 'yes', 1000)";
    QSqlQuery queryAddAdmin(addAdmin);
    QSqlQuery queryTestUser(addTestUser);
#endif

    QSqlQuery findSuperAdmins = QSqlQuery("SELECT username from Users where role='SuperAdmin'");
    if(!findSuperAdmins.first())
    {
        qDebug() << "No SuperAdmin account, creating default.";
        QString superAdminPass = QCryptographicHash::hash("superadmin", QCryptographicHash::Sha3_256);
        QString addSuperAdmin = "INSERT OR REPLACE INTO main.Users(username, password, role) VALUES ('superadmin', '" + superAdminPass + "', 'SuperAdmin');";
        QSqlQuery queryAddSuperAdmin(addSuperAdmin);
    }

}

//Returns true if file doesn't exists
bool DbManager::checkIfExist(QString file) {
    QSqlQuery queryTest;
    queryTest.prepare("SELECT COUNT(*) as foo FROM Parcel WHERE parcelFile = (:file)");
    queryTest.bindValue(":file", file);
    if(queryTest.exec()) {
        queryTest.first();
        QString value = queryTest.value("foo").toString();
        return value.toInt() == 0;
    }
    return false;
}


void DbManager::saveToXML(QString path) {

    QString filename = sett->savePath()->rawValue().toString() + "/" + QDateTime::currentDateTime().toString("ddMMyyyy-hhmmss")+".xml";

    QFile file(filename);
    file.open(QIODevice::WriteOnly);

    QXmlStreamWriter xmlWriter(&file);
    xmlWriter.setAutoFormatting(true);
    xmlWriter.writeStartDocument();


    // root : Database
    xmlWriter.writeStartElement("Database");
    xmlWriter.writeTextElement("Date", QDateTime::currentDateTime().toString("ddMMyyyy-hhmmss") );

    QString reqUser = "SELECT username FROM Users";
    QSqlQuery UserQuery (reqUser);

    while (UserQuery.next()) {
        //list of username
        xmlWriter.writeStartElement("User");
        xmlWriter.writeTextElement("username", UserQuery.value(0).toString());

        QString reqParcel = "SELECT * FROM Parcel WHERE owner = \""+ UserQuery.value(0).toString() + "\"";
        QSqlQuery ParcelQuery (reqParcel);

        while (ParcelQuery.next()) {
            //list of parcel of the corresponding username
            xmlWriter.writeStartElement("Parcel");

            // write main element of the parcel
            xmlWriter.writeTextElement("filename", ParcelQuery.value("name").toString());
            xmlWriter.writeTextElement("pathTo", ParcelQuery.value("parcelFile").toString());

            xmlWriter.writeStartElement("Info");
            QList<QString> names = questionFile->getNames();
            //list of different value of the row (other than owner, name, file)
            for (int i = 0; i < names.length(); i++) {
                xmlWriter.writeTextElement(names[i], ParcelQuery.value(names[i]).toString());
            }

            QList<QString> namesCombo = questionFile->getNamesCombo();
            //list of different value of the row (other than owner, name, file)
            for (int i = 0; i < namesCombo.length(); i++) {
                xmlWriter.writeTextElement(namesCombo[i], ParcelQuery.value(namesCombo[i]).toString());
            }
            xmlWriter.writeEndElement();

            // close the Parcel
            xmlWriter.writeEndElement();
        }

        // close the Username
        xmlWriter.writeEndElement();
    }

    // close the Database
    xmlWriter.writeEndElement();

    file.close();

}

bool DbManager::addQuestion(QString name) {
    QSqlQuery query;
    QString prep = "ALTER TABLE Parcel ADD \"" + name + "\" TEXT;";
    if(!query.exec(prep))  qDebug() << "add question error: " << query.lastError() << query.lastQuery();
    return true;
}


bool DbManager::deleteQuestion(QList<QString> names) {
    QSqlDatabase::database().transaction();
    QSqlQuery query;

    QString prep = "CREATE TABLE IF NOT EXISTS parcel2 ("\
                   "\"owner\" TEXT NOT NULL,"\
                   "\"parcelFile\" TEXT NOT NULL UNIQUE,"\
                   "\"name\" TEXT NOT NULL UNIQUE,"\
                   "\"surface\" TEXT,";

    for (int i = 0; i < names.length(); i++) {
        prep = prep + "\"" + names[i] + "\"	TEXT,";
    }
    prep = prep + "FOREIGN KEY(\"owner\") REFERENCES \"Users\"(\"username\") ON UPDATE CASCADE ON DELETE CASCADE);";
    if(!query.exec(prep))  qDebug() << "addUser error:  " << query.lastError() << prep;

    prep = "INSERT INTO parcel2(owner, parcelFile, name, surface";
    for (int i = 0; i < names.length(); i++) {
        prep = prep + "," + names[i];
    }

    prep = prep + ")"
                  "SELECT owner, parcelFile, name, surface";
    for (int i = 0; i < names.length(); i++) {
        prep = prep + "," + names[i];
    }
    prep = prep + " FROM Parcel;";
    if(!query.exec(prep))  qDebug() << "addUser error:  " << query.lastError() << prep;

    prep = "DROP TABLE Parcel;";
    if(!query.exec(prep))  qDebug() << "addUser error:  " << query.lastError() << prep;

    prep = "ALTER TABLE parcel2 RENAME TO Parcel;";
    if(!query.exec(prep))  qDebug() << "addUser error:  " << query.lastError() << prep;

    QSqlDatabase::database().commit();
    return true;
}


QList<QString> DbManager::getAllColumn() {
    QList<QString> res = *new QList<QString>();
    QString foo = "select name from PRAGMA_TABLE_INFO(\"Parcel\");";
    QSqlQuery query (foo);
    int idName = query.record().indexOf("name");
    while (query.next()) {
        res.append(query.value(idName).toString());
    }
    return res;
}
