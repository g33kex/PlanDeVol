import QtQuick 2.0
import QtQuick.Controls 2.2
import NewDrone 1.0

Item
{
    id: doublespinbox
    implicitWidth: 180
    implicitHeight: 40
    property int decimals: 2
    property alias value: valuePreview.value
    property real from: 0
    property real to: 99
    property real stepSize: 1
    property alias editable: spinbox.editable
    property alias font: spinbox.font

    SpinBox
    {
        id: spinbox
        property bool init: false
        property real factor: Math.pow(10, decimals)

        function setValue(preview)
        {
            init = true
            value = preview.value * factor
            init = false
            preview.value = value / factor
        }

        DoubleValuePreview
        {
            id: valuePreview
            onValuePreview: spinbox.setValue(preview)
        }

        anchors.fill: parent
        editable: true
        stepSize: doublespinbox.stepSize * factor
        to : doublespinbox.to * factor
        from : doublespinbox.from * factor

        onValueChanged:
        {
            if (init)
                return

            valuePreview.setValueDirect(value / factor)
        }

        validator: DoubleValidator
        {
            bottom: Math.min(spinbox.from, spinbox.to)
            top: Math.max(spinbox.from, spinbox.to)
        }

        textFromValue: function(value, locale)
        {
            return Number(value / factor).toLocaleString(locale, 'f', doublespinbox.decimals)
        }

        valueFromText: function(text, locale)
        {
           // doublespinbox.value = Number.fromLocaleString(locale, text)
            valuePreview.setValueDirect(Number.fromLocaleString(locale, text))
            return doublespinbox.value * factor
        }
    }
}