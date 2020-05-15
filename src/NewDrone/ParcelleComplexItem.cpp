/****************************************************************************
 *
 *   (c) 2009-2016 QGROUNDCONTROL PROJECT <http://www.qgroundcontrol.org>
 *
 * QGroundControl is licensed according to the terms in the file
 * COPYING.md in the root of the source code directory.
 *
 ****************************************************************************/


#include "ParcelleComplexItem.hpp"
#include "JsonHelper.h"
#include "MissionController.h"
#include "QGCGeo.h"
#include "QGroundControlQmlGlobal.h"
#include "QGCQGeoCoordinate.h"
#include "SettingsManager.h"
#include "AppSettings.h"
#include "TransectStyleComplexItem.h"

#include <QPolygonF>

QGC_LOGGING_CATEGORY(ParcelleComplexItemLog, "ParcelleComplexItemLog")

const char* ParcelleComplexItem::jsonComplexItemTypeValue =   "survey";
const char* ParcelleComplexItem::jsonV3ComplexItemTypeValue = "survey";

const char* ParcelleComplexItem::settingsGroup =              "Survey";
const char* ParcelleComplexItem::gridAngleName =              "GridAngle";
const char* ParcelleComplexItem::gridEntryLocationName =      "GridEntryLocation";
const char* ParcelleComplexItem::flyAlternateTransectsName =  "FlyAlternateTransects";
const char* ParcelleComplexItem::splitConcavePolygonsName =   "SplitConcavePolygons";

const char* ParcelleComplexItem::_jsonGridAngleKey =          "angle";
const char* ParcelleComplexItem::_jsonEntryPointKey =         "entryLocation";

const char* ParcelleComplexItem::_jsonV3GridObjectKey =                   "grid";
const char* ParcelleComplexItem::_jsonV3GridAltitudeKey =                 "altitude";
const char* ParcelleComplexItem::_jsonV3GridAltitudeRelativeKey =         "relativeAltitude";
const char* ParcelleComplexItem::_jsonV3GridAngleKey =                    "angle";
const char* ParcelleComplexItem::_jsonV3GridSpacingKey =                  "spacing";
const char* ParcelleComplexItem::_jsonV3EntryPointKey =                   "entryLocation";
const char* ParcelleComplexItem::_jsonV3TurnaroundDistKey =               "turnAroundDistance";
const char* ParcelleComplexItem::_jsonV3CameraTriggerDistanceKey =        "cameraTriggerDistance";
const char* ParcelleComplexItem::_jsonV3CameraTriggerInTurnaroundKey =    "cameraTriggerInTurnaround";
const char* ParcelleComplexItem::_jsonV3HoverAndCaptureKey =              "hoverAndCapture";
const char* ParcelleComplexItem::_jsonV3GroundResolutionKey =             "groundResolution";
const char* ParcelleComplexItem::_jsonV3FrontalOverlapKey =               "imageFrontalOverlap";
const char* ParcelleComplexItem::_jsonV3SideOverlapKey =                  "imageSideOverlap";
const char* ParcelleComplexItem::_jsonV3CameraSensorWidthKey =            "sensorWidth";
const char* ParcelleComplexItem::_jsonV3CameraSensorHeightKey =           "sensorHeight";
const char* ParcelleComplexItem::_jsonV3CameraResolutionWidthKey =        "resolutionWidth";
const char* ParcelleComplexItem::_jsonV3CameraResolutionHeightKey =       "resolutionHeight";
const char* ParcelleComplexItem::_jsonV3CameraFocalLengthKey =            "focalLength";
const char* ParcelleComplexItem::_jsonV3CameraMinTriggerIntervalKey =     "minTriggerInterval";
const char* ParcelleComplexItem::_jsonV3CameraObjectKey =                 "camera";
const char* ParcelleComplexItem::_jsonV3CameraNameKey =                   "name";
const char* ParcelleComplexItem::_jsonV3ManualGridKey =                   "manualGrid";
const char* ParcelleComplexItem::_jsonV3CameraOrientationLandscapeKey =   "orientationLandscape";
const char* ParcelleComplexItem::_jsonV3FixedValueIsAltitudeKey =         "fixedValueIsAltitude";
const char* ParcelleComplexItem::_jsonV3Refly90DegreesKey =               "refly90Degrees";
const char* ParcelleComplexItem::_jsonFlyAlternateTransectsKey =          "flyAlternateTransects";
const char* ParcelleComplexItem::_jsonSplitConcavePolygonsKey =           "splitConcavePolygons";

