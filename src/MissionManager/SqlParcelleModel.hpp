#ifndef PARCELLESQLMODEL_H
#define PARCELLESQLEMODEL_H

#include <QSqlRelationalTableModel>

class SqlParcelleModel : public QSqlRelationalTableModel
{
    Q_OBJECT

private:
    QHash<int, QByteArray> roles;

public:
    explicit SqlParcelleModel(QObject *parent = nullptr);

    Q_INVOKABLE QVariant data(const QModelIndex &index, int role=Qt::DisplayRole) const override;
    Q_INVOKABLE bool setData(const QModelIndex &item, const QVariant &value, int role) override;

    void generateRoleNames();

    Q_INVOKABLE void setupForParcelle();
    QHash<int, QByteArray> roleNames() const override {	return roles;	}

};

#endif // PARCELLESQLMODEL_H
