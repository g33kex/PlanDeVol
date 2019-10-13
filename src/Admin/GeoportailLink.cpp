#include "GeoportailLink.h"

#include <QNetworkAccessManager>
#include <QUrl>
#include <QNetworkReply>

GeoportailLink::GeoportailLink() {
    qDebug() << "contr";

    request = *new QNetworkRequest(QUrl("http://url"));
    request.setRawHeader("User-Agent", "MyOwnBrowser 1.0");
    _qnam = new QNetworkAccessManager(this);
}

GeoportailLink::~GeoportailLink()
{
    delete _qnam;
}

void GeoportailLink::requestGeo(QUrl url) {
    qDebug() << "start";

    request.setUrl(url);
    _qnam->get(request);
}
