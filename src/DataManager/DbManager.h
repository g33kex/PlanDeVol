#ifndef DBMANAGER_H
#define DBMANAGER_H

#include <QtSql>

class DbManager
{
    public:
        DbManager();
        bool addUser(const QString& username, const QString& password, const QString& nom, const QString& prenom);

        bool addParcelle(const QString& owner, const QString& polygon, QString surface, QStringList answers, QList<int> comboAnswers);

        QList<QString> getAllParcelle(QString username);

        bool addMission(const QString& owner, const QString& ordre);
        QList<QString> getAllMission(QString user);

        QString getPassword(const QString& user);

        QSqlDatabase getDB();

        bool addQuestion(QString name);
        bool deleteQuestion(QList<QString> names);

        bool verifNbMission(QString username);
        bool verifNbParcelle(QString username);
        bool verifNbUser();

        bool checkIfExist(QString file);

        void buildDB();

        void saveToXML(QString);

    private:
        QSqlDatabase m_db;
};

#endif // DBMANAGER_H
