#ifndef PARCELLESQLMODEL_H
#define PARCELLESQLEMODEL_H

#include <QSqlRelationalTableModel>

class ParcelleSqlModel : public QSqlRelationalTableModel
{
    Q_OBJECT

private:
    QHash<int, QByteArray> roles;

public:
    explicit ParcelleSqlModel(QObject *parent = nullptr);

    Q_INVOKABLE QVariant data(const QModelIndex &index, int role=Qt::DisplayRole) const override;
    void generateRoleNames();

};

#endif // PARCELLESQLMODEL_H
