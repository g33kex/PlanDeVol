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


    Q_INVOKABLE QVariantList getParcelleList();
    Q_INVOKABLE QVariantList getParcelleNames();
    Q_INVOKABLE void updateModel(SqlCustomModel *model);

    Q_INVOKABLE bool checkIfExist(QString name);

//    Q_INVOKABLE QSqlTableModel getSqlParcelleModel() {return *sqlParcelleModel;}
signals:
    void downloadEnded(bool success);

public slots:
    void deleteParcelle(SqlCustomModel *model, QList<int> indexes);
    void addToMission(SqlCustomModel *model,MissionController *missionController, QList<int> indexes);
    void modifyParcelle(SqlCustomModel *model, int index, QString owner, QString parcelleFile, QStringList answers, QList<int> comboAnswers);
    void addParcelle(SqlCustomModel *model, QString ilotNumber, QString file, QStringList answers, QList<int> comboAnswers);
    void requestReply(QNetworkReply *reply);
    bool verif(QString user, QString pass);

private:
    void initParcellesPolygons();
    void initParcellesNames();
    void requestParcelle(QString nbIlot);
    QList<QString> *toDel;
    MissionController *missionControler;
    GeoportailLink *geoportailParcelle;


    SqlCustomModel* _model;
    QString _type;
    QString _file;
    QVariantList* _parcellesPolygons;
    QVariantList* _parcellesNames;
    QStringList _answers;
    QList<int> _comboAnswers;
};

#endif // PARCELLEMANAGERCONTROLLER_H
