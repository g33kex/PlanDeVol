#include "LoginController.h"
#include <QMessageBox>
#include <QCryptographicHash>
#include "DataManager/DbManager.h"
#include "Admin/List_file.h"
#include "AppSettings.h"

extern DbManager *db;
extern List_file *checklist;
extern List_file *speedParam;
extern List_file *nbParam;
extern QString username;
extern AppSettings* sett;

QQmlApplicationEngine* LoginController::qmlAppEngine=nullptr;
LoginController::LoginController()
{
    qDebug() << "up" ;
}

void LoginController::loadMainWindow() {

   qmlAppEngine->load(QUrl(QStringLiteral("qrc:/qml/MainRootWindow.qml")));
   sett->_checkSavePathDirectories();
}

//Returns true if login sucessful and sets global user variable
bool LoginController::login(QString user, QString password) {
     if (user == "") return false;
     QString mdp = QCryptographicHash::hash(password.toUtf8(), QCryptographicHash::Sha3_256);
     qDebug() << mdp;
     QString mdp_base = db->getPassword(user);
     if(mdp_base.compare(mdp) == 0) {
         username = user;
         return true;
     }
     return false;
//    username = user;
//    return true;
}

void LoginController::onAdminClosed() {
    checklist->clear();
    //param par defaut if the file is empty
    if (! checklist->load()) {
        qDebug() << "checklist file is empty";
        checklist->append("RAS: Rien a Signaler");
    }

    // verifier qu'il n'y a qu'une occurence de :
    for(QList<QString>::iterator i = checklist->begin(); i != checklist->end(); ++i) {
        if((*i).count(":") < 1) {
            (*i).append(":foo");
        }
        if((*i).count(":") > 1) {
            int index = (*i).indexOf(":");
            (*i) = (*i).replace(":", ";");
            (*i) = (*i).replace(index, 1, ":");
        }
    }

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
    qDebug() << model;

    qDebug() << "------ deleteUser -------";

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
    qDebug() << "------ addUser -------";

    qDebug() << user << "-" << password << "-" << nom << "-" << prenom;
    qDebug() << model;
    QSqlRecord newRecord = model->record();
    qDebug() << "bla";
    newRecord.setValue("username", QVariant(user));
    qDebug() << "blabla";
    QString mdp = QCryptographicHash::hash(password.toUtf8(), QCryptographicHash::Sha3_256);
    qDebug() << mdp;
    newRecord.setValue("password", QVariant(mdp));
    newRecord.setValue("nom", QVariant(nom));
    newRecord.setValue("prenom",QVariant(prenom));

    /*-1 is set to indicate that it will be added to the last row*/
    if(model->insertRecord(-1, newRecord)) {
        qDebug()<<"successful insertion" << newRecord.value("owner") << "was its owner";
        model->submitAll();
    }
    qDebug() << "addUser";
}

void LoginController::setParamSpeed(QString lowSpeed, QString medSpeed, QString highSpeed) {
    qDebug() << "----- save speed -----";
    speedParam->replace(0, lowSpeed);
    speedParam->replace(1, medSpeed);
    speedParam->replace(2, highSpeed);
    speedParam->save();
}


void LoginController::setParamLimit(QString session, QString parcelles, QString missions) {
    qDebug() << "----- save limit -----";
    nbParam->replace(0, session);
    nbParam->replace(1, parcelles);
    nbParam->replace(2, missions);

    nbParam->save();
}

// we do not check here if the checklist respect the regexp +:+
// we check it at the loading
void LoginController::setParamChecklist(QString check) {
    qDebug() << "----- save checklist -----";
    checklist->clear();
    QList<QString> tmp = check.split('\n');
    for (QList<QString>::iterator i = tmp.begin(); i != tmp.end(); ++i) {
        checklist->append(*i);
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

QString LoginController::getNbSession(){
    return nbParam->at(0);
}

QString LoginController::getNbParcelle(){
    return nbParam->at(1);
}

QString LoginController::getNbMission(){
    return nbParam->at(2);
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

    qDebug() << pass.toUtf8();
    qDebug() << hashOld.toUtf8();
    if (hashOld.compare(pass) == 0) {
        record.setValue("password", QVariant(hashNew));
//        record.setValue("parcelleFile", QVariant(parcelleFile));
//        record.setValue("type", QVariant(type));
//        record.setValue("speed",QVariant(speed));
        bool ok = model->setRecord(index, record);
        qDebug() << ok;
        model->submitAll();
        return true;
    }
    else return false;
}

bool LoginController::nbUser(void){
    qDebug() << " --- nb User ---";
    return db->verifNbUser();
}

void LoginController::exportToXML(){
    qDebug() << " --- exportToXML ---";
    qDebug() << sett->savePath()->rawValue().toString();
    return db->saveToXML(sett->savePath()->rawValue().toString());
}

