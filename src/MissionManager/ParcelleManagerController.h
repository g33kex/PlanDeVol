//#include "DbManager.h"
#include "MissionController.h"
#include "SqlParcelleModel.hpp"
#include "Admin/GeoportailLink.h"

#include <QSqlTableModel>
#include <QNetworkReply>

#ifndef PARCELLEMANAGERCONTROLLER_H
#define PARCELLEMANAGERCONTROLLER_H

class ParcelleManagerController : public QObject {

    Q_OBJECT

public:
    explicit ParcelleManagerController(MissionController *missionControler);
    explicit ParcelleManagerController();

    ~ParcelleManagerController();



   // Q_INVOKABLE QSqlTableModel getSqlParcelleModel() {return *sqlParcelleModel;}
signals:
    void downloadEnded(bool);

public slots:
    void deleteParcelle(SqlParcelleModel *model, QList<int> indexes);
    void addToMission(SqlParcelleModel *model, QList<int> indexes);
    void addParcelle(SqlParcelleModel *model);
    //void saveToDb();

private:
    void requestReply(QNetworkReply *reply);
    void requestParcelle(QString nbIlot);
    //void closeEvent(QCloseEvent *bar);
    QList<QString> *toDel;
    MissionController *missionControler;
    GeoportailLink *geoportailParcelle;
};

#endif // PARCELLEMANAGERCONTROLLER_H
