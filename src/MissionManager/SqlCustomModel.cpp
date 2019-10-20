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
        // search for relationships
       /*
        for (int i = 0; i < columnCount(); i++) {
            if (this->relation(i).isValid()) {
                    return record(index.row()).value(QString(roles.value(role)));
            }
        }*/
      //  qDebug() << "Fetching data, role" << role-Qt::UserRole-1 << "data " << QSqlQueryModel::data(this->index(index.row(), role - Qt::UserRole -1), Qt::DisplayRole);
       return QSqlQueryModel::data(this->index(index.row(), role - Qt::UserRole -1), Qt::DisplayRole);
    }

}

//bool SqlParcelleModel::setData(const QModelIndex &item, const QVariant &value, int role)
//{
//    qDebug() << "Setting data with value" << value;
//    if (item.isValid() && role == Qt::EditRole) {
//        ((QSqlTableModel) this->parent()).setData(item,value,role);
//       // qDebug() << "validata=" << QSqlTableModel::setData(item, value,role);
//        emit dataChanged(item, item);
//        return true;
//    }
//    return false;

//}

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
    QString filtre = QString("owner = \'") + username + QString("\'");
    this->setFilter(filtre);
    this->setEditStrategy(QSqlTableModel::OnManualSubmit);
    this->generateRoleNames();
    this->select();

  // qDebug() << "in setupforparcelle:" << rowCount();


   /* for (int i = 0; i < rowCount(); ++i) {
        QString owner = record(i).value("owner").toString();
        QString file = record(i).value("parcelleFile").toString();
        qDebug() << owner << file;
    }*/

}

QVariant SqlCustomModel::getRecordValue(int recordIndex, QString role) {
    qDebug() << "getting record value of record" <<recordIndex << " got value " <<  this->record(recordIndex).value(role);
    return this->record(recordIndex).value(role);
}
