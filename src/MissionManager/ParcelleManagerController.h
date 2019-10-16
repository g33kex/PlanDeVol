//#include "DbManager.h"
#include "MissionController.h"
#include "SqlParcelleModel.hpp"

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
    void deleteParcelle(SqlParcelleModel *model, int index);
    void addToMission();
    void addParcelle(SqlParcelleModel *model);
    void saveToDb();

private:
    //void closeEvent(QCloseEvent *bar);
    QList<QString> *toDel;
    MissionController *missionControler;
};

#endif // PARCELLEMANAGERCONTROLLER_H
