#ifndef PARAMETERSEDITORCONTROLLER_H
#define PARAMETERSEDITORCONTROLLER_H

#include <QObject>
#include <QSettings>
#include <QVariantMap>

class SettingsEditorController : public QObject
{
    Q_OBJECT

public:
    explicit SettingsEditorController();

    /*Properties*/
    Q_PROPERTY(double lowSpeed READ getLowSpeed WRITE setLowSpeed NOTIFY lowSpeedChanged)

    /*Getters*/
    //Flight Presets
    Q_INVOKABLE double getLowSpeed();
    Q_INVOKABLE double getMediumSpeed();
    Q_INVOKABLE double getHighSpeed();

    Q_INVOKABLE double getLowAltitude();
    Q_INVOKABLE double getMediumAltitude();
    Q_INVOKABLE double getHighAltitude();

    //Flight Settings
    Q_INVOKABLE double getTurnaroundDistance();
    Q_INVOKABLE double getTolerance();
    Q_INVOKABLE double getMaxClimbRate();
    Q_INVOKABLE double getMinDescentRate();

    //Camera Settings
    Q_INVOKABLE double getFocalLength();
    Q_INVOKABLE double getSensorWidth();
    Q_INVOKABLE double getSensorHeight();

    //Image Settings
    Q_INVOKABLE int getImageWidth();
    Q_INVOKABLE int getImageHeight();
    Q_INVOKABLE QString getImageOrientation();

    /*Setters*/
    //Flight Presets
    Q_INVOKABLE void setLowSpeed(double value);
    Q_INVOKABLE void setMediumSpeed(double value);
    Q_INVOKABLE void setHighSpeed(double value);

    Q_INVOKABLE void setLowAltitude(double value);
    Q_INVOKABLE void setMediumAltitude(double value);
    Q_INVOKABLE void setHighAltitude(double value);

    //Flight Settings
    Q_INVOKABLE void setTurnaroundDistance(double value);
    Q_INVOKABLE void setTolerance(double value);
    Q_INVOKABLE void setMaxClimbRate(double value);
    Q_INVOKABLE void setMinDescentRate(double value);

    //Camera Settings
    Q_INVOKABLE void setFocalLength(double value);
    Q_INVOKABLE void setSensorWidth(double value);
    Q_INVOKABLE void setSensorHeight(double value);

    //Image Settings
    Q_INVOKABLE void setImageWidth(int value);
    Q_INVOKABLE void setImageHeight(int value);
    Q_INVOKABLE void setImageOrientation(QString value);

signals:
    void lowSpeedChanged();

private:
    QSettings settings;
    QString settingsGroup = "NewDrone";

    double _lowSpeed;
};

#endif // PARAMETERSEDITORCONTROLLER_H
