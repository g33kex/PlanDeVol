//#include "DbManager.h"
#include "MissionController.h"
#include "SqlCustomModel.hpp"
#include "Admin/GeoportailLink.h"
#include <QmlObjectListModel.h>
#include <QSqlTableModel>
#include <QNetworkReply>
#include <QGeoCoordinate>

#ifndef PARCELLEMANAGERCONTROLLER_H
#define PARCELLEMANAGERCONTROLLER_H

class ParcelleManagerController : public QObject {

    Q_OBJECT

public:
    explicit ParcelleManagerController();

    ~ParcelleManagerController();


    Q_INVOKABLE QVariantList getParcelleList() {return *this->_parcelles;}

//    Q_INVOKABLE QSqlTableModel getSqlParcelleModel() {return *sqlParcelleModel;}
signals:
    void downloadEnded(bool);

public slots:
    void deleteParcelle(SqlCustomModel *model, QList<int> indexes);
    void addToMission(SqlCustomModel *model,MissionController *missionController, QList<int> indexes);
    void modifyParcelle(SqlCustomModel *model, int index, QString owner, QString parcelleFile, QString type, int speed);
    void addParcelle(SqlCustomModel *model, QString ilotNumber, QString file, QString type, int speed);
    void requestReply(QNetworkReply *reply);
    bool verif(QString user, QString pass);

private:
    void initParcelles();
    void requestParcelle(QString nbIlot);
    QList<QString> *toDel;
    MissionController *missionControler;
    GeoportailLink *geoportailParcelle;


    SqlCustomModel* _model;
    QString _type;
    int _speed;
    QString _file;
    QVariantList* _parcelles;
};

#endif // PARCELLEMANAGERCONTROLLER_H
