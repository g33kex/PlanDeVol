#ifndef PARAMETERSEDITORCONTROLLER_H
#define PARAMETERSEDITORCONTROLLER_H

#include <QObject>
#include <QSettings>
#include <QVariantMap>

#include <QDebug>

class SettingsEditorController : public QObject
{
    Q_OBJECT

public:
    explicit SettingsEditorController();

    enum Orientation {
        landscape,
        portrait
    };
    Q_ENUMS(Orientation)

    Q_INVOKABLE void loadSettings(); //Loads the settings from QSettings
    Q_INVOKABLE void saveSettings(); //Saves the settings in QSettings
    Q_INVOKABLE void resetSettings(); //Erases settings stored in QSettings

    Q_PROPERTY(bool modified READ modified WRITE setModified NOTIFY modifiedChanged)

    //Flight Presets
    Q_PROPERTY(double lowSpeed READ lowSpeed WRITE setLowSpeed NOTIFY lowSpeedChanged)
    Q_PROPERTY(double mediumSpeed READ mediumSpeed WRITE setMediumSpeed NOTIFY mediumSpeedChanged)
    Q_PROPERTY(double highSpeed READ highSpeed WRITE setHighSpeed NOTIFY highSpeedChanged)
    Q_PROPERTY(double lowAltitude READ lowAltitude WRITE setLowAltitude NOTIFY lowAltitudeChanged)
    Q_PROPERTY(double mediumAltitude READ mediumAltitude WRITE setMediumAltitude NOTIFY mediumAltitudeChanged)
    Q_PROPERTY(double highAltitude READ highAltitude WRITE setHighAltitude NOTIFY highAltitudeChanged)
    //Flight Settings
    Q_PROPERTY(double turnaroundDistance READ turnaroundDistance WRITE setTurnaroundDistance NOTIFY turnaroundDistanceChanged)
    Q_PROPERTY(double tolerance READ tolerance WRITE setTolerance NOTIFY toleranceChanged)
    Q_PROPERTY(double maxClimbRate READ maxClimbRate WRITE setMaxClimbRate NOTIFY maxClimbRateChanged)
    Q_PROPERTY(double maxDescentRate READ maxDescentRate WRITE setMaxDescentRate NOTIFY maxDescentRateChanged)
    //Camera Settings
    Q_PROPERTY(double focalLength READ focalLength WRITE setFocalLength NOTIFY focalLengthChanged)
    Q_PROPERTY(double sensorWidth READ sensorWidth WRITE setSensorWidth NOTIFY sensorWidthChanged)
    Q_PROPERTY(double sensorHeight READ sensorHeight WRITE setSensorHeight NOTIFY sensorHeightChanged)
    //Image Settings
    Q_PROPERTY(int imageWidth READ imageWidth WRITE setImageWidth NOTIFY imageWidthChanged)
    Q_PROPERTY(int imageHeight READ imageHeight WRITE setImageHeight NOTIFY imageHeightChanged)
    Q_PROPERTY(Orientation imageOrientation READ imageOrientation WRITE setImageOrientation NOTIFY imageOrientationChanged)
    Q_PROPERTY(int overlap READ overlap WRITE setOverlap NOTIFY overlapChanged)
    //Checklist
    Q_PROPERTY(QString checklist READ checklist WRITE setChecklist NOTIFY checklistChanged)

    double lowSpeed() const { return m_lowSpeed; }

    double mediumSpeed() const { return m_mediumSpeed; }

    double highSpeed() const { return m_highSpeed; }

    double lowAltitude() const { return m_lowAltitude; }

    double mediumAltitude() const { return m_mediumAltitude; }

    double highAltitude() const { return m_highAltitude; }

    double turnaroundDistance() const { return m_turnaroundDistance; }

    double tolerance() const { return m_tolerance; }

    double maxClimbRate() const { return m_maxClimbRate; }

    double maxDescentRate() const { return m_maxDescentRate; }

