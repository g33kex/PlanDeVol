#include "TransectStyleComplexItem.h"
#include "MissionItem.h"
#include "SettingsFact.h"
#include "QGCLoggingCategory.h"
#include "SurveyComplexItem.h"

#ifndef PARCELLECOMPLEXITEM_H
#define PARCELLECOMPLEXITEM_H

#include <QObject>

Q_DECLARE_LOGGING_CATEGORY(ParcelleComplexItemLog)


class ParcelleComplexItem : public SurveyComplexItem
{
    Q_OBJECT

public:
    /// @param vehicle Vehicle which this is being contructed for
    /// @param flyView true: Created for use in the Fly View, false: Created for use in the Plan View
    /// @param kmlOrShpFile Polygon comes from this file, empty for default polygon
    ParcelleComplexItem(Vehicle* vehicle, bool flyView, const QString& kmlOrShpFile, QObject* parent);

    Q_PROPERTY(Fact* gridAngle              READ gridAngle              CONSTANT)
    Q_PROPERTY(Fact* flyAlternateTransects  READ flyAlternateTransects  CONSTANT)
    Q_PROPERTY(Fact* splitConcavePolygons   READ splitConcavePolygons   CONSTANT)

    Fact* gridAngle             (void) { return &_gridAngleFact; }
    Fact* flyAlternateTransects (void) { return &_flyAlternateTransectsFact; }
    Fact* splitConcavePolygons  (void) { return &_splitConcavePolygonsFact; }

    Q_INVOKABLE void rotateEntryPoint(void);

    // Must match json spec for GridEntryLocation
    enum EntryLocation {
        EntryLocationFirst,
        EntryLocationTopLeft = EntryLocationFirst,
        EntryLocationTopRight,
        EntryLocationBottomLeft,
        EntryLocationBottomRight,
        EntryLocationLast = EntryLocationBottomRight
    };

    static const char* jsonComplexItemTypeValue;
    static const char* settingsGroup;
    static const char* gridAngleName;
    static const char* gridEntryLocationName;
    static const char* flyAlternateTransectsName;
    static const char* splitConcavePolygonsName;

    static const char* jsonV3ComplexItemTypeValue;

signals:
    void refly90DegreesChanged(bool refly90Degrees);

private slots:
    // Overrides from TransectStyleComplexItem
//    void _rebuildTransectsPhase1    (void) final;
//    void _recalcComplexDistance     (void) final;
//    void _recalcCameraShots         (void) final;

private:
    enum CameraTriggerCode {
        CameraTriggerNone,
        CameraTriggerOn,
        CameraTriggerOff,
        CameraTriggerHoverAndCapture
    };

    SettingsFact    _gridAngleFact;
    SettingsFact    _flyAlternateTransectsFact;
    SettingsFact    _splitConcavePolygonsFact;
    int             _entryPoint;
    QMap<QString, FactMetaData*> _metaDataMap;

    static const char* _jsonGridAngleKey;
    static const char* _jsonEntryPointKey;
    static const char* _jsonFlyAlternateTransectsKey;
    static const char* _jsonSplitConcavePolygonsKey;

    static const char* _jsonV3GridObjectKey;
    static const char* _jsonV3GridAltitudeKey;
    static const char* _jsonV3GridAltitudeRelativeKey;
    static const char* _jsonV3GridAngleKey;
    static const char* _jsonV3GridSpacingKey;
    static const char* _jsonV3EntryPointKey;
    static const char* _jsonV3TurnaroundDistKey;
    static const char* _jsonV3CameraTriggerDistanceKey;
    static const char* _jsonV3CameraTriggerInTurnaroundKey;
    static const char* _jsonV3HoverAndCaptureKey;
    static const char* _jsonV3GroundResolutionKey;
    static const char* _jsonV3FrontalOverlapKey;
    static const char* _jsonV3SideOverlapKey;
    static const char* _jsonV3CameraSensorWidthKey;
    static const char* _jsonV3CameraSensorHeightKey;
    static const char* _jsonV3CameraResolutionWidthKey;
    static const char* _jsonV3CameraResolutionHeightKey;
    static const char* _jsonV3CameraFocalLengthKey;
    static const char* _jsonV3CameraMinTriggerIntervalKey;
    static const char* _jsonV3ManualGridKey;
    static const char* _jsonV3CameraObjectKey;
    static const char* _jsonV3CameraNameKey;
    static const char* _jsonV3CameraOrientationLandscapeKey;
    static const char* _jsonV3FixedValueIsAltitudeKey;
    static const char* _jsonV3Refly90DegreesKey;


    static const int _hoverAndCaptureDelaySeconds = 4;


};

#endif // PARCELLECOMPLEXITEM_H
