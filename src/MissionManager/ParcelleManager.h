#include <QDialog>
//#include "DbManager.h"
#include "MissionController.h"
#include "Admin/GeoportailLink.h"

#include <QSqlTableModel>
#include <QNetworkReply>

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

    ~ParcelleManager();

signals:
    void downloadEnded(bool);


private slots:
    void deleteParcelle();
    void addToMission();
    void requestParcelle();
    void saveToDb();
    void requestReply(QNetworkReply *reply);

private:
    //void closeEvent(QCloseEvent *bar);
    QList<QString> *toDel;
    Ui::ParcelleManager *ui;
    MissionController *missionControler;
    GeoportailLink *geoportailParcelle;
};

#endif // PARCELLEMANAGER_H