    double focalLength() const { return m_focalLength; }

    double sensorWidth() const { return m_sensorWidth; }

    double sensorHeight() const { return m_sensorHeight; }

    int imageWidth() const { return m_imageWidth; }

    int imageHeight() const { return m_imageHeight; }

    Orientation imageOrientation() const { return m_imageOrientation; }

    int overlap() const { return m_overlap; }

    QString checklist() const { return m_checklist; }

    bool modified() const { return m_modified; }

public slots:
    void setLowSpeed(double lowSpeed) {
      if (qFuzzyCompare(m_lowSpeed, lowSpeed))
        return;

      m_lowSpeed = lowSpeed;
      setModified(true);
      emit lowSpeedChanged(m_lowSpeed);
    }
    void setMediumSpeed(double mediumSpeed) {
      if (qFuzzyCompare(m_mediumSpeed, mediumSpeed))
        return;

      m_mediumSpeed = mediumSpeed;
      setModified(true);
      emit mediumSpeedChanged(m_mediumSpeed);
    }

    void setHighSpeed(double highSpeed) {
      if (qFuzzyCompare(m_highSpeed, highSpeed))
        return;

      m_highSpeed = highSpeed;
      setModified(true);
      emit highSpeedChanged(m_highSpeed);
    }

    void setLowAltitude(double lowAltitude) {
      if (qFuzzyCompare(m_lowAltitude, lowAltitude))
        return;

      m_lowAltitude = lowAltitude;
      setModified(true);
      emit lowAltitudeChanged(m_lowAltitude);
    }

    void setMediumAltitude(double mediumAltitude) {
      if (qFuzzyCompare(m_mediumAltitude, mediumAltitude))
        return;

      m_mediumAltitude = mediumAltitude;
      setModified(true);
      emit mediumAltitudeChanged(m_mediumAltitude);
    }

    void setHighAltitude(double highAltitude) {
      if (qFuzzyCompare(m_highAltitude, highAltitude))
        return;

      m_highAltitude = highAltitude;
      setModified(true);
      emit highAltitudeChanged(m_highAltitude);
    }

    void setTurnaroundDistance(double turnaroundDistance) {
      if (qFuzzyCompare(m_turnaroundDistance, turnaroundDistance))
        return;

      m_turnaroundDistance = turnaroundDistance;
      setModified(true);
      emit turnaroundDistanceChanged(m_turnaroundDistance);
    }

    void setTolerance(double tolerance) {
      if (qFuzzyCompare(m_tolerance, tolerance))
        return;

      m_tolerance = tolerance;
      setModified(true);
      emit toleranceChanged(m_tolerance);
    }

    void setMaxClimbRate(double maxClimbRate) {
      if (qFuzzyCompare(m_maxClimbRate, maxClimbRate))
        return;

      m_maxClimbRate = maxClimbRate;
      setModified(true);
      emit maxClimbRateChanged(m_maxClimbRate);
    }

    void setMaxDescentRate(double maxDescentRate) {
      if (qFuzzyCompare(m_maxDescentRate, maxDescentRate))
        return;

      m_maxDescentRate = maxDescentRate;
      setModified(true);
      emit maxDescentRateChanged(m_maxDescentRate);
    }

    void setFocalLength(double focalLength) {
      if (qFuzzyCompare(m_focalLength, focalLength))
        return;

      m_focalLength = focalLength;
      setModified(true);
      emit focalLengthChanged(m_focalLength);
    }

    void setSensorWidth(double sensorWidth) {
      if (qFuzzyCompare(m_sensorWidth, sensorWidth))
        return;

      m_sensorWidth = sensorWidth;
      setModified(true);
      emit sensorWidthChanged(m_sensorWidth);
    }

    void setSensorHeight(double sensorHeight) {
      if (qFuzzyCompare(m_sensorHeight, sensorHeight))
        return;

      m_sensorHeight = sensorHeight;
      setModified(true);
      emit sensorHeightChanged(m_sensorHeight);
    }

