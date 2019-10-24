#include "ParcelleManagerController.h"

#include "DataManager/DbManager.h"
#include "Admin/GeoportailLink.h"
#include "ComplexMissionItem.h"
#include "SurveyComplexItem.h"
#include <QSqlTableModel>
#include <QNetworkReply>
#include "MissionController.h"
#include "QGCApplication.h"
#include "Admin/List_file.h"
#include "ShapeFileHelper.h"
#include <QCryptographicHash>
#include <QmlObjectListModel.h>
#include <KMLFileHelper.h>

extern QString username;
extern DbManager *db;
extern List_file *speedParam;

ParcelleManagerController::ParcelleManagerController() {
    geoportailParcelle = new GeoportailLink();
    connect(geoportailParcelle, SIGNAL(finished(QNetworkReply*)), this, SLOT(requestReply(QNetworkReply*)));
    _parcelles = new QVariantList();
    initParcelles();
}

ParcelleManagerController::~ParcelleManagerController()
{

}


void ParcelleManagerController::deleteParcelle(SqlCustomModel *model, QList<int> indexes) {
    for(int i=0; i<indexes.size();i++) {
        qDebug() << "Removing " << indexes[i];
        QFile file (model->record(i).value("parcelleFile").toString());
        file.remove();
        model->removeRow(indexes[i]);
    }
    model->submitAll();
}


void ParcelleManagerController::addToMission(SqlCustomModel *model,MissionController *missionController, QList<int> indexes) {
    qDebug() << "in userSpace::addToMission";


    QMap<QString, double> *KmlParcelleList= new QMap<QString, double>() ;

    for(QList<int>::iterator i = indexes.begin(); i != indexes.end(); ++i)
    {
        QString file = model->record(*i).value("parcelleFile").toString();
        double speed = speedParam->at(model->record(*i).value("speed").toInt()-1).toDouble();
        qDebug() << *i;
        KmlParcelleList->insert(file, speed); // ici il faudra mettre le path
    }
    missionController->insertComplexMissionFromDialog(*KmlParcelleList);
}

void ParcelleManagerController::addParcelle(SqlCustomModel *model, QString ilotNumber, QString file, QString type, int speed) {
    if(!file.endsWith(".kml")) file.append(".kml");

    _file = file;
    _model = model;
    _type = type;
    _speed = speed;

    qDebug() << "----- add Parcelle -----";
    qDebug() << "Requesting " << ilotNumber;

    this->requestParcelle(ilotNumber);
}

void ParcelleManagerController::requestParcelle(QString NbIlot) {
    QString req = "request=GetCapabilities&SERVICE=WFS&VERSION=2.0.0&request=GetFeature&typeName=RPG.2016:parcelles_graphiques&outputFormat=kml&srsname=EPSG:2154&FILTER=%3CFilter%20xmlns=%22http://www.opengis.net/fes/2.0%22%3E%20%3CPropertyIsEqualTo%3E%20%3CValueReference%3Eid_parcel%3C/ValueReference%3E%20%3CLiteral%3E"+ NbIlot +"%3C/Literal%3E%20%3C/PropertyIsEqualTo%3E%20%3C/Filter%3E";
    geoportailParcelle->requestGeo(req);
    return;
}

void ParcelleManagerController::requestReply(QNetworkReply *reply) {
    qDebug() << "requestReply";
    if (reply->error()) {
        qDebug() << reply->errorString();
        emit downloadEnded(false);
        return;
    }

    QString answer = reply->readAll();
    qDebug() << answer;

    // dans une reponse normale, il n'y a qu'un polygon de decrit.
    if (answer.count("<Polygon>") == 1) {
        ShapeFileHelper::savePolygonFromGeoportail(_file, answer);
        QSqlRecord newRecord = _model->record();
        newRecord.setValue("owner", QVariant(username));
        newRecord.setValue("parcelleFile", QVariant(_file));
        newRecord.setValue("name", QVariant(_file.split("/").last()));
        newRecord.setValue("type", QVariant(_type));
        newRecord.setValue("speed",QVariant(_speed));

        /*-1 is set to indicate that it will be added to the last row*/
        if(_model->insertRecord(-1, newRecord)) {
            qDebug()<<"successful insertion" << newRecord.value("owner") << "was its owner";
            _model->submitAll();
        }
        emit downloadEnded(true);
        return;
    }
    qDebug() << "ERROR no awnser or too many";
    emit downloadEnded(false);
    return;
}

void ParcelleManagerController::modifyParcelle(SqlCustomModel *model, int index, QString owner, QString parcelleFile, QString type, int speed) {

    QSqlRecord record = model->record(index);

//    record.setValue("owner", QVariant(owner));
//    record.setValue("parcelleFile", QVariant(parcelleFile));
    record.setValue("type", QVariant(type));
    record.setValue("speed",QVariant(speed));

    bool ok = model->setRecord(index, record);
    qDebug() << ok;
    model->submitAll();
}

bool ParcelleManagerController::verif(QString user, QString pass) {
        if (user == "") return false;
        QString mdp = QCryptographicHash::hash(pass.toUtf8(), QCryptographicHash::Sha3_256);
        qDebug() << mdp;
        QString mdp_base = db->getPassword(user);
        if(mdp_base.compare(mdp) == 0) {
            qDebug() << "true";
            return true;
        }
        else {
            return false;
        }

}

void ParcelleManagerController::initParcelles() {
    qDebug() << "----- init parcelle -----";

    this->_parcelles = new QVariantList();

    QStringList files = QStringList();
    files = db->getAllParcelle(username);


    for(QString file : files) {
        qDebug() << "Looking at file "+file;

        QString error;
        QList<QGeoCoordinate> vertices = QList<QGeoCoordinate>();
        KMLFileHelper::loadPolygonFromFile(file, vertices, error);
        if(error!="") {
            qDebug() << "Error reading parcelle "+file+". Error:" +error;
            continue;
        }
        //Convert QList<QGeoCoordinate> to QVariantList
        QVariantList variantVertices = QVariantList();
        for(QGeoCoordinate coordinate : vertices) {
            variantVertices.append(QVariant::fromValue(coordinate));
        }
        qDebug() << "varientVertices size = " << variantVertices.length();
        qDebug() << "Number of vertices : " << vertices.size();
        this->_parcelles->append(QVariant::fromValue(variantVertices));
        qDebug() << "Parcelle list size: "<<this->_parcelles->length();
    }

    qDebug() << "------------";

}

QVariantList ParcelleManagerController::getParcelleList() {
    _parcelles->clear();
    initParcelles();
    return *this->_parcelles;
}

bool ParcelleManagerController::checkIfExist(QString name) {
    if(! name.endsWith(".kml")) name.append(".kml");
    return db->checkIfExist(name);
}

void ParcelleManagerController::updateModel(SqlCustomModel *model) {
    model->select();
}
