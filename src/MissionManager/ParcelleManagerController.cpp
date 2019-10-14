#include "ParcelleManagerController.h"

#include "DataManager/DbManager.h"
#include "ComplexMissionItem.h"
#include "SurveyComplexItem.h"
#include <QSqlTableModel>
#include "MissionController.h"
#include "QGCApplication.h"


extern QString username;
extern DbManager *db;


ParcelleManagerController::ParcelleManagerController(MissionController *missionControler) :
    missionControler(missionControler)
{
    toDel = new QList<QString>();

    ParcelleSqlModel *model = new  ParcelleSqlModel;

    model = new ParcelleSqlModel();
    model->generateRoleNames();
    model->select();


    /*sqlParcelleModel->setTable("Parcelle");
    sqlParcelleModel->setEditStrategy(QSqlTableModel::OnManualSubmit);
//    QString filtre = QString("owner = \'") + username + QString("\'");
//    qDebug() << filtre;
//    SqlParcelleModel->setFilter(filtre);
    sqlParcelleModel->select();
    sqlParcelleModel->setHeaderData(0, Qt::Horizontal, tr("owner"));
    sqlParcelleModel->setHeaderData(1, Qt::Horizontal, tr("file"));
    sqlParcelleModel->setHeaderData(2, Qt::Horizontal, tr("type"));
    sqlParcelleModel->setHeaderData(3, Qt::Horizontal, tr("id"));*/

    //ui->sqlView->setModel(SqlParcelleModel);

    /*connect(ui->mission_B, SIGNAL(clicked()), this, SLOT(addToMission()));
    connect(ui->add_B, SIGNAL(clicked()), this, SLOT(addParcelle()));
    connect(ui->rm_B, SIGNAL(clicked()), this, SLOT(deleteParcelle()));
    connect(ui->save_B, SIGNAL(clicked()), this, SLOT(saveToDb()));*/
}

ParcelleManagerController::ParcelleManagerController() {}

ParcelleManagerController::~ParcelleManagerController()
{

}


void ParcelleManagerController::deleteParcelle() {
  /*  qDebug() << "in userSpace::deleteParcelle";
    QModelIndexList selection = ui->sqlView->selectionModel()->selectedRows();
    for(int i=0; i< selection.count(); i++)
    {
        QModelIndex index = selection.at(i);
        qDebug() << SqlParcelleModel->record(index.row()).value("parcelleFile").toString();
        toDel->append(SqlParcelleModel->record(index.row()).value("parcelleFile").toString());
        SqlParcelleModel->removeRow(index.row());
    }*/
}


void ParcelleManagerController::addToMission() {
    qDebug() << "in userSpace::addToMission";
    /*QModelIndexList selection = ui->sqlView->selectionModel()->selectedRows();
    QList<QString> *KmlParcelleList= new QList<QString>() ;

    for(int i=0; i< selection.count(); i++)
    {
        QModelIndex index = selection.at(i);
        qDebug() << index.row();
        KmlParcelleList->append("foo"); // ici il faudra mettre le path
    }
    missionControler->insertComplexMissionFromDialog(*KmlParcelleList);
    this->deleteLater();*/
}

void ParcelleManagerController::addParcelle() {
    return;
}

/*void ParcelleManager::closeEvent(QCloseEvent *bar) {
    bar->ignore();
    this->deleteLater();
}*/

void ParcelleManagerController::saveToDb() {
    for (QList<QString>::iterator i = toDel->begin(); i != toDel->end(); ++i) {
        QFile file ((*i));
        file.remove();
    }
    toDel->clear();
    //sqlParcelleModel->submitAll();
}



