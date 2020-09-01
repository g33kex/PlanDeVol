

/****************************************************************************
 *
 *   (c) 2009-2016 QGROUNDCONTROL PROJECT <http://www.qgroundcontrol.org>
 *
 * QGroundControl is licensed according to the terms in the file
 * COPYING.md in the root of the source code directory.
 *
 ****************************************************************************/
import QtQuick 2.11
import QtQuick.Controls 2.4
import QtQuick.Dialogs 1.3
import QtQuick.Layouts 1.11
import QtQuick.Window 2.11

import QGroundControl 1.0
import QGroundControl.Palette 1.0
import QGroundControl.Controls 1.0
import QGroundControl.ScreenTools 1.0
import QGroundControl.FlightDisplay 1.0
import QGroundControl.FlightMap 1.0

/// Native QML top level window
ApplicationWindow {
    id: loginMainWindow
    minimumWidth: ScreenTools.isMobile ? Screen.width : Math.min(
                                             215 * Screen.pixelDensity,
                                             Screen.width)
    minimumHeight: ScreenTools.isMobile ? Screen.height : Math.min(
                                              120 * Screen.pixelDensity,
                                              Screen.height)
    visible: true

    Loader {
        id: loginLoader
        anchors.fill: parent
        visible: true
        source: "Login.qml"
    }

    function window_on_login() {
        loginMainWindow.hide()
    }

    Component.onCompleted: {
       // if (ScreenTools.isMobile) {
       //    testWindow.showFullScreen()
     //} else {
            width = ScreenTools.isMobile ? Screen.width : Math.min(
                                               250 * Screen.pixelDensity,
                                               Screen.width)
            height = ScreenTools.isMobile ? Screen.height : Math.min(
                                                150 * Screen.pixelDensity,
                                                Screen.height)
        }
    //}*/
}
