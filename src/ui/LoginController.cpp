#include "LoginController.h"
#include <QMessageBox>
#include <QCryptographicHash>
#include "DataManager/DbManager.h"
#include "Admin/List_file.h"
#include "Admin/QuestionFile.h"
#include "AppSettings.h"

extern DbManager *db;
extern List_file *checklist;
extern List_file *speedParam;
extern List_file *nbParam;
extern List_file *altParam;
extern List_file *flightParam;
extern QString username;
extern AppSettings* sett;
extern QuestionFile* questionFile;

QQmlApplicationEngine* LoginController::qmlAppEngine=nullptr;
LoginController::LoginController()
{
}

void LoginController::loadMainWindow() {
   //qmlAppEngine->load(QUrl(QStringLiteral("qrc:/qml/MainRootWindow.qml")));
   sett->_checkSavePathDirectories();
}

//Returns true if login sucessful and sets global user variable
bool LoginController::login(QString user, QString password) {
     if (user == "") return false;
     QString mdp = QCryptographicHash::hash(password.toUtf8(), QCryptographicHash::Sha3_256);
     QString mdp_base = db->getPassword(user);
     if(mdp_base.compare(mdp) == 0) {
         username = user;
         return true;
     }
     return false;
}

void LoginController::onAdminClosed() {


    //Reload the checklist
    checklist->clear();
    //param par defaut if the file is empty
    if (! checklist->load()) {
        qDebug() << "checklist file is empty";
        checklist->append("RAS: Rien a Signaler");
    }

    // verifier qu'il n'y a qu'une occurence de :
    for(QList<QString>::iterator i = checklist->begin(); i != checklist->end(); ++i) {
        //we jump the empty line
        if((*i).length() < 2) {
            continue;
        }
        if((*i).count(":") < 1) {
            (*i).append(":foo");
        }
        if((*i).count(":") > 1) {
            int index = (*i).indexOf(":");
            (*i) = (*i).replace(":", ";");
            (*i) = (*i).replace(index, 1, ":");
        }
    }
    //if the checklist is empty
    if(checklist->length() == 0) {
        checklist->append("RAS:RAS");
    }

    //Reload the flight param
    speedParam->clear();
    //param par defaut if the file is empty
    if (! speedParam->load()) {
        qDebug() << "speedParam file is empty";
        speedParam->clear();
        speedParam->append("15");
        speedParam->append("30");
        speedParam->append("40");
    }

    //permet de contenir le nombre de sessions, missions et parcelles
    nbParam->clear();
    //param par defaut if the file is empty
    if (! nbParam->load()) {
        qDebug() << "nbParam file is empty";
        nbParam->clear();
        nbParam->append("10");
        nbParam->append("10");
        nbParam->append("10");
    }

    altParam->clear();
    if (! altParam->load()) {
        altParam->clear();
        altParam->append("30");
        altParam->append("50");
        altParam->append("100");
        qDebug() << "altParam file is empty" << altParam->size();
    }

    flightParam->clear();
    if (! flightParam->load()) {
        flightParam->clear();
        flightParam->append("10"); //turnaround
        flightParam->append("10"); //Tolerance
        flightParam->append("2"); //MaxClimbRate
        flightParam->append("2"); //MaxDescentRate
        qDebug() << "flightParam file is empty" << flightParam->size();
    }


    questionFile->clear();
    questionFile->load();
}

void LoginController::deleteMission(SqlCustomModel *model, QList<int> indexes) {
    for(int i=0; i<indexes.size();i++) {
        qDebug() << "Removing " << indexes[i];
        QFile file (model->record(indexes[i]).value("missionFile").toString());
        file.remove();
        model->removeRow(indexes[i]);
    }
    model->submitAll();
}


