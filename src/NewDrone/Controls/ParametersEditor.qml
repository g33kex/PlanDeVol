import QtQuick 2.0
import QtQuick 2.0
import QtQuick.Layouts 1.4
import QtQuick 2.1
import QtQuick.Controls 2.4
import QGroundControl 1.0
import QGroundControl.Controllers 1.0
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4

ColumnLayout {

    function save() {

        loginController.setParamSpeed(lowspeed.text, medspeed.text,
                                       highspeed.text)
        loginController.setParamAlt(lowalt.text, medalt.text,
                                     highalt.text)
        loginController.setParamLimit(nbSession.text, nbParcelle.text,
                                       nbMission.text)
        loginController.setParamChecklist(checkListEditor.getCheckList())
        loginController.setParamFlight(turn.text, tol.text,
                                        maxclimb.text, maxdescent.text)
        loginController.setParamCamera(focale.text, sensorW.text,
                                        sensorH.text, imageW.text,
                                        imageH.text, land.currentIndex)
    }

    Label {
        text: "Vitesse"
        color: "gray"
        Layout.margins: m2
    }
    GridLayout {
        columns: 6

        Label {
            text: "Basse"
            Layout.columnSpan: 2
        }
        Label {
            text: "Medium"
            Layout.columnSpan: 2
        }
        Label {
            text: "Rapide"
            Layout.columnSpan: 2
        }

        TextField {
            id: lowspeed
            text: loginController.getSpeedLow()
        }
        Label {
            text: "m/s"
        }
        TextField {
            id: medspeed
            text: loginController.getSpeedMed()
        }
        Label {
            text: "m/s"
        }
        TextField {
            id: highspeed
            text: loginController.getSpeedHigh()
        }
        Label {
            text: "m/s"
        }
    }

    Label {
        text: "Altitude"
        color: "gray"
        Layout.margins: m2
    }
    GridLayout {
        columns: 6

        Label {
            text: "Basse"
            Layout.columnSpan: 2
        }
        Label {
            text: "Medium"
            Layout.columnSpan: 2
        }
        Label {
            text: "Haute"
            Layout.columnSpan: 2
        }

        TextField {
            id: lowalt
            text: loginController.getAltLow()
        }
        Label {
            text: "m"
        }

        TextField {
            id: medalt
            text: loginController.getAltMed()
        }
        Label {
            text: "m"
        }

        TextField {
            id: highalt
            text: loginController.getAltHigh()
        }
        Label {
            text: "m"
        }
    }

    Label {
        text: "Limite de nombre"
        color: "gray"
        Layout.margins: m2
    }

    GridLayout {
        columns: 3

        Label {
            text: "Limite nombre de session"
        }
        Label {
            text: "Limite parcelle / utilisateur"
        }
        Label {
            text: "Limit mission / utilisateur"
        }

        TextField {
            id: nbSession
            text: loginController.getNbSession()
        }
        TextField {
            id: nbParcelle
            text: loginController.getNbParcelle()
        }
        TextField {
            id: nbMission
            text: loginController.getNbMission()
        }
    }

    Label {
        text: "Paramètre de vol"
        color: "gray"
        Layout.margins: m2
    }

    GridLayout {
        columns: 8

        Label {
            text: "Turnaround distance"
            Layout.margins: m2
            Layout.columnSpan: 2
        }
        Label {
            text: "Tolerance"
            Layout.margins: m2
            Layout.columnSpan: 2
        }
        Label {
            text: "Maximum Climb Rate"
            Layout.margins: m2
            Layout.columnSpan: 2
        }
        Label {
            text: "Maximum Descent Rate"
            Layout.margins: m2
            Layout.columnSpan: 2
        }

        TextField {
            id: turn
            text: loginController.getTurn()
        }
        Label {
            text: "m"
            Layout.margins: m2
        }
        TextField {
            id: tol
            text: loginController.getTolerance()
        }
        Label {
            text: "m"
            Layout.margins: m2
        }
        TextField {
            id: maxclimb
            text: loginController.getMaxClimbRate()
        }
        Label {
            text: "m/s"
            Layout.margins: m2
        }
        TextField {
            id: maxdescent
            text: loginController.getMaxDescentRate()
        }
        Label {
            text: "m/s"
            Layout.margins: m2
        }
    }

    Label {
        text: "Paramètre de Caméra-"
        color: "gray"
        Layout.margins: m2
    }

    GridLayout {
        columns: 6

        Label {
            text: "Focale"
            Layout.margins: m2
            Layout.columnSpan: 2
        }
        Label {
            text: "sensor Width"
            Layout.margins: m2
            Layout.columnSpan: 2
        }
        Label {
            text: "Sensor Height"
            Layout.margins: m2
            Layout.columnSpan: 2
        }
        TextField {
            id: focale
            text: loginController.getCameraFocale()
        }
        Label {
            text: "mm"
            Layout.margins: m2
        }
        TextField {
            id: sensorW
            text: loginController.getCameraSensorW()
        }
        Label {
            text: "mm"
            Layout.margins: m2
        }
        TextField {
            id: sensorH
            text: loginController.getCameraSensorH()
        }
        Label {
            text: "mm"
            Layout.margins: m2
        }
        Label {
            text: "Image Width"
            Layout.margins: m2
            Layout.columnSpan: 2
        }
        Label {
            text: "Image Height"
            Layout.margins: m2
            Layout.columnSpan: 2
        }
        Label {
            text: "Orientation"
            Layout.margins: m2
            Layout.columnSpan: 2
        }
        TextField {
            id: imageW
            text: loginController.getCameraImageW()
        }
        Label {
            text: "px"
            Layout.margins: m2
        }
        TextField {
            id: imageH
            text: loginController.getCameraImageH()
        }
        Label {
            text: "px"
            Layout.margins: m2
        }
        ComboBox {
            id: land
            model: ["Portrait", "Paysage"]
            currentIndex: loginController.getCameraLand()
            Layout.columnSpan: 2
        }
    }

    Button {
        text: "exporter en XML"
        Layout.margins: m2
        onClicked: {
            loginController.exportToXML()
            doneDialog.open()
        }
    }

    Button {
        text: "Enregistrer"
        Layout.margins: m2
        onClicked: {
            save()
            doneDialog.open()
        }
    }
}
