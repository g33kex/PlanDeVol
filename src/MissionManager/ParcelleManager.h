#include <QDialog>
//#include "DbManager.h"
#include "MissionController.h"

#include <QSqlTableModel>

#ifndef PARCELLEMANAGER_H
#define PARCELLEMANAGER_H

namespace Ui {
class ParcelleManager;
}

class ParcelleManager : public QDialog
{
    Q_OBJECT

public:
    explicit ParcelleManager(QWidget *parent = nullptr);
    explicit ParcelleManager(QWidget *parent, MissionController *missionControler);

    static void showParcelleManager(MissionController *missionControler);

    ~ParcelleManager();

private slots:
    void deleteParcelle();
    void addToMission();

private:
    void closeEvent(QCloseEvent *bar);
    Ui::ParcelleManager *ui;
    QSqlTableModel *SqlParcelleModel;
    MissionController *missionControler;
};

#endif // PARCELLEMANAGER_H
