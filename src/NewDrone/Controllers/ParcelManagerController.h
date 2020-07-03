//#include "DbManager.h"
#include "MissionController.h"
#include "SqlCustomModel.h"
#include "GeoportailLink.h"
#include <QmlObjectListModel.h>
#include <QSqlTableModel>
#include <QNetworkReply>
#include <QGeoCoordinate>

#ifndef PARCELMANAGERCONTROLLER_H
#define PARCELMANAGERCONTROLLER_H

class ParcelManagerController : public QObject {

    Q_OBJECT

public:
    explicit ParcelManagerController();

    ~ParcelManagerController();


    Q_INVOKABLE QVariantList getParcelList();
    Q_INVOKABLE QVariantList getParcelNames();
    Q_INVOKABLE void updateModel(SqlCustomModel *model, bool showAllUsers);

    Q_INVOKABLE bool checkIfExist(QString name);

//    Q_INVOKABLE QSqlTableModel getSqlParcelModel() {return *sqlParcelModel;}
signals:
    void downloadEnded(bool success);

public slots:
    void deleteParcel(SqlCustomModel *model, QList<int> indexes);
    void addToMission(SqlCustomModel *model,MissionController *missionController, QList<int> indexes);
    void modifyParcel(SqlCustomModel *model, int index, QString owner, QString parcelFile, QStringList answers, QList<int> comboAnswers);
    void addParcel(SqlCustomModel *model, QString ilotNumber, QString file, QStringList answers, QList<int> comboAnswers);
    void requestReply(QNetworkReply *reply);
    bool verif(QString user, QString pass);

private:
    void initParcelsPolygons();
    void initParcelsNames();
    void requestParcel(QString nbIlot);
    QList<QString> *toDel;
    MissionController *missionControler;
    GeoportailLink *geoportailParcel;


    SqlCustomModel* _model;
    QString _type;
    QString _file;
    QVariantList* _parcelsPolygons;
    QVariantList* _parcelsNames;
    QStringList _answers;
    QList<int> _comboAnswers;

    bool _showAllUsers;
};

#endif // PARCELMANAGERCONTROLLER_H
