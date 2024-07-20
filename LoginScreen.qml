import QtQuick
import QtQuick.Controls
import QtQuick.Controls.Material
import QmlCtrl

Item {
    id: item
    property bool ready: false
    property bool setup: false

    Connections {
        target: enose
        function onUiLabel(msg) {
            info.text = msg
        }
        function onSignInerror(msg) {
            info.text = msg
        }
        function onSignedUp(msg) {
            info.text = msg
        }
        function onUserSignedIn() {
            ready = true
        }
        function onSetupDone() {
            stackView.push("ReadingsGraph.qml")
        }
    }

    Rectangle {
        id: rectangle
        property alias rectangle: rectangle
        anchors.fill: parent
        color: "white"
        Material.accent: Material.Green

        /*Enose {
            id: enose
            property alias enose: enose
            onUiLabel: msg => {
                           info.text = msg
                       }
            onSignInerror: msg => {
                               info.text = msg
                           }
            onSignedUp: msg => {
                            info.text = msg
                        }
            onUserSignedIn: ready = true
            //onSetupDone: stackView.push("ReadingsGraph.qml")
            onFeedModel: series =>{
                console.log(series)
            }
        }*/

        Image {
            id: beer
            source: "beer.png"
            fillMode: Image.PreserveAspectFit
            anchors {
                horizontalCenter: parent.horizontalCenter
            }
        }

        Image {
            id: hkr_small
            source: "hkr_small.jpeg"
            fillMode: Image.PreserveAspectFit
            anchors {
                left: parent.left
                leftMargin: 10
                top: parent.top
                topMargin: 10
            }
        }

        TextField {
            id: email
            placeholderText: qsTr("email")
            width: 250
            height: 50
            font.pointSize: 14
            maximumLength: 50
            horizontalAlignment: Text.AlignHCenter
            selectedTextColor: "#f9000000"
            selectionColor: "#62e91e"
            anchors {
                bottom: password.top
                bottomMargin: 10
                horizontalCenter: parent.horizontalCenter
            }
            onEditingFinished: enose.setEmail(text)
        }

        TextField {
            id: password
            placeholderText: qsTr("password")
            width: 250
            height: 50
            font.pointSize: 14
            maximumLength: 50
            horizontalAlignment: Text.AlignHCenter
            selectedTextColor: "#f9000000"
            selectionColor: "#62e91e"
            echoMode: TextInput.Password
            anchors {
                bottom: button.top
                bottomMargin: 10
                horizontalCenter: parent.horizontalCenter
            }
            onEditingFinished: enose.setPassword(text)
        }

        Button {
            id: button
            text: qsTr("Sign In")
            anchors {
                bottom: newUser.top
                bottomMargin: 10
                horizontalCenter: parent.horizontalCenter
            }
            onClicked: {
                if (email.text !== "" && password.text !== "") {
                    enose.signInClicked()
                }
            }

            //onClicked: setup = true
        }

        CheckBox {
            id: newUser
            text: qsTr("New User")
            font.pointSize: 14
            anchors {
                bottom: parent.bottom
                bottomMargin: 5
                horizontalCenter: parent.horizontalCenter
            }
            onCheckedChanged: enose.setSignUp(checked ? 1 : 0)
        }

        CheckBox {
            id: dbFetch
            text: qsTr("fetch data")
            font.pointSize: 14
            anchors {
                bottom: parent.bottom
                bottomMargin: 5
                verticalCenter: newUser.verticalCenter
                right: parent.right
                rightMargin: 50
            }
            onCheckedChanged: enose.setGetData(checked ? 1 : 0)
        }

        Label {
            id: info
            text: qsTr("")
            color: "green"
            font.pointSize: 20
            anchors {
                horizontalCenter: parent.horizontalCenter
                bottom: email.top
                bottomMargin: 1
            }
        }

        Rectangle {

        }

        states: [
            State {
                name: "clicked"
                when: newUser.checked

                PropertyChanges {
                    target: button
                    text: qsTr("Sign Up")
                }
            },
            State {
                name: "ready"
                when: ready

                PropertyChanges {
                    target: email
                    visible: false
                }
                PropertyChanges {
                    target: password
                    visible: false
                }
                PropertyChanges {
                    target: newUser
                    visible: false
                }
                PropertyChanges {
                    target: button
                    visible: false
                }
                PropertyChanges {
                    target: password
                    anchors.bottom: newUser.top
                }
            }
        ]
    }
}
