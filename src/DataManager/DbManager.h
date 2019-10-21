#ifndef DBMANAGER_H
#define DBMANAGER_H

#include <QtSql>

class DbManager
{
    public:
        DbManager();
        bool addUser(const QString& username, const QString& password, const QString& nom, const QString& prenom);
        bool deleteUser(const QString& username);
        bool modifyUser(const QString& username, const QString& nom, const QString& prenom);
        QVector<QString> * getAllUser();

        bool addParcelle(const QString& owner, const QString& polygon, const QString& type);
        bool deleteParcelle(const int id);
        QList<QString> getAllParcelle(QString username);

        bool addMission(const QString& owner, const QString& ordre);
        bool deleteMission(const int id);
        QMap<QString, int> * getAllMission();

        QString getPassword(const QString& user);

        QSqlDatabase getDB();

        bool getNbMission(QString username);
        bool getNbParcelle(QString username);
    private:
        QSqlDatabase m_db;
};

#endif // DBMANAGER_H
