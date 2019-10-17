#include <QNetworkAccessManager>
#include <QNetworkReply>
#include <QNetworkRequest>
#include <QUrl>
#include <QString>

#ifndef GEOPORTAILLINK_H
#define GEOPORTAILLINK_H

class GeoportailLink : public QObject
{
    Q_OBJECT

public:
    explicit GeoportailLink();
    ~GeoportailLink();

    void requestGeo(QString);

signals:
    void finished(QNetworkReply*);
public slots:
    void Managerfinished(QNetworkReply*);

private:
    QNetworkAccessManager* _qnam;
    QNetworkRequest request;
    QString APIkey = "0ktrk696j3muq3kxsxw22nya";
};

#endif // GEOPORTAILLINK_H
