//#include "DbManager.h"
#include "MissionController.h"
#include "ParcelleSqlModel.hpp"

#include <QSqlTableModel>

#ifndef PARCELLEMANAGERCONTROLLER_H
#define PARCELLEMANAGERCONTROLLER_H

class ParcelleManagerController : public QObject {

    Q_OBJECT

public:
    explicit ParcelleManagerController(MissionController *missionControler);
    explicit ParcelleManagerController();

    ~ParcelleManagerController();



   // Q_INVOKABLE QSqlTableModel getSqlParcelleModel() {return *sqlParcelleModel;}

public slots:
    void deleteParcelle();
    void addToMission();
    void addParcelle();
    void saveToDb();

private:
    //void closeEvent(QCloseEvent *bar);
    QList<QString> *toDel;
    MissionController *missionControler;
};

#endif // PARCELLEMANAGERCONTROLLER_H
