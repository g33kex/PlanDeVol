#include "SettingsEditorController.h"

#include <QDebug>

SettingsEditorController *SettingsEditorController::instance = nullptr;

SettingsEditorController::SettingsEditorController()
{
    this->loadSettings();
}

SettingsEditorController *SettingsEditorController::getInstance() {
    if(instance==nullptr){
        instance = new SettingsEditorController();
    }
    return instance;
}

void SettingsEditorController::loadSettings()
{
    settings.beginGroup(settingsGroup);

    //Flight Presets
    setLowSpeed(settings.value(key_lowSpeed, 15).toDouble());
    setMediumSpeed(settings.value(key_mediumSpeed, 30).toDouble());
    setHighSpeed(settings.value(key_highSpeed, 40).toDouble());
    setLowAltitude(settings.value(key_lowAltitude, 30).toDouble());
    setMediumAltitude(settings.value(key_mediumAltitude, 50).toDouble());
    setHighAltitude(settings.value(key_highAltitude, 100).toDouble());

    //Flight Settings
    setTurnaroundDistance(settings.value(key_turnaroundDistance, 10).toDouble());
    setTolerance(settings.value(key_tolerance, 10).toDouble());
    setMaxClimbRate(settings.value(key_maxClimbRate, 2).toDouble());
    setMaxDescentRate(settings.value(key_maxDescentRate, 2).toDouble());

    //Camera Settings
    setFocalLength(settings.value(key_focalLength, 5.2).toDouble());
    setSensorWidth(settings.value(key_sensorWidth, 6.26).toDouble());
    setSensorHeight(settings.value(key_sensorHeight, 3.56).toDouble());

    //Image Settings
    setImageWidth(settings.value(key_imageWidth, 3864).toInt());
    setImageHeight(settings.value(key_imageHeight, 2196).toInt());
    setImageOrientation(static_cast<Orientation>(settings.value(key_imageOrientation, landscape).toInt()));
    setOverlap(settings.value(key_overlap, 0).toInt());

    //Checklist
    setChecklist(settings.value(key_checklist, "Nothing to report").toString());

    settings.endGroup();

    setModified(false);
}

void SettingsEditorController::saveSettings()
{
    settings.beginGroup(settingsGroup);

    //Flight Presets
    settings.setValue(key_lowSpeed, lowSpeed());
    settings.setValue(key_mediumSpeed, mediumSpeed());
    settings.setValue(key_highSpeed, highSpeed());
    settings.setValue(key_lowAltitude, lowAltitude());
    settings.setValue(key_mediumAltitude, mediumAltitude());
    settings.setValue(key_highAltitude, highAltitude());

    //Flight Settings
    settings.setValue(key_turnaroundDistance, turnaroundDistance());
    settings.setValue(key_tolerance, tolerance());
    settings.setValue(key_maxClimbRate, maxClimbRate());
    settings.setValue(key_maxDescentRate, maxDescentRate());

    //Camera Settings
    settings.setValue(key_focalLength, focalLength());
    settings.setValue(key_sensorWidth, sensorWidth());
    settings.setValue(key_sensorHeight, sensorHeight());

    //Image Settings
    settings.setValue(key_imageWidth, imageWidth());
    settings.setValue(key_imageHeight, imageHeight());
    settings.setValue(key_imageOrientation, static_cast<int>(imageOrientation()));
    settings.setValue(key_overlap, overlap());

    //Checklist
    settings.setValue(key_checklist, checklist());

    settings.endGroup();

    setModified(false);
}


void SettingsEditorController::resetSettings()
{
    settings.remove(settingsGroup);
    loadSettings();
}
