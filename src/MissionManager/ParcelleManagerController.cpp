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

//    SqlParcelleModel *model = new SqlParcelleModel();
//    model->generateRoleNames();
//    model->select();


//    sqlParcelleModel->setTable("Parcelle");
//    sqlParcelleModel->setEditStrategy(QSqlTableModel::OnManualSubmit);
//    QString filtre = QString("owner = \'") + username + QString("\'");
//    qDebug() << filtre;
//    SqlParcelleModel->setFilter(filtre);
//    sqlParcelleModel->select();
//    sqlParcelleModel->setHeaderData(0, Qt::Horizontal, tr("owner"));
//    sqlParcelleModel->setHeaderData(1, Qt::Horizontal, tr("file"));
//    sqlParcelleModel->setHeaderData(2, Qt::Horizontal, tr("type"));
//    sqlParcelleModel->setHeaderData(3, Qt::Horizontal, tr("id"));*/

//    ui->sqlView->setModel(SqlParcelleModel);

//    connect(ui->mission_B, SIGNAL(clicked()), this, SLOT(addToMission()));
//    connect(ui->add_B, SIGNAL(clicked()), this, SLOT(addParcelle()));
//    connect(ui->rm_B, SIGNAL(clicked()), this, SLOT(deleteParcelle()));
//    connect(ui->save_B, SIGNAL(clicked()), this, SLOT(saveToDb()));
}

ParcelleManagerController::ParcelleManagerController() {}

ParcelleManagerController::~ParcelleManagerController()
{

}


void ParcelleManagerController::deleteParcelle(SqlParcelleModel *model, int index) {
    qDebug() << "Removing " << index;
  /*  qDebug() << "in userSpace::deleteParcelle";
    QModelIndexList selection = ui->sqlView->selectionModel()->selectedRows();
    for(int i=0; i< selection.count(); i++)
    {
        QModelIndex index = selection.at(i);
        qDebug() << SqlParcelleModel->record(index.row()).value("parcelleFile").toString();
        toDel->append(SqlParcelleModel->record(index.row()).value("parcelleFile").toString());
        SqlParcelleModel->removeRow(index.row());
    }*/
    model->removeRow(index);
    model->submitAll();



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

void ParcelleManagerController::addParcelle(SqlParcelleModel *model) {
    QSqlRecord newRecord = model->record();
    newRecord.setValue("owner", QVariant("foo"));
    newRecord.setValue("parcelleFile", QVariant("The Litigators"));
    newRecord.setValue("type", QVariant("test"));
    newRecord.setValue("speed",QVariant(int(2)));
//  qDebug() << "Insert row" << model->insertRecord(model->rowCount(), newRecord);

    /*-1 is set to indicate that it will be added to the last row*/

    if(model->insertRecord(-1, newRecord)) {
        qDebug()<<"successful insertion" << newRecord.value("owner") << "was its owner";
        model->submitAll();
    }
//    QSqlRecord  writtenRec( model->record(model->rowCount() - 1 ) );
//    qDebug() << "owner of inserted record: " << writtenRec.value("owner") << "row field name 0" << writtenRec.fieldName(0);

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



