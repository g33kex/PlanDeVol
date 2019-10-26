import QtQuick 2.0

Column{

    function show(text, duration){
        var toast = toastComponent.createObject(root);
        toast.selfDestroying = true;
        toast.show(text, duration);
    }

    id: root

    z: Infinity
    spacing: 5
    anchors.centerIn: parent

    property var toastComponent

    Component.onCompleted: toastComponent = Qt.createComponent("Toast.qml")
}
