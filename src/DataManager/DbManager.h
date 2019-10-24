#ifndef DBMANAGER_H
#define DBMANAGER_H

#include <QtSql>

class DbManager
{
    public:
        DbManager();
        bool addUser(const QString& username, const QString& password, const QString& nom, const QString& prenom);

        bool addParcelle(const QString& owner, const QString& polygon, const QString& type, int speed);

        QList<QString> getAllParcelle(QString username);

        bool addMission(const QString& owner, const QString& ordre);
        QList<QString> getAllMission(QString user);

        QString getPassword(const QString& user);

        QSqlDatabase getDB();

        bool verifNbMission(QString username);
        bool verifNbParcelle(QString username);

        bool checkIfExist(QString file);

        void buildDB();

    private:
        QSqlDatabase m_db;
};

#endif // DBMANAGER_H
