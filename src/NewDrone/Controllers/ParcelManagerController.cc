#include "ParcelManagerController.h"

#include "DbManager.h"
#include "GeoportailLink.h"
#include "QuestionFile.h"
#include "ComplexMissionItem.h"
#include "SurveyComplexItem.h"
#include <QSqlTableModel>
#include <QNetworkReply>
#include "MissionController.h"
#include "QGCApplication.h"
#include "ShapeFileHelper.h"
#include <QCryptographicHash>
#include <QmlObjectListModel.h>
#include <KMLFileHelper.h>
#include <QtXmlPatterns/QXmlQuery>

extern QString username;
extern DbManager *db;
extern QuestionFile *questionFile;

ParcelManagerController::ParcelManagerController() {
    geoportailParcel = new GeoportailLink();
    connect(geoportailParcel, SIGNAL(finished(QNetworkReply*)), this, SLOT(requestReply(QNetworkReply*)));
    _parcelsPolygons = new QVariantList();
    _parcelsNames = new QVariantList();
    initParcelsPolygons();
    initParcelsNames();
}

ParcelManagerController::~ParcelManagerController()
{

}


void ParcelManagerController::deleteParcel(SqlCustomModel *model, QList<int> indexes) {
    for(int i=0; i<indexes.size();i++) {
        QFile file (model->record(indexes[i]).value("parcelFile").toString());
        file.remove();
        model->removeRow(indexes[i]);
    }
    model->submitAll();
}


void ParcelManagerController::addToMission(SqlCustomModel *model,MissionController *missionController, QList<int> indexes) {
    QList<QString> *KmlParcelList= new QList<QString>() ;

    for(QList<int>::iterator i = indexes.begin(); i != indexes.end(); ++i)
    {
        QString file = model->record(*i).value("parcelFile").toString();
        KmlParcelList->append(file);
    }
    missionController->insertComplexMissionFromDialog(*KmlParcelList);
}

//TODO : add Q&A
void ParcelManagerController::addParcel(SqlCustomModel *model, QString ilotNumber, QString file, QStringList answers, QList<int> comboAnswers) {
    if(!file.endsWith(".kml")) file.append(".kml");

    _file = file;
    _model = model;
    _answers.clear();
    _answers.append(answers);
    _comboAnswers.clear();
    _comboAnswers.append(comboAnswers);

    this->requestParcel(ilotNumber);
}

void ParcelManagerController::requestParcel(QString NbIlot) {
    QString req = "request=GetCapabilities&SERVICE=WFS&VERSION=2.0.0&request=GetFeature&typeName=RPG.2016:parcels_graphiques&outputFormat=kml&srsname=EPSG:2154&FILTER=%3CFilter%20xmlns=%22http://www.opengis.net/fes/2.0%22%3E%20%3CPropertyIsEqualTo%3E%20%3CValueReference%3Eid_parcel%3C/ValueReference%3E%20%3CLiteral%3E"+ NbIlot +"%3C/Literal%3E%20%3C/PropertyIsEqualTo%3E%20%3C/Filter%3E";
    geoportailParcel->requestGeo(req);
    return;
}

//void readRatesUsingXQuery_expanded(const QFileInfo file) {


//    QStringList surface;
//    QXmlQuery query;
//    query.setQuery(queryUrl.arg("surface"));
//    query.evaluateTo(&surface);
//}


