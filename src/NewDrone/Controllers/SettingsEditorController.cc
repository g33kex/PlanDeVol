#include "SettingsEditorController.h"

#include <QDebug>

SettingsEditorController::SettingsEditorController()
{

}

/*Getters*/
//Flight Presets
double SettingsEditorController::getLowSpeed()
{
   /* settings.beginGroup(settingsGroup);
    double value = settings.value("lowSpeed", 15).toDouble();
    settings.endGroup();
    return value;*/
    return _lowSpeed;
}

double SettingsEditorController::getMediumSpeed()
{
    settings.beginGroup(settingsGroup);
    int value = settings.value("mediumSpeed", 30).toDouble();
    settings.endGroup();
    return value;
}

double SettingsEditorController::getHighSpeed()
{
    settings.beginGroup(settingsGroup);
    double value = settings.value("highSpeed", 40).toDouble();
    settings.endGroup();
    return value;
}

double SettingsEditorController::getLowAltitude()
{
    settings.beginGroup(settingsGroup);
    double value = settings.value("lowAltitude", 30).toDouble();
    settings.endGroup();
    return value;
}

double SettingsEditorController::getMediumAltitude()
{
    settings.beginGroup(settingsGroup);
    double value = settings.value("mediumAltitude", 50).toDouble();
    settings.endGroup();
    return value;
}

double SettingsEditorController::getHighAltitude()
{
    settings.beginGroup(settingsGroup);
    double value = settings.value("highAltitude, 100").toDouble();
    settings.endGroup();
    return value;
}

//Flight Settings
double SettingsEditorController::getTurnaroundDistance()
{
    settings.beginGroup(settingsGroup);
    double value = settings.value("turnaroundDistance", 10).toDouble();
    settings.endGroup();
    return value;
}

double SettingsEditorController::getTolerance()
{
    settings.beginGroup(settingsGroup);
    double value = settings.value("tolerance", 10).toDouble();
    settings.endGroup();
}

double SettingsEditorController::getMaxClimbRate()
{
    settings.beginGroup(settingsGroup);
    double value = settings.value("maxClimbRate", 2).toDouble();
    settings.endGroup();
    return value;
}

double SettingsEditorController::getMinDescentRate()
{
    settings.beginGroup(settingsGroup);
    double value = settings.value("maxDescentRate", 2).toDouble();
    settings.endGroup();
    return value;
}

//Camera Settings
double SettingsEditorController::getFocalLength()
{
    settings.beginGroup(settingsGroup);
    double value = settings.value("focalLength", 5.2).toDouble();
    settings.endGroup();
    return value;
}

double SettingsEditorController::getSensorWidth()
{
    settings.beginGroup(settingsGroup);
    double value = settings.value("sensorWidth", 6.26).toDouble();
    settings.endGroup();
    return value;
}

double SettingsEditorController::getSensorHeight()
{
    settings.beginGroup(settingsGroup);
    double value = settings.value("sensorHeight", 3.56).toDouble();
    settings.endGroup();
    return value;
}

//Image Settings
int SettingsEditorController::getImageWidth()
{
    settings.beginGroup(settingsGroup);
    int value = settings.value("imageWidth", 3864).toInt();
    settings.endGroup();
    return value;
}

int SettingsEditorController::getImageHeight()
{
    settings.beginGroup(settingsGroup);
    int value = settings.value("imageHeight", 2196).toInt();
    settings.endGroup();
    return value;
}

QString SettingsEditorController::getImageOrientation()
{
    settings.beginGroup(settingsGroup);
    QString value = settings.value("imageOrientation", "landscape").toString();
    settings.endGroup();
    return value;
}

/*Setters*/
//Flight Presets
void SettingsEditorController::setLowSpeed(double value)
{
    /*settings.beginGroup(settingsGroup);
    if(settings.value("lowSpeed")!=value) {
        settings.setValue("lowSpeed", value);
        qDebug() << "New Value is " << value;
        emit lowSpeedChanged();
    }
    settings.endGroup();*/
    if(value!=_lowSpeed) {
        _lowSpeed=value;
        emit lowSpeedChanged();
    }
}

void SettingsEditorController::setMediumSpeed(double value)
{
    settings.beginGroup(settingsGroup);

    settings.endGroup();
}

void SettingsEditorController::setHighSpeed(double value)
{
    settings.beginGroup(settingsGroup);

    settings.endGroup();
}

void SettingsEditorController::setLowAltitude(double value)
{
    settings.beginGroup(settingsGroup);

    settings.endGroup();
}

void SettingsEditorController::setMediumAltitude(double value)
{
    settings.beginGroup(settingsGroup);

    settings.endGroup();
}

void SettingsEditorController::setHighAltitude(double value)
{
    settings.beginGroup(settingsGroup);

    settings.endGroup();
}

//Flight Settings
void SettingsEditorController::setTurnaroundDistance(double value)
{
    settings.beginGroup(settingsGroup);

    settings.endGroup();
}

void SettingsEditorController::setTolerance(double value)
{
    settings.beginGroup(settingsGroup);

    settings.endGroup();
}

void SettingsEditorController::setMaxClimbRate(double value)
{
    settings.beginGroup(settingsGroup);

    settings.endGroup();
}

void SettingsEditorController::setMinDescentRate(double value)
{
    settings.beginGroup(settingsGroup);

    settings.endGroup();
}

//Camera Settings
void SettingsEditorController::setFocalLength(double value)
{
    settings.beginGroup(settingsGroup);

    settings.endGroup();
}

void SettingsEditorController::setSensorWidth(double value)
{
    settings.beginGroup(settingsGroup);

    settings.endGroup();
}

void SettingsEditorController::setSensorHeight(double value)
{
    settings.beginGroup(settingsGroup);

    settings.endGroup();
}

//Image Settings
void SettingsEditorController::setImageWidth(int value)
{
    settings.beginGroup(settingsGroup);

    settings.endGroup();
}

void SettingsEditorController::setImageHeight(int value)
{
    settings.beginGroup(settingsGroup);

    settings.endGroup();
}

void SettingsEditorController::setImageOrientation(QString value)
{
    settings.beginGroup(settingsGroup);

    settings.endGroup();
}

