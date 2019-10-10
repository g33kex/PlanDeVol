#include "Login.h"
#include "ui_Login.h"
#include <QMessageBox>
#include <QCryptographicHash>
#include "DataManager/DbManager.h"
#include "Admin.h"

Login::Login(QWidget *parent) : QWidget(parent), ui(new Ui::Login)
{
    ui->setupUi(this);
    qDebug() << "up" ;
    QObject::connect(ui->connectButton, SIGNAL(clicked()), this, SLOT(connection()));
}

Login::Login(QWidget *parent, DbManager *db) : QWidget(parent), ui(new Ui::Login), dbManager(db)
{
    ui->setupUi(this);
    qDebug() << "down" ;
    QObject::connect(ui->connectButton, SIGNAL(clicked()), this, SLOT(connection()));
}

Login::~Login()
{
    delete ui;
}

bool Login::connection() {
    QString login = ui->input_login->text();
    if (login == "") return false;
    QString mdp = QCryptographicHash::hash(ui->input_pass->text().toUtf8(), QCryptographicHash::Sha3_256);
    qDebug() << mdp;
    QString mdp_base = dbManager->getPassword(login);
    if(mdp_base.compare(mdp) == 0) {
        qDebug() << "true";
        if (login.compare("admin") == 0) {
//            admin* admin_widget = new admin(nullptr, dbManager);
//            admin_widget->show();
            this->close();
        }
        else {
            // ICI, on est dans le user !!
            this->close();
        }
        return true;
    }
    else {
        qDebug() << "false";
        QMessageBox::information(this, "login error", "Wrong combinaison of login / password");
        return false;
    }
}
