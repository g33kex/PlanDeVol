import QtQuick.Layouts 1.4
import QtQuick 2.1
import QtQuick.Controls 2.4
import QGroundControl 1.0
import QGroundControl.Controllers 1.0
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4

Item {


    property var margin: 5
    property var m2: 3

    LoginController {
        id: _loginController
    }

    ParcelleManagerController {
        id: _parcelleManagerController
    }


    Popup {
        id: adminInterface
        width: parent.width
        height: parent.height
        modal: true
        ColumnLayout {
            anchors.fill: parent

            TabBar {
                id: tabBar

                TabButton {
                    height: 40
                    width: 150
                    text: "Utilisateurs"
                    background: Rectangle {
                        color: tabBar.currentIndex == 0 ? "steelblue" : "lightsteelblue"
                        radius: 3
                    }
                }
                TabButton {
                    height: 40
                    width: 150
                    text: "Missions"
                    background: Rectangle {
                        color: tabBar.currentIndex == 1 ? "coral" : "lightcoral"
                        radius: 3
                    }
                }
                TabButton {
                    height: 40
                    width: 150
                    text: "Parcelles"
                    background: Rectangle {
                        color: tabBar.currentIndex == 2 ? "mediumseagreen" : "lightgreen"
                        radius: 3
                    }
                }
				TabButton {
                    height: 40
                    width: 150
                    text: "Questions"
                    background: Rectangle {
                        color: tabBar.currentIndex == 3 ? "orange" : "gold"
                        radius: 3
                    }
                }
                TabButton {
                    height: 40
                    width: 150
                    text: "Paramètres de vol"
                    background: Rectangle {
                        color: tabBar.currentIndex == 4 ? "silver" : "lightgrey"
                        radius: 3
                    }
                }
            }

        StackLayout {
            id : tabV
            currentIndex: tabBar.currentIndex
            Layout.fillWidth: true
            Layout.fillHeight: true

            Item {
                ColumnLayout {
                    anchors.fill: parent
                   Rectangle {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        color: "white"


                        TableView {
                            id: userTableView
                            anchors.fill: parent
                            selectionMode: SelectionMode.MultiSelection
                            TableViewColumn {
                                role: "username"
                                title: "Username"
                                movable: false
                                width: userTableView.width/3
                            }
                            TableViewColumn {
                                role: "nom"
                                title: "Nom"
                                movable : false
                                width: userTableView.width/3
                            }
                            TableViewColumn {
                                role: "prenom"
                                title: "Prenom"
                                movable : false
                                width: userTableView.width/3
                            }

                            SqlCustomModel {
                                id: userModel

                                Component.onCompleted: {
                                    setupForUser()
                                }

                            }

                            model: userModel

                            Dialog {
                                id: addUserDialog
                                modal: true


                                onAccepted: {
                                    if(a_usernameField.length > 0) {
                                        _loginController.addUser(userModel, a_usernameField.text, a_passwordField.text, a_nomField.text, a_prenomField.text)
                                    }
                                }


                                title: "Add User"

                                function reset() {
                                    a_usernameField.text = ""
                                    a_passwordField.text = ""
                                    a_nomField.text = ""
                                    a_prenomField.text = ""
                                }

                                standardButtons: Dialog.Ok | Dialog.Cancel
                                x: (parent.width - width) / 2
                                y: (parent.height - height) / 2

                                GridLayout {
                                    columns: 4
                                    anchors.fill: parent

                                    Label {
                                        text: "Username"
                                    }
                                    Label {
                                        text: "Password"
                                    }
                                    Label {
                                        text: "Nom"
                                    }
                                    Label {
                                        text: "Prenom"

                                    }
                                    TextField {
                                        id: a_usernameField
                                    }
                                    TextField {
                                        id: a_passwordField
                                        echoMode: TextInput.Password
                                    }
                                    TextField {
                                        id: a_nomField
                                    }
                                    TextField {
                                        id: a_prenomField
                                    }
                                }
                            }

                            Dialog {
                                id: editUserDialog

                                property int userIndex: 0

                                function refresh() {
                                    userField.updateContent()
                                    nomField.updateContent()
                                    prenomField.updateContent()
                                }

                                onAccepted: {
                                    _loginController.modifyUser(userModel, userIndex, userField.text, nomField.text, prenomField.text)
                                }


                                title: "Edit Parcelle"

                                standardButtons: Dialog.Ok | Dialog.Cancel
                                x: (parent.width - width) / 2
                                y: (parent.height - height) / 2
                                modal: true

                                GridLayout {
                                    columns: 3
                                    anchors.fill: parent

                                    Label {
                                        text: "username"
                                    }
                                    Label {
                                        text: "nom"
                                    }
                                    Label {
                                        text: "prenom"
                                    }
                                    TextField {
                                        id: userField
                                        enabled: false
                                        function updateContent() {
                                            text=userModel.getRecordValue(editUserDialog.userIndex, "username")
                                        }
                                    }
                                    TextField {
                                        id: nomField
                                        function updateContent() {
                                            text=userModel.getRecordValue(editUserDialog.userIndex, "nom")
                                        }
                                    }
                                    TextField {
                                        id: prenomField
                                        function updateContent() {
                                            text=userModel.getRecordValue(editUserDialog.userIndex, "prenom")
                                        }
                                    }
                                }
                            }

                            Dialog {
                                id: editPassDialog
                                modal: true

                                property int userIndex: 0

                                function refresh() {
                                    userField2.updateContent()
                                }

                                onAccepted: {
                                    if (newPassField.text == confirmationField.text) {
                                        _loginController.modifyPassword(userModel, userIndex, userField2.text, oldPassField.text, newPassField.text)
                                    }
                                    else {
                                        wrongConfirmationDialog.open()
                                    }
                                }


                                title: "Edit Password"

                                standardButtons: Dialog.Ok | Dialog.Cancel
                                x: (parent.width - width) / 2
                                y: (parent.height - height) / 2

                                GridLayout {
                                    columns: 4
                                    anchors.fill: parent

                                    Label {
                                        text: "username"
                                    }
                                    Label {
                                        text: "old password"
                                    }
                                    Label {
                                        text: "new password"
                                    }
                                    Label {
                                        text: "confirmation"
                                    }

                                    TextField {
                                        id: userField2
                                        enabled: false
                                        function updateContent() {
                                            text=userModel.getRecordValue(editPassDialog.userIndex, "username")
                                        }
                                    }
                                    TextField {
                                        id: oldPassField
                                         echoMode: TextInput.Password
                                    }
                                    TextField {
                                        id: newPassField
                                         echoMode: TextInput.Password
                                    }
                                    TextField {
                                        id: confirmationField
                                        echoMode: TextInput.Password
                                    }


                                }


                            }

                        }
                   }
                   RowLayout {
//                       columns: 4
//                       anchors.fill: parent

                       Button {
                           Layout.fillWidth: true
                           Layout.margins : margin
                           text: "Add User"
                           onClicked: {
                               if(_loginController.nbUser()) {
                                   addUserDialog.reset()
                                   addUserDialog.open()
                               }
                               else {
                                   messageDialog_toomuch.open()
                               }
                           }
                       }

                       Button {
                            Layout.fillWidth: true
                            Layout.margins : margin
                            text: "Remove User"
                                onClicked: {
                                        var selected=[]
                                        userTableView.selection.forEach( function(rowIndex) {console.log("Selected : "+rowIndex);selected.push(rowIndex)} )
                                        userTableView.selection.clear()

                                        _loginController.deleteUser(userModel,selected)
                                   }
                        }

                        Button {

                            Layout.margins : margin
                            Layout.fillWidth: true

                            Layout.alignment: Qt.AlignHCenter
                            text: "Modify User"


                                onClicked: {
                                if(userTableView.selection.count===1) {
                                    var sel=0
                                    userTableView.selection.forEach(function(rowIndex) {sel=rowIndex})
                                    editUserDialog.userIndex=sel
                                    editUserDialog.refresh()
                                    editUserDialog.open()
                                }
                                else {
                                    errorModifyOnlyOneDialog.open()
                                }
                            }
                        }

                        Button {

                            Layout.margins : margin
                            Layout.fillWidth: true

                            Layout.alignment: Qt.AlignHCenter
                            text: "Modify Password"


                                onClicked: {
                                if(userTableView.selection.count===1) {
                                    var sel=0
                                    userTableView.selection.forEach(function(rowIndex) {sel=rowIndex})
                                    editPassDialog.userIndex=sel
                                    editPassDialog.refresh()
                                    editPassDialog.open()
                                }
                                else {
                                    errorModifyOnlyOneDialog.open()
                                }
                            }
                        }
                   }
                }
            }
            Item {
                ColumnLayout {
                    anchors.fill: parent
                   Rectangle {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        color: "white"

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
                                title: "Owner"
                                movable: false
                                width: missionTableView.width/2
                            }
                            TableViewColumn {
                                role: "name"
                                title: "name of the mission"
                                movable : false
                                width: missionTableView.width/2
                            }

                            model: missionModel
                        }
                   }


                    Button {
                        Layout.fillWidth: true
                        Layout.margins : margin
                        text: "Remove Mission"
                            onClicked: {
                                    var selected=[]
                                    missionTableView.selection.forEach( function(rowIndex) {console.log("Selected : "+rowIndex);selected.push(rowIndex)} )
                                    missionTableView.selection.clear()

                                    _loginController.deleteMission(missionModel,selected)
                               }
                    }
                }
            }
            Item {
                ColumnLayout {
                    anchors.fill: parent
                   Rectangle {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        color: "white"

                        SqlCustomModel {
                            id: parcelleModel

                            Component.onCompleted: {
                                setupForParcelle()
                            }

                        }

                        TableView {
                            id: parcelleTableView
                            anchors.fill: parent
                            selectionMode: SelectionMode.MultiSelection
                            TableViewColumn {
                                role: "owner"
                                title: "Owner"
                                movable: false
                                width: 2*parcelleTableView.width/5
                            }
                            TableViewColumn {
                                role: "name"
                                title: "name of the parcelle"
                                movable : false
                                width: 2*parcelleTableView.width/5
                            }
                            TableViewColumn {
                                role: "surface"
                                title: "Surface (ha)"
                                movable: false
                                width: parcelleTableView.width/5
                            }

                            model: parcelleModel
                        }
                   }


                    Button {
                        Layout.fillWidth: true
                        Layout.margins : margin
                        text: "Remove Parcelle"
                            onClicked: {
                                    var selected=[]
                                    parcelleTableView.selection.forEach( function(rowIndex) {console.log("Selected : "+rowIndex);selected.push(rowIndex)} )
                                    parcelleTableView.selection.clear()

                                    _parcelleManagerController.deleteParcelle(parcelleModel,selected)
                               }
                    }
                }
            }
			Item {
                property int margin: 6

                ColumnLayout {
                    anchors.fill: parent
                    id: column
                    RowLayout {
                        Layout.fillWidth: true
                        Label {
                            Layout.topMargin: margin
                            Layout.leftMargin: margin
                            Layout.bottomMargin: 0
                            Layout.preferredWidth: column.width/2-2*margin
                            text: "Question"
                        }
                        Label {
                            Layout.topMargin: margin
                            Layout.fillWidth: true
                            text: "Default answer"
                        }
                        Label {
                            text: "Selection"
                            Layout.topMargin: margin
                            Layout.rightMargin: margin
                        }
                    }

                QuestionsView {
                    id: questionView
                    Layout.fillHeight: true
                    Layout.fillWidth: true
                    selectable: true

                    SqlCustomModel {
                        id: parcelleModel2

                        Component.onCompleted: {
                            setupForParcelle()
                        }

                    }

                    Component.onCompleted: {
                        populateQA(parcelleModel2, -1);
                    }
                }

                RowLayout {
                    Layout.alignment: Qt.AlignRight
                    Layout.fillWidth: true
                    Button {
                        text: "Echange"
                        Layout.margins: margin
                        Layout.topMargin: 0
                        onClicked: {
                            if(questionView.getNbChecked() === 2 && questionView.isCheckedValid()) {
                                questionView.exchangeQuestion()
                            }
                            else {
                                tooMuchExDialog.open()
                            }

                        }
                    }
                    Button {
                        text: "+"
                        Layout.margins: margin
                        Layout.topMargin: 0
                        onClicked: {
                            addQuestionDialog.open()
                        }
                    }
                    Button {
                        text: "-"
                        Layout.margins: margin
                        Layout.topMargin: 0
                        onClicked: {
                            if(questionView.getNbChecked() === 1) {
                                questionView.deleteChecked(parcelleModel2)
                                questionView.save(parcelleModel2)
                            }
                            else {
                                tooMuchDelDialog.open()
                            }
                        }
                    }
                    Button {
                        text: "save"
                        Layout.margins: margin
                        Layout.topMargin: 0
                        onClicked: {
                            questionView.save(parcelleModel2)
                            doneDialog.open()
                        }
                    }

                }

                Dialog {
                    id: addQuestionDialog
                    modal: true
                    width: 3 * parent.width / 4
                    height: 3* parent.height / 4

                    onAccepted: {
                        if(questionView.checkIfValid(name_textField.text) && question_textField.length > 0 && name_textField.length > 0) {
                            if(combo_checkbox.checked) {
                                questionView.addQuestionCombo(question_textField.text, possibleChoiceArea.text, parcelleModel2, name_textField.text)
                            }
                            else {
                                questionView.addQuestion(question_textField.text, parcelleModel2, name_textField.text)
                            }
                            questionView.save(parcelleModel2)
                            reset()
                        }
                        else {
                             idExistsDialog.open()
                        }
                    }


                    title: "Add Question"

                    function reset() {
                        possibleChoiceArea.text="";
                        question_textField.text="";
                        name_textField.text="";
                        combo_checkbox.checked = false
                    }

                    standardButtons: Dialog.Ok | Dialog.Cancel
                    x: (parent.width - width) / 2
                    y: (parent.height - height) / 2

                    ColumnLayout {
                        anchors.fill: parent

                        Label {
                            text: "Nom du champ"
                        }
                        TextField {
                            id: name_textField
                            Layout.fillWidth: true
                        }
                        Label {
                            text: "Question"
                        }
                        TextField {
                            id: question_textField
                            Layout.fillWidth: true
                        }
                        CheckBox {
                            text: "Multiple choice question"
                            id: combo_checkbox
                        }
                        TextArea {
                            id: possibleChoiceArea
                            Layout.fillWidth: true
                            Layout.fillHeight: true
                            visible: combo_checkbox.checked
                        }
                    }
                }


                }


            }
            Item {

                ColumnLayout {
                    anchors.fill: parent

                Label {
                    text: "Speed"
                    color: "gray"
                    Layout.margins: m2
                }
                GridLayout {
                    columns: 6

                    Label {
                        text: "Low Speed"
                        Layout.columnSpan: 2
                    }
                    Label {
                        text: "Medium Speed"
                        Layout.columnSpan: 2
                    }
                    Label {
                        text: "High Speed"
                        Layout.columnSpan: 2
                    }


                    TextField {
                        id: lowspeed
                        text: _loginController.getSpeedLow()
                    }
                    Label {
                        text: "m/s"
                    }
                    TextField {
                        id: medspeed
                        text: _loginController.getSpeedMed()
                    }
                    Label {
                        text: "m/s"
                    }
                    TextField {
                        id: highspeed
                        text: _loginController.getSpeedHigh()
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
                        text: "Low Altitude"
                        Layout.columnSpan: 2
                    }
                    Label {
                        text: "Medium Altitude"
                        Layout.columnSpan: 2
                    }
                    Label {
                        text: "High Altitude"
                        Layout.columnSpan: 2
                    }


                    TextField {
                        id: lowalt
                        text: _loginController.getAltLow()
                    }
                    Label {
                        text: "m"
                    }

                    TextField {
                        id: medalt
                        text: _loginController.getAltMed()
                    }
                    Label {
                        text: "m"
                    }

                    TextField {
                        id: highalt
                        text: _loginController.getAltHigh()
                    }
                    Label {
                        text: "m"
                    }
                }

                Label {
                    text: "Limite number"
                    color: "gray"
                    Layout.margins: m2
                }

                GridLayout {
                    columns: 3

                    Label {
                        text: "Limit of session        "
                    }
                    Label {
                        text: "Limit of parcelle / user"
                    }
                    Label {
                        text: "Limit of mission / user "
                    }


                    TextField {
                        id: nbSession
                        text: _loginController.getNbSession()
                    }
                    TextField {
                        id: nbParcelle
                        text: _loginController.getNbParcelle()
                    }
                    TextField {
                        id: nbMission
                        text: _loginController.getNbMission()
                    }
                }

                Label {
                    text: "Limite number"
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
                        text: _loginController.getTurn()
                    }
                    Label {
                        text: "m"
                        Layout.margins: m2
                    }
                    TextField {
                        id: tol
                        text: _loginController.getTolerance()
                    }
                    Label {
                        text: "m"
                        Layout.margins: m2
                    }
                    TextField {
                        id: maxclimb
                        text: _loginController.getMaxClimbRate()
                    }
                    Label {
                        text: "m/s"
                        Layout.margins: m2
                    }
                    TextField {
                        id: maxdescent
                        text: _loginController.getMaxDescentRate()
                    }
                    Label {
                        text: "m/s"
                        Layout.margins: m2
                    }
                }

                Label {
                    text: "Camera Param"
                    color: "gray"
                    Layout.margins: m2
                }

                GridLayout {
                    columns: 2

                    Label {
                        text: "Focale"
                        Layout.margins: m2
                        Layout.columnSpan: 2
                    }
                    TextField {
                        id: focale
                        text: _loginController.getCameraFocale()
                    }
                    Label {
                        text: "mm"
                        Layout.margins: m2
                    }
                }

                Label {
                    text: "Checklist"
                    color: "gray"
                    Layout.margins: m2
                }

                TextArea {
                    id: checklistArea
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    text: _loginController.getParamChecklist()
                    Layout.margins: m2
                }

                Button {
                    text: "export to XML"
                    Layout.margins: m2
                    onClicked: {
                        _loginController.exportToXML()
                        doneDialog.open()
                    }
                }

                Button {
                    text: "Save"
                    Layout.margins: m2
                    onClicked: {
                        _loginController.setParamSpeed(lowspeed.text, medspeed.text, highspeed.text)
                        _loginController.setParamAlt(lowalt.text, medalt.text, highalt.text)
                        _loginController.setParamLimit(nbSession.text, nbParcelle.text, nbMission.text)
                        _loginController.setParamChecklist(checklistArea.text)
                        _loginController.setParamFlight(turn.text, tol.text, maxclimb.text, maxdescent.text)
                        _loginController.setParamCamera(focale.text)
                        doneDialog.open()
                    }
                }
                }
            }

        }
        Button {
            Layout.alignment: Qt.AlignRight
            text: "Disconnect"
            Layout.margins: 5
            style: ButtonStyle {
                   background: Rectangle {
                       implicitWidth: 120
                       implicitHeight: 35
                       border.width: control.activeFocus ? 2 : 1
                       border.color: "pink"
                       radius: 20
                       gradient: Gradient {
                           GradientStop { position: 0 ; color: control.pressed ? "pink" : "red" }
                           GradientStop { position: 1 ; color: control.pressed ? "purple" : "darkred" }
                       }
                   }
               }
            onClicked: {

                //we save the flight param
                _loginController.setParamSpeed(lowspeed.text, medspeed.text, highspeed.text)
                _loginController.setParamAlt(lowalt.text, medalt.text, highalt.text)
                _loginController.setParamLimit(nbSession.text, nbParcelle.text, nbMission.text)
                _loginController.setParamChecklist(checklistArea.text)
                _loginController.setParamFlight(turn.text, tol.text, maxclimb.text, maxdescent.text)
                _loginController.setParamCamera(focale.text)

                //we save the questions
                questionView.save(parcelleModel2)

                adminInterface.close()
                _loginController.onAdminClosed()
            }
        }
        }

    }


    Popup {
        id: progressOverlay

        parent: Overlay.overlay

        closePolicy: Popup.NoAutoClose
        modal: true

        x: Math.round((parent.width - width) / 2)
        y: Math.round((parent.height - height) / 2)
        width: 100
        height: 100

        BusyIndicator {
            anchors.fill: parent
        }

    }

    Rectangle {
        color: "black"
        anchors.fill: parent

    Rectangle {
        color: "white"
        anchors.fill: parent
        anchors.bottomMargin: parent.height/6
        anchors.topMargin: parent.height/6
        anchors.leftMargin: parent.width/3
        anchors.rightMargin: parent.width/3

    ColumnLayout {

        anchors.fill: parent
        anchors.margins: margin

        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: 45
            Layout.alignment: Qt.AlignHCenter
            Layout.rightMargin: 10
            Layout.leftMargin: 10
            color: "pink"
            ColumnLayout {
                anchors.fill: parent
            Label {
                text: "Please Login!"
                color: "white"
                Layout.alignment: Qt.AlignCenter
                font.bold: true

            }
            }

        }

        Image {
            source:"/res/resources/icons/mainlogo.png"
            fillMode: Image.PreserveAspectFit
            Layout.alignment: Qt.AlignHCenter
            Layout.fillWidth:true
        }

        Label {
            text: "Username"
            color: "gray"
            Layout.alignment: Qt.AlignHCenter
            Layout.rightMargin: 20
        }

        TextField {
            id: usernameField
            Layout.alignment: Qt.AlignHCenter

        }

        Label {
            text: "Password"
            color: "gray"
            Layout.alignment: Qt.AlignHCenter
            Layout.rightMargin: 20
        }

        TextField {
            id: passwordField
            Layout.alignment: Qt.AlignHCenter
            echoMode: TextInput.Password
        }

        Button {
            Layout.alignment: Qt.AlignHCenter
            text : "Login"

        onClicked: {
            var username=usernameField.text
            if(_loginController.login(username, passwordField.text))
            {
                if(username==="admin")
                {
                    console.log("ADMIN LOGIN")
                    adminInterface.open()
                }
                else {
                    progressOverlay.open()
                    console.log("Logged in as user "+username)
                    _loginController.loadMainWindow()
                    rootWindowLoader.setSource("")
                    rootWindowLoader.setSource("MainRootWindow.qml")
                    rootWindowLoader.focus=true
                    loginMainWindow.hide()
                }
            }
            else {
                errorLogin.open()
            }
            usernameField.text=""
            passwordField.text=""
        }
    }
    }
    }
    }
    Dialog {
        id: errorLogin
        modal: true
        title: "Error"
        standardButtons: Dialog.Ok
        x: (parent.width - width) / 2
        y: (parent.height - height) / 2

        Label{
            text: "Invalid username or password!"
        }

    }

    Dialog {
        id: wrongConfirmationDialog
        standardButtons: Dialog.Ok
        x: (parent.width - width) / 2
        y: (parent.height - height) / 2
        modal: true
        title: "Error"
        Label{
            text: "New password and confirmation is not the same"
        }

    }

    Loader {
        id:             rootWindowLoader
        asynchronous: true
        anchors.fill:   parent
        visible:        false
        onLoaded: {
            progressOverlay.close()
        }
    }

    Dialog {

        id: errorModifyOnlyOneDialog
        standardButtons: Dialog.Ok
        x: (parent.width - width) / 2
        y: (parent.height - height) / 2
        title: "Error"
        modal: true

        Label{
            text: "Please select ONE line to modify."
        }

    }

    Dialog {

        id: doneDialog
        standardButtons: Dialog.Ok
        x: (parent.width - width) / 2
        y: (parent.height - height) / 2
        title: "Done"
        modal: true

    }

    Dialog {
        id: messageDialog_toomuch
        standardButtons: Dialog.Ok
        x: (parent.width - width) / 2
        y: (parent.height - height) / 2
        modal:true
        title: "Warning"
        Label {
            anchors.centerIn: parent
            text: "Limite de sessions enregistrées atteintes."
        }
    }

    Dialog {
        id: idExistsDialog
        standardButtons: Dialog.Ok
        x: (parent.width - width) / 2
        y: (parent.height - height) / 2
        modal:true
        title: "Error"
        Label {
            anchors.centerIn: parent
            text: "L'identifiant est deja utilisé"
        }
    }

    Dialog {
        id: tooMuchExDialog
        standardButtons: Dialog.Ok
        x: (parent.width - width) / 2
        y: (parent.height - height) / 2
        modal:true
        title: "Error"
        Label {
            anchors.centerIn: parent
            text: "Séléctionner que 2 questions de la même catégorie à échanger"
        }
    }

    Dialog {
        id: tooMuchDelDialog
        standardButtons: Dialog.Ok
        x: (parent.width - width) / 2
        y: (parent.height - height) / 2
        modal:true
        title: "Error"
        Label {
            anchors.centerIn: parent
            text: "Séléctionner qu'une question a supprimer"
        }
    }

}
