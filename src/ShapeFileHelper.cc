/****************************************************************************
 *
 *   (c) 2009-2016 QGROUNDCONTROL PROJECT <http://www.qgroundcontrol.org>
 *
 * QGroundControl is licensed according to the terms in the file
 * COPYING.md in the root of the source code directory.
 *
 ****************************************************************************/

#include "ShapeFileHelper.h"
#include "AppSettings.h"
#include "KMLFileHelper.h"
#include "SHPFileHelper.h"
#include "DataManager/DbManager.h"

#include <QFile>
#include <QVariant>
#include "QGCQGeoCoordinate.h"

const char* ShapeFileHelper::_errorPrefix = QT_TR_NOOP("Shape file load failed. %1");
extern QString username;
extern DbManager *db;
//extern QSqlTableModel *sqlParcelleModel;


QVariantList ShapeFileHelper::determineShapeType(const QString& file)
{
    QString errorString;
    ShapeType shapeType = determineShapeType(file, errorString);

    QVariantList varList;
    varList.append(QVariant::fromValue(shapeType));
    varList.append(QVariant::fromValue(errorString));

    return varList;
}

bool ShapeFileHelper::_fileIsKML(const QString& file, QString& errorString)
{
    errorString.clear();

    if (file.endsWith(AppSettings::kmlFileExtension)) {
        return true;
    } else if (file.endsWith(AppSettings::shpFileExtension)) {
        return false;
    } else {
        errorString = QString(_errorPrefix).arg(tr("Unsupported file type. Only .%1 and .%2 are supported.").arg(AppSettings::kmlFileExtension).arg(AppSettings::shpFileExtension));
    }

    return true;
}

ShapeFileHelper::ShapeType ShapeFileHelper::determineShapeType(const QString& file, QString& errorString)
{
    ShapeType shapeType = Error;

    errorString.clear();

    bool fileIsKML = _fileIsKML(file, errorString);
    if (errorString.isEmpty()) {
        if (fileIsKML) {
            shapeType = KMLFileHelper::determineShapeType(file, errorString);
        } else {
            shapeType = SHPFileHelper::determineShapeType(file, errorString);
        }
    }

    return shapeType;
}

bool ShapeFileHelper::loadPolygonFromFile(const QString& file, QList<QGeoCoordinate>& vertices, QString& errorString)
{
    bool success = false;

    errorString.clear();
    vertices.clear();

    bool fileIsKML = _fileIsKML(file, errorString);
    if (errorString.isEmpty()) {
        if (fileIsKML) {
            success = KMLFileHelper::loadPolygonFromFile(file, vertices, errorString);
        } else {
            success = SHPFileHelper::loadPolygonFromFile(file, vertices, errorString);
        }
    }

    return success;
}

bool ShapeFileHelper::loadPolylineFromFile(const QString& file, QList<QGeoCoordinate>& coords, QString& errorString)
{
    errorString.clear();
    coords.clear();

    bool fileIsKML = _fileIsKML(file, errorString);
    if (errorString.isEmpty()) {
        if (fileIsKML) {
            KMLFileHelper::loadPolylineFromFile(file, coords, errorString);
        } else {
            errorString = QString(_errorPrefix).arg(tr("Polyline not support from SHP files."));
        }
    }

    return errorString.isEmpty();
}

QStringList ShapeFileHelper::fileDialogKMLFilters(void) const
{
    return QStringList(tr("KML Files (*.%1)").arg(AppSettings::kmlFileExtension));
}

QStringList ShapeFileHelper::fileDialogKMLOrSHPFilters(void) const
{
    return QStringList(tr("KML/SHP Files (*.%1 *.%2)").arg(AppSettings::kmlFileExtension).arg(AppSettings::shpFileExtension));
}

bool ShapeFileHelper::savePolygonFromGeoportail(QString filepath, QString content, int speed) {
    QFile file( filepath );
    if ( file.open(QIODevice::WriteOnly) ) {
        QTextStream stream( &file );
        stream << content;
        file.close();
        db->addParcelle(username, filepath, "");        //on ajoute le fichier a la DB !
        //SqlParcelleModel->select();
        return true;
    }
    qDebug() << "ERROR";
    return -1;
}

bool ShapeFileHelper::savePolygonToKML(QString path, QmlObjectListModel* _polygonModel, int speed) {
    QFile file( path );
    if ( file.open(QIODevice::WriteOnly) ) {
        QTextStream stream( &file );
        stream << "<?xml version=\"1.0\" encoding=\"UTF-8\"?>" << endl;
        stream << "<kml xmlns=\"http://www.opengis.net/kml/2.2\">" << endl;
        stream << "<Placemark>" << endl;
        stream << "<name>The Pentagon</name>" << endl;
        stream << "<Polygon>" << endl;
        stream << "<extrude>1</extrude>" << endl;
        stream << "<outerBoundaryIs>" << endl;
        stream << "<LinearRing>" << endl;
        stream << "<coordinates>" << endl;

        for (QList<QObject*>::iterator j = _polygonModel->objectList()->begin(); j != _polygonModel->objectList()->end(); j++)
        {
            qDebug() << (((QGCQGeoCoordinate*) (*j))->toString());
            stream << (((QGCQGeoCoordinate*) (*j))->toString()) << ",50" << endl; //le dernier element étant l'altitude du tracé, il n'est pas important
        }

        stream << "</coordinates>" << endl;
        stream << "</LinearRing>" << endl;
        stream << "</outerBoundaryIs>" << endl;
        stream << "</Polygon>" << endl;
        stream << "</Placemark>" << endl;
        stream << "</kml>" << endl;
        file.close();

        // valeur par defaut : le milieu
        if (!(speed == 0 || speed == 1 || speed == 2)) {
            speed = 1;
        }
        db->addParcelle(username, path, "");        //on ajoute le fichier a la DB !
//        sqlParcelleModel->select();
        return 0;
    }
    qDebug() << "ERROR";
    return -1;
}
