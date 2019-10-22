#include "SqlCustomModel.hpp"
#include <QSqlRecord>
#include <QSqlQueryModel>
#include <QSqlRelationalTableModel>
#include <QDebug>
#include "DataManager/DbManager.h"

extern DbManager *db;
extern QString username;

SqlCustomModel::SqlCustomModel(QObject *parent)
    : QSqlRelationalTableModel(parent, db->getDB()) {

}

QVariant SqlCustomModel::data(const QModelIndex &index, int role) const {

    if(index.row() >= rowCount()) {
        return QString("");
    }
    if(role<Qt::UserRole) {
        return QSqlQueryModel::data(index,role);
    }
    else {
        return QSqlQueryModel::data(this->index(index.row(), role - Qt::UserRole -1), Qt::DisplayRole);
    }

}

void SqlCustomModel::generateRoleNames()
{
    roles.clear();
    roles.clear();
    int nbCols = this->columnCount();

    for (int i = 0; i < nbCols; i++) {
        roles[Qt::UserRole + i + 1] = QVariant(this->headerData(i, Qt::Horizontal).toString()).toByteArray();
        //qDebug() << roles[Qt::UserRole + i + 1];
    }

}

void SqlCustomModel::setupForParcelle() {


    this->setTable("Parcelle");
    if (username != "") {
        QString filtre = QString("owner = \'") + username + QString("\'");
        this->setFilter(filtre);
    }
    this->setEditStrategy(QSqlTableModel::OnManualSubmit);
    this->generateRoleNames();
    this->select();
}

void SqlCustomModel::setupForMission() {
    this->setTable("Mission");
    this->setEditStrategy(QSqlTableModel::OnManualSubmit);
    this->generateRoleNames();
    this->select();
}

void SqlCustomModel::setupForUser() {
    this->setTable("Person");
    this->setEditStrategy(QSqlTableModel::OnManualSubmit);
    this->generateRoleNames();
    this->select();
}

QVariant SqlCustomModel::getRecordValue(int recordIndex, QString role) {
    qDebug() << "getting record value of record" <<recordIndex << " got value " <<  this->record(recordIndex).value(role);
    return this->record(recordIndex).value(role);
}