void ParcelManagerController::requestReply(QNetworkReply *reply) {
    if (reply->error()) {
        qDebug() << reply->errorString();
        emit downloadEnded(false);
        return;
    }

    QString answer = reply->readAll();


    // dans une reponse normale, il n'y a qu'un polygon de decrit.
    if (answer.count("<Polygon>") == 1) {
        float surface = ShapeFileHelper::savePolygonFromGeoportail(_file, answer);
        QSqlRecord newRecord = _model->record();
        newRecord.setValue("owner", QVariant(username));
        newRecord.setValue("parcelFile", QVariant(_file));
        newRecord.setValue("name", QVariant(_file.split("/").last()));
        newRecord.setValue("surface", QVariant(QString::number(double(surface), 'f', 2)));


        QList<QString> names = questionFile->getNames();
        for(int i = 0; i < _answers.length(); i++){
            newRecord.setValue(names[i], _answers[i]);
        }

        QList<QString> namesCombo = questionFile->getNamesCombo();
        for(int i = 0; i < _comboAnswers.length(); i++){
            QList<QString> repPossible = questionFile->getAnswers().at(i);
            newRecord.setValue(namesCombo[i], repPossible.at(_comboAnswers[i]));
        }

        /*-1 is set to indicate that it will be added to the last row*/
        if(_model->insertRecord(-1, newRecord)) {
            _model->submitAll();
        }
        emit downloadEnded(true);
        return;
    }
    qDebug() << "ERROR no awnser or too many";
    emit downloadEnded(false);
    return;
}



void ParcelManagerController::modifyParcel(SqlCustomModel *model, int index, QString owner, QString parcelFile, QStringList answers, QList<int> comboAnswers) {

    QSqlRecord record = model->record(index);
    QList<QString> names = questionFile->getNames();
    for(int i = 0; i < answers.length(); i++){
        record.setValue(names[i], answers[i]);
    }

    QList<QString> namesCombo = questionFile->getNamesCombo();
    for(int i = 0; i < comboAnswers.length(); i++){
        QList<QString> repPossible = questionFile->getAnswers().at(i);
        record.setValue(namesCombo[i], repPossible.at(comboAnswers[i]));
    }

    bool ok = model->setRecord(index, record);
    qDebug() << ok;
    model->submitAll();
}

bool ParcelManagerController::verif(QString user, QString pass) {
        if (user == "") return false;
        QString mdp = QCryptographicHash::hash(pass.toUtf8(), QCryptographicHash::Sha3_256);
        QString mdp_base = db->getPassword(user);
        if(mdp_base.compare(mdp) == 0) {
            return true;
        }
        else {
            return false;
        }

}

void ParcelManagerController::initParcelsPolygons() {
    this->_parcelsPolygons = new QVariantList();

    QStringList files = QStringList();
    if(this->_showAllUsers) {
        files = db->getAllParcel();
    }
    else {
        files = db->getAllParcel(username);
    }


    for(QString file : files) {
        QString error;
        QList<QGeoCoordinate> vertices = QList<QGeoCoordinate>();
        KMLFileHelper::loadPolygonFromFile(file, vertices, error);
        if(error!="") {
            qDebug() << "Error reading parcel "+file+". Error:" +error;
            continue;
        }
        //Convert QList<QGeoCoordinate> to QVariantList
        QVariantList variantVertices = QVariantList();
        for(QGeoCoordinate coordinate : vertices) {
            variantVertices.append(QVariant::fromValue(coordinate));
        }
        this->_parcelsPolygons->append(QVariant::fromValue(variantVertices));
    }

}

void ParcelManagerController::initParcelsNames() {
    this->_parcelsNames = new QVariantList();

    QStringList names = QStringList();
    if(this->_showAllUsers) {
        names = db->getAllParcel();
    }
    else {
        names = db->getAllParcel(username);
    }


    for(QString name : names) {
        name = name.split('/').last();
        this->_parcelsNames->append(QVariant::fromValue(name));
    }

}

QVariantList ParcelManagerController::getParcelList() {
    _parcelsPolygons->clear();
    initParcelsPolygons();
    return *this->_parcelsPolygons;
}

//TODO : return name of parcels in the same order as coordinate in getParcelList
QVariantList ParcelManagerController::getParcelNames() {
    _parcelsNames->clear();
    initParcelsNames();
    return *this->_parcelsNames;
}

bool ParcelManagerController::checkIfExist(QString name) {
    if(! name.endsWith(".kml")) name.append(".kml");
    return db->checkIfExist(name);
}

void ParcelManagerController::updateModel(SqlCustomModel *model, bool showAllUsers) {
    this->_showAllUsers=showAllUsers;
    model->select();
}