ParcelleComplexItem::ParcelleComplexItem(Vehicle* vehicle, bool flyView, const QString& kmlOrShpFile, QObject* parent)
    : SurveyComplexItem  (vehicle, flyView, settingsGroup, parent)
    , _metaDataMap              (FactMetaData::createMapFromJsonFile(QStringLiteral(":/json/Parcelle.SettingsGroup.json"), this))
    , _gridAngleFact            (settingsGroup, _metaDataMap[gridAngleName])
    , _flyAlternateTransectsFact(settingsGroup, _metaDataMap[flyAlternateTransectsName])
    , _splitConcavePolygonsFact (settingsGroup, _metaDataMap[splitConcavePolygonsName])
    , _entryPoint               (EntryLocationTopLeft)
{
    _editorQml = "qrc:/qml/SurveyItemEditor.qml";

    // If the user hasn't changed turnaround from the default (which is a fixed wing default) and we are multi-rotor set the multi-rotor default.
    // NULL check since object creation during unit testing passes NULL for vehicle
    if (_vehicle && _vehicle->multiRotor() && _turnAroundDistanceFact.rawValue().toDouble() == _turnAroundDistanceFact.rawDefaultValue().toDouble()) {
        // Note this is set to 10 meters to work around a problem with PX4 Pro turnaround behavior. Don't change unless firmware gets better as well.
        _turnAroundDistanceFact.setRawValue(10);
    }

    // We override the altitude to the mission default
    if (_cameraCalc.isManualCamera() || !_cameraCalc.valueSetIsDistance()->rawValue().toBool()) {
        _cameraCalc.distanceToSurface()->setRawValue(qgcApp()->toolbox()->settingsManager()->appSettings()->defaultMissionItemAltitude()->rawValue());
    }

    connect(&_gridAngleFact,            &Fact::valueChanged,                        this, &ParcelleComplexItem::_setDirty);
    connect(&_flyAlternateTransectsFact,&Fact::valueChanged,                        this, &ParcelleComplexItem::_setDirty);
    connect(&_splitConcavePolygonsFact, &Fact::valueChanged,                        this, &ParcelleComplexItem::_setDirty);
    connect(this,                       &ParcelleComplexItem::refly90DegreesChanged,  this, &ParcelleComplexItem::_setDirty);

    connect(&_gridAngleFact,            &Fact::valueChanged,                        this, &ParcelleComplexItem::_rebuildTransects);
    connect(&_flyAlternateTransectsFact,&Fact::valueChanged,                        this, &ParcelleComplexItem::_rebuildTransects);
    connect(&_splitConcavePolygonsFact, &Fact::valueChanged,                        this, &ParcelleComplexItem::_rebuildTransects);
    connect(this,                       &ParcelleComplexItem::refly90DegreesChanged,  this, &ParcelleComplexItem::_rebuildTransects);

    // FIXME: Shouldn't these be in TransectStyleComplexItem? They are also in CorridorScanComplexItem constructur
    connect(&_cameraCalc, &CameraCalc::distanceToSurfaceRelativeChanged, this, &ParcelleComplexItem::coordinateHasRelativeAltitudeChanged);
    connect(&_cameraCalc, &CameraCalc::distanceToSurfaceRelativeChanged, this, &ParcelleComplexItem::exitCoordinateHasRelativeAltitudeChanged);

    if (!kmlOrShpFile.isEmpty()) {
        _surveyAreaPolygon.loadKMLOrSHPFile(kmlOrShpFile);
        _surveyAreaPolygon.setDirty(false);
    }
    setDirty(false);
}