void LoginController::deleteUser(SqlCustomModel *model, QList<int> indexes) {
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


void LoginController::addUser(SqlCustomModel *model, QString user, QString password, QString nom, QString prenom) {
    QSqlRecord newRecord = model->record();
    newRecord.setValue("username", QVariant(user));
    QString mdp = QCryptographicHash::hash(password.toUtf8(), QCryptographicHash::Sha3_256);
    newRecord.setValue("password", QVariant(mdp));
    newRecord.setValue("nom", QVariant(nom));
    newRecord.setValue("prenom",QVariant(prenom));

    /*-1 is set to indicate that it will be added to the last row*/
    if(model->insertRecord(-1, newRecord)) {
        model->submitAll();
    }
}

void LoginController::setParamSpeed(QString lowSpeed, QString medSpeed, QString highSpeed) {
    speedParam->replace(0, lowSpeed);
    speedParam->replace(1, medSpeed);
    speedParam->replace(2, highSpeed);
    speedParam->save();
}

void LoginController::setParamAlt(QString lowAlt, QString medAlt, QString highAlt) {
    altParam->replace(0, lowAlt);
    altParam->replace(1, medAlt);
    altParam->replace(2, highAlt);
    altParam->save();
}

void LoginController::setParamFlight(QString turn, QString tol, QString maxClimb, QString maxDescent) {
    flightParam->replace(0, turn);
    flightParam->replace(1, tol);
    flightParam->replace(2, maxClimb);
    flightParam->replace(3, maxDescent);
    flightParam->save();
}


void LoginController::setParamLimit(QString session, QString parcelles, QString missions) {
    nbParam->replace(0, session);
    nbParam->replace(1, parcelles);
    nbParam->replace(2, missions);

    nbParam->save();
}

// we do not check here if the checklist respect the regexp +:+
// we check it at the loading
void LoginController::setParamChecklist(QString check) {
    checklist->clear();
    QList<QString> tmp = check.split('\n');
    for (QList<QString>::iterator i = tmp.begin(); i != tmp.end(); ++i) {
        if(!(*i).isEmpty()) {
            checklist->append(*i);
        }
    }
    checklist->save();
}


QString LoginController::getSpeedLow() {
    return speedParam->at(0);
}

QString LoginController::getSpeedMed(){
    return speedParam->at(1);
}

QString LoginController::getSpeedHigh(){
    return speedParam->at(2);
}

QString LoginController::getAltLow() {
    return altParam->at(0);
}

QString LoginController::getAltMed(){
    return altParam->at(1);
}

QString LoginController::getAltHigh(){
    return altParam->at(2);
}

QString LoginController::getNbSession(){
    return nbParam->at(0);
}

QString LoginController::getNbParcelle(){
    return nbParam->at(1);
}

QString LoginController::getNbMission(){
    return nbParam->at(2);
}

QString LoginController::getTurn(){
    return flightParam->at(0);
}

QString LoginController::getTolerance(){
    return flightParam->at(1);
}

QString LoginController::getMaxClimbRate(){
    return flightParam->at(2);
}

QString LoginController::getMaxDescentRate(){
    return flightParam->at(3);
}

QString LoginController::getParamChecklist() {
    QString res = "";
    int size = checklist->size();
    for (int i = 0; i < size; i++) {
        res += checklist->at(i);
        res += '\n';
    }
    return res;
}

void LoginController::modifyUser(SqlCustomModel *model, int index, QString username, QString nom, QString prenom) {

    QSqlRecord record = model->record(index);

    record.setValue("username", QVariant(username));
//    QString pass = db->getPassword(username);
//    record.setValue("password",QVariant(pass));
    record.setValue("nom", QVariant(nom));
    record.setValue("prenom", QVariant(prenom));

    bool ok = model->setRecord(index, record);
    qDebug() << ok;
    model->submitAll();
}

bool LoginController::modifyPassword(SqlCustomModel *model, int index, QString username, QString oldPass, QString newPass) {

    QSqlRecord record = model->record(index);
    QString pass = db->getPassword(username);

    QString hashOld = QCryptographicHash::hash(oldPass.toUtf8(), QCryptographicHash::Sha3_256);
    QString hashNew = QCryptographicHash::hash(newPass.toUtf8(), QCryptographicHash::Sha3_256);
    if (hashOld.compare(pass) == 0) {
        record.setValue("password", QVariant(hashNew));
        bool ok = model->setRecord(index, record);
        model->submitAll();
        return true;
    }
    else return false;
}

bool LoginController::nbUser(void){
    return db->verifNbUser();
}

void LoginController::exportToXML() {
    return db->saveToXML(sett->savePath()->rawValue().toString());
}

