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
        // We do not want the user to modify the owner or the polygon (so that he will not
        // add more parcelle than he can)
        bool modifyTypeParcelle(const int id, const QString& type);
        QMap<QString, int>* getAllParcelle();

        bool addMission(const QString& owner, const QString& ordre);
        bool deleteMission(const int id);
        // We do not want the user to modify the owner or the polygon (so that he will not
        // add more mission than he can)
        bool modifyMission(const int id, const QString& ordre);
        QMap<QString, int> * getAllMission();

        QString getPassword(const QString& user);

        QSqlDatabase getDB();
    private:
        QSqlDatabase m_db;
};

#endif // DBMANAGER_H
