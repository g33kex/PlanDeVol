import QtQuick 2.0
import QGroundControl 1.0
import QtQuick.Controls 1.4

Item {
    property string tableName

    SqlCustomModel {
        id: missionModel

        Component.onCompleted: {
            setupForMission()
        }
    }

    TableView {
        id: missionTableView
        anchors.fill: parent
        selectionMode: SelectionMode.MultiSelection
        TableViewColumn {
            role: "owner"
            title: "Utilisateur"
            movable: false
            width: missionTableView.width / 2
        }
        TableViewColumn {
            role: "name"
            title: "Nom de la Mission"
            movable: false
            width: missionTableView.width / 2
        }

        model: missionModel
    }
}
