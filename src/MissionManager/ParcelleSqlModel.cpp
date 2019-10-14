#include "ParcelleSqlModel.hpp"
#include <QSqlRecord>
#include <QSqlQueryModel>


ParcelleSqlModel::ParcelleSqlModel(QObject *parent)
    : QSqlRelationalTableModel(parent) {
}

QVariant ParcelleSqlModel::data(const QModelIndex &index, int role) const {
    if(index.row() >= rowCount()) {
        return QString("");
    }
    if(role<Qt::UserRole) {
        return QSqlQueryModel::data(index,role);
    }
    else {
        // search for relationships
        for (int i = 0; i < columnCount(); i++) {
            if (this->relation(i).isValid()) {
                    return record(index.row()).value(QString(roles.value(role)));
            }
        }
       return QSqlQueryModel::data(this->index(index.row(), role - Qt::UserRole -1), Qt::DisplayRole);
    }

}

void ParcelleSqlModel::generateRoleNames()
{
    roles.clear();
    roles.clear();
    int nbCols = this->columnCount();

    for (int i = 0; i < nbCols; i++) {
        roles[Qt::UserRole + i + 1] = QVariant(this->headerData(i, Qt::Horizontal).toString()).toByteArray();
    }

}