    void setImageWidth(int imageWidth) {
      if (m_imageWidth == imageWidth)
        return;

      m_imageWidth = imageWidth;
      setModified(true);
      emit imageWidthChanged(m_imageWidth);
    }

    void setImageHeight(int imageHeight) {
      if (m_imageHeight == imageHeight)
        return;

      m_imageHeight = imageHeight;
      setModified(true);
      emit imageHeightChanged(m_imageHeight);
    }

    void setImageOrientation(Orientation imageOrientation) {
      if (m_imageOrientation == imageOrientation)
        return;

      m_imageOrientation = imageOrientation;
      setModified(true);
      emit imageOrientationChanged(m_imageOrientation);
    }

    void setOverlap(int overlap) {
      if (m_overlap == overlap)
        return;

      m_overlap = overlap;
      setModified(true);
      emit overlapChanged(m_overlap);
    }

    void setChecklist(QString checklist)
    {
        if (m_checklist == checklist)
            return;

        m_checklist = checklist;
        setModified(true);
        emit checklistChanged(m_checklist);
    }

    void setModified(bool modified) {
      if (m_modified == modified)
        return;

      m_modified = modified;
      emit modifiedChanged(m_modified);
    }

signals:
    void lowSpeedChanged(double lowSpeed);
    void mediumSpeedChanged(double mediumSpeed);
    void highSpeedChanged(double highSpeed);
    void lowAltitudeChanged(double lowAltitude);
    void mediumAltitudeChanged(double mediumAltitude);
    void highAltitudeChanged(double highAltitude);
    void turnaroundDistanceChanged(double turnaroundDistance);
    void toleranceChanged(double tolerance);
    void maxClimbRateChanged(double maxClimbRate);
    void maxDescentRateChanged(double maxDescentRate);
    void focalLengthChanged(double focalLength);
    void sensorWidthChanged(double sensorWidth);
    void sensorHeightChanged(double sensorHeight);
    void imageWidthChanged(int imageWidth);
    void imageHeightChanged(int imageHeight);
    void imageOrientationChanged(Orientation imageOrientation);
    void overlapChanged(int overlap);
    void checklistChanged(QString checklist);

    void modifiedChanged(bool modified);

private:
    QSettings settings;
    QString settingsGroup = "NewDrone";
    bool m_modified;

    double m_lowSpeed;
    double m_mediumSpeed;
    double m_highSpeed;
    double m_lowAltitude;
    double m_mediumAltitude;
    double m_highAltitude;
    double m_turnaroundDistance;
    double m_tolerance;
    double m_maxClimbRate;
    double m_maxDescentRate;
    double m_focalLength;
    double m_sensorWidth;
    double m_sensorHeight;
    int m_imageWidth;
    int m_imageHeight;
    Orientation m_imageOrientation;
    int m_overlap;
    QString m_checklist;

    const QString key_lowSpeed = "lowSpeed";
    const QString key_mediumSpeed = "mediumSpeed";
    const QString key_highSpeed = "highSpeed";
    const QString key_lowAltitude = "lowAltitude";
    const QString key_mediumAltitude = "mediumAltitude";
    const QString key_highAltitude = "highAltitude";
    const QString key_turnaroundDistance = "turnaroundDistance";
    const QString key_tolerance = "tolerance";
    const QString key_maxClimbRate = "maxClimbRate";
    const QString key_maxDescentRate = "maxDescentRate";
    const QString key_focalLength = "focalLength";
    const QString key_sensorWidth = "sensorWidth";
    const QString key_sensorHeight = "sensorHeight";
    const QString key_imageWidth = "imageWidth";
    const QString key_imageHeight = "imageHeight";
    const QString key_imageOrientation = "imageOrientation";
    const QString key_overlap = "overlap";
    const QString key_checklist = "checklist";
};


#endif // PARAMETERSEDITORCONTROLLER_H
