#ifndef PARAMETERSEDITORCONTROLLER_H
#define PARAMETERSEDITORCONTROLLER_H

#include <QObject>
#include <QVariantMap>

class ParametersEditorController : public QObject
{
    Q_OBJECT

public:
    explicit ParametersEditorController();

    Q_INVOKABLE QVariantMap getFlightParameters();
    Q_INVOKABLE QVariantMap getGeneralCameraParameters();
    Q_INVOKABLE QVariantMap getCameraParameters();

    Q_INVOKABLE void setFlightParameters(QVariantMap parameters);
    Q_INVOKABLE void setGeneralCameraParameters(QVariantMap parameters);
    Q_INVOKABLE void setCameraParameters(QVariantMap parameters);
};

#endif // PARAMETERSEDITORCONTROLLER_H
