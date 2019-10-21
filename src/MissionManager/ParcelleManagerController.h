//#include "DbManager.h"
#include "MissionController.h"
#include "SqlCustomModel.hpp"
#include "Admin/GeoportailLink.h"
#include <QmlObjectListModel.h>
#include <QSqlTableModel>
#include <QNetworkReply>

#ifndef PARCELLEMANAGERCONTROLLER_H
#define PARCELLEMANAGERCONTROLLER_H

class ParcelleManagerController : public QObject {

    Q_OBJECT

public:
    explicit ParcelleManagerController();

    ~ParcelleManagerController();

    Q_PROPERTY(QmlObjectListModel* parcelles READ parcelles CONSTANT)

   // Q_INVOKABLE QSqlTableModel getSqlParcelleModel() {return *sqlParcelleModel;}
signals:
    void downloadEnded(bool);

public slots:
    void deleteParcelle(SqlCustomModel *model, QList<int> indexes);
    void addToMission(SqlCustomModel *model,MissionController *missionController, QList<int> indexes);
    void modifyParcelle(SqlCustomModel *model, int index, QString owner, QString parcelleFile, QString type, int speed);
    void addParcelle(SqlCustomModel *model, QString ilotNumber, QString file, QString type, int speed);
    void requestReply(QNetworkReply *reply);
    bool verif(QString user, QString pass);
    QmlObjectListModel* parcelles();

private:
    void initParcelles();
    void requestParcelle(QString nbIlot);
    //void closeEvent(QCloseEvent *bar);
    QList<QString> *toDel;
    MissionController *missionControler;
    GeoportailLink *geoportailParcelle;
    QString _file;
    QmlObjectListModel* _parcelles;
};

#endif // PARCELLEMANAGERCONTROLLER_H
