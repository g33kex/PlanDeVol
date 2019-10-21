#include "LoginController.h"
#include <QMessageBox>
#include <QCryptographicHash>
#include "DataManager/DbManager.h"
#include "Admin.h"


QQmlApplicationEngine* LoginController::qmlAppEngine=nullptr;
LoginController::LoginController()
{
    qDebug() << "up" ;
}

/*LoginController::LoginController(DbManager *db): dbManager(db)
{
    qDebug() << "down" ;
}*/

bool LoginController::connection() {
   /* QString login = ui->input_login->text();
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
    }*/
    return false;
}

void LoginController::loadMainWindow() {

   qmlAppEngine->load(QUrl(QStringLiteral("qrc:/qml/MainRootWindow.qml")));

}

//Returns true if login sucessful and sets global user variable
bool LoginController::login(QString username, QString password) {
    return false;
}
