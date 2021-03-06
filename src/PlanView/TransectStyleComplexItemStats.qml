import QtQuick          2.3
import QtQuick.Controls 1.2

import QGroundControl               1.0
import QGroundControl.ScreenTools   1.0
import QGroundControl.Controls      1.0

// Statistics section for TransectStyleComplexItems
Grid {
    // The following properties must be available up the hierarchy chain
    //property var    missionItem       ///< Mission Item for editor

    anchors.left:   parent.left
    anchors.right:  parent.right
    columns:        2
    columnSpacing:  ScreenTools.defaultFontPixelWidth
    visible:        statsHeader.checked

    QGCLabel { text: qsTr("Survey Area") }
    QGCLabel { text: QGroundControl.squareMetersToAppSettingsAreaUnits(missionItem.coveredArea).toFixed(2) + " " + QGroundControl.appSettingsAreaUnitsString }

    QGCLabel { text: qsTr("Flight Time") }
    QGCLabel { text: missionItem.timeNeedMn + " " + qsTr("mn") + " " + missionItem.timeNeedSec + " " + qsTr("secs")}

    QGCLabel { text: qsTr("Photo Count") }
    QGCLabel { text: missionItem.cameraShots }

    QGCLabel { text: qsTr("Photo Interval") }
    QGCLabel { text: missionItem.timeBetweenShots.toFixed(1) + " " + qsTr("secs") }

    QGCLabel { text: qsTr("Trigger Distance") }
    QGCLabel { text: missionItem.cameraCalc.adjustedFootprintFrontal.valueString + " " + missionItem.cameraCalc.adjustedFootprintFrontal.units }
}
