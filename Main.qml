import QtQuick
import QtQuick.Controls
import QmlCtrl

Window {
    width: 1920
    height: 1080//Screen.height
    visible: true
    title: qsTr("eNose v1.0")

    StackView {
        id: stackView
        width: parent.width
        height: parent.height
        initialItem: ("LoginScreen.qml")
    }
}
