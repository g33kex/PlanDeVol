#include "admin.h"
#include "ui_Admin.h"
#include "DataManager/DbManager.h"
#include "login.h"
#include <QSqlTableModel>
#include <QMessageBox>


Admin::Admin(QWidget *parent) : QWidget(parent), ui(new Ui::Admin) {
    ui->setupUi(this);
}

Admin::Admin(QWidget *parent, DbManager *db) : QWidget(parent), ui(new Ui::Admin), db(db) {
    ui->setupUi(this);
    list_User = *db->getAllUser();
    SqlPersonmodel = new QSqlTableModel(this, db->getDB());
    SqlPersonmodel->setTable("Person");
    SqlPersonmodel->setEditStrategy(QSqlTableModel::OnManualSubmit);
    SqlPersonmodel->select();
    SqlPersonmodel->setHeaderData(0, Qt::Horizontal, tr("username"));
    SqlPersonmodel->setHeaderData(1, Qt::Horizontal, tr("password"));
    SqlPersonmodel->setHeaderData(2, Qt::Horizontal, tr("nom"));
    SqlPersonmodel->setHeaderData(3, Qt::Horizontal, tr("prenom"));

    ui->listUser->setModel(SqlPersonmodel);
    ui->listUser->hideColumn(1);

//    QMap<QString, int> *map = fpara->getMap();

//    ui->in_low->setText(QString::number(map->value("lowSpeed")));
//    ui->in_med->setText(QString::number(map->value("medSpeed")));
//    ui->in_fast->setText(QString::number(map->value("fastSpeed")));


    connect(ui->disco_B, SIGNAL(clicked()), this, SLOT(disconnect()));
    connect(ui->userB_save, SIGNAL(clicked()), this, SLOT(saveUser()));
    connect(ui->userB_del, SIGNAL(clicked()), this, SLOT(deleteUser()));
    connect(ui->userB_create, SIGNAL(clicked()), this, SLOT(addUser()));
    connect(ui->save_B, SIGNAL(clicked()), this, SLOT(saveFlightParam()));
}

Admin::~Admin() {
    delete ui;
}

void Admin::disconnect() {
    qDebug() << "in admin::disconnect";
    Login* login_widget = new Login(nullptr, db);
    login_widget->show();
    this->close();
}

void Admin::addUser() {
    qDebug() << "in admin::addUser";
//    dialog_add_user* add_widget = new dialog_add_user(nullptr, SqlPersonmodel);
//    add_widget->show();
}

void Admin::saveUser() {
    qDebug() << "in admin::saveUser";
    SqlPersonmodel->submitAll();
}

void Admin::deleteUser() {
    qDebug() << "in admin::deleteUser";
    QModelIndexList selection = ui->listUser->selectionModel()->selectedRows();

    for(int i=0; i< selection.count(); i++)
    {
        QModelIndex index = selection.at(i);
        qDebug() << index.row();
        SqlPersonmodel->removeRow(index.row());
    }
}

//void admin::saveFlightParam() {
//    int low = ui->in_low->text().toInt();
//    int med = ui->in_med->text().toInt();
//    int fast = ui->in_fast->text().toInt();
//    if(0<low && low<100 && 0<med && med<100 && 0<fast && fast<100) {
//        fpara->alter("lowSpeed", low);
//        fpara->alter("medSpeed", med);
//        fpara->alter("fastSpeed", fast);
//        fpara->saveToFile();
//    }
//    else
//        QMessageBox::information(this, "Input Error", "A Flight Param is not valid");

//}

