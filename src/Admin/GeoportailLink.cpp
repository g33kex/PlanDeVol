#include "GeoportailLink.h"

#include <QNetworkAccessManager>
#include <QUrl>
#include <QNetworkReply>
#include <QString>

GeoportailLink::GeoportailLink() {
    request = *new QNetworkRequest(QUrl("http://url"));
    request.setRawHeader("User-Agent", "MyOwnBrowser 1.0");
    _qnam = new QNetworkAccessManager(this);
    QObject::connect(_qnam, SIGNAL(finished(QNetworkReply*)), this, SLOT(Managerfinished(QNetworkReply*)));
}

GeoportailLink::~GeoportailLink()
{
    delete _qnam;
}

void GeoportailLink::requestGeo(QString req) {
    request.setUrl(QUrl(QString("https://wxs.ign.fr/") + APIkey + QString("/geoportail/wfs?") + req));
    _qnam->get(request);
}

void GeoportailLink::Managerfinished(QNetworkReply* reply) {
    emit finished(reply);
}
