#include "DataManager/DbManager.h"

#ifndef PARCELLESQLMODEL_H
#define PARCELLESQLEMODEL_H

#include <QSqlRelationalTableModel>

class SqlCustomModel : public QSqlRelationalTableModel
{
    Q_OBJECT

private:
    QHash<int, QByteArray> roles;

public:
    explicit SqlCustomModel(QObject *parent = nullptr);

    Q_INVOKABLE QVariant data(const QModelIndex &index, int role=Qt::DisplayRole) const override;
//    Q_INVOKABLE bool setData(const QModelIndex &item, const QVariant &value, int role) override;

    void generateRoleNames();

    Q_INVOKABLE void setupForParcelle();
    QHash<int, QByteArray> roleNames() const override {	return roles;	}

    Q_INVOKABLE QVariant getRecordValue(int recordIndex, QString role);

};

#endif // PARCELLESQLMODEL_H
