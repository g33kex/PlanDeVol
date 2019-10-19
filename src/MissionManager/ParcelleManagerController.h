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
    void deleteParcelle(SqlParcelleModel *model, QList<int> indexes);
    void addToMission(SqlParcelleModel *model, QList<int> indexes);
    void modifyParcelle(SqlParcelleModel *model, int index, QString owner, QString parcelleFile, QString type, int speed);
    void addParcelle(SqlParcelleModel *model, QString ilotNumber, QString file, QString type, int speed);
    //void saveToDb();

private:
    //void closeEvent(QCloseEvent *bar);
    QList<QString> *toDel;
    MissionController *missionControler;
};

#endif // PARCELLEMANAGERCONTROLLER_H
