#ifndef DBMANAGER_H
#define DBMANAGER_H

#include <QtSql>

class DbManager
{
    public:
        DbManager();
        bool addUser(const QString& username, const QString& password, const QString& nom, const QString& prenom);

        bool addParcel(const QString& owner, const QString& polygon, QString surface, QStringList answers, QList<int> comboAnswers);

        QList<QString> getAllParcel(QString username);
        QList<QString> getAllParcel();
        QList<QString> getAllParcelNames(QString username);

        bool addMission(const QString& owner, const QString& ordre);
        QList<QString> getAllMission(QString user);

        QString getPassword(const QString& user);

        QString getRole(const QString &user);

        QSqlDatabase getDB();

        bool addQuestion(QString name);
        bool deleteQuestion(QList<QString> names);

        bool verifNbMission(QString username);
        bool verifNbParcel(QString username);
        bool verifNbUser();

        bool canCreateParcel(QString username);
        bool canCreateParcel(QString username, double surface);

        bool checkIfExist(QString file);

        QList<QString> getAllColumn();

        void buildDB();

        void saveToXML(QString);

        double getMaximumParcelSurface(QString username);

        //Returns users that are not admin or superadmin
        QStringList *getUsers();

private:
        QSqlDatabase m_db;
};

#endif // DBMANAGER_H
