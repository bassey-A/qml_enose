import QtQuick
import QtCharts
import QtGraphs
import QmlCtrl
import QtQuick.Controls
import QtQuick.Controls.Material
import QtCore

Item {
    //var mpoint = {x: 0, y: 0}
    property point tgs2600Max: Qt.point(0, 0); property point tgs2602Max: Qt.point(0, 0); property point tgs2603Max: Qt.point(0, 0)
    property point tgs2610Max: Qt.point(0, 0); property point tgs2611Max: Qt.point(0, 0); property point tgs2620Max: Qt.point(0, 0)
    property point mq3Max: Qt.point(0, 0); property point mq7Max: Qt.point(0, 0); property point mq135Max: Qt.point(0, 0)
    property int indexVal: 0; property int sideMargin: 70; property int seriesWidth: 2; property bool highlight: false
    property point hoverPoint: Qt.point(0, 0); property real xoom: 1.12
    Connections {
        target: enose
        function onStopped() {
            refreshTimer.running = false
        }
        function onTgs2600Changed(num) {
            if (tgs2600Max.y < num) {
                tgs2600Max = Qt.point(tgs2600.count, num)
            }
            tgs2600.append(tgs2600.count, num)
        }
        function onTgs2602Changed(num) {
            if (tgs2602Max.y < num) {
                tgs2602Max = Qt.point(tgs2602.count, num)
            }
            tgs2602.append(tgs2602.count, num)
        }
        function onTgs2603Changed(num) {
            if (tgs2603Max.y < num) {
                tgs2603Max = Qt.point(tgs2603.count, num)
            }
            tgs2603.append(tgs2603.count, num)
        }
        function onTgs2610Changed(num) {
            if (tgs2610Max.y < num) {
                tgs2610Max = Qt.point(tgs2610.count, num)
            }
            tgs2610.append(tgs2610.count, num)
        }
        function onTgs2611Changed(num) {
            if (tgs2611Max.y < num) {
                tgs2611Max = Qt.point(tgs2611.count, num)
            }
            tgs2611.append(tgs2611.count, num)
        }
        function onTgs2620Changed(num) {
            if (tgs2620Max.y < num) {
                tgs2620Max = Qt.point(tgs2620.count, num)
            }
            tgs2620.append(tgs2620.count, num)
        }
        function onMq3Changed(num) {
            if (mq3Max.y < num) {
                mq3Max = Qt.point(mq3.count, num)
            }
            mq3.append(mq3.count, num)
        }
        function onMq7Changed(num) {
            if (mq7Max.y < num) {
                mq7Max = Qt.point(mq7.count, num)
            }
            mq7.append(mq7.count, num)
        }
        function onMq135Changed(num) {
            if (mq135Max.y < num) {
                mq135Max = Qt.point(mq135.count, num)
            }
            mq135.append(mq135.count, num)
        }
    }

    Timer {
        id: refreshTimer
        interval: 1000
        running: false
        repeat: false
        onTriggered: {    
            //chartView.zoomReset()
            highlight = false
            hoveredOverpt.text = ""
        }
    }

    Rectangle {
        anchors.fill: parent
        radius: 10
        //border.width: 5
        Material.theme: Material.Light
        Material.accent: Material.Green

        Label {
            id: hoveredOver
            text: "hovered over "
            anchors {
                bottom: parent.bottom
                bottomMargin: 50
                left: parent.left
                leftMargin: sideMargin
            }
            font.pointSize: 16
        }
        Label {
            id: hoveredOverpt
            text: ""
            anchors {
                bottom: parent.bottom
                bottomMargin: 50
                left: hoveredOver.right
                leftMargin: 15
            }
            font.pointSize: 16
        }

        Rectangle {
            id: chartBox
            width: parent.width * .60
            height: parent.height - 20

            anchors {
                top: parent.top
                topMargin: 10
                right: parent.right
                rightMargin: 10
            }

            border.color: "black"
            border.width: 5

            PolarChartView {
                title: "Sensor Readings"
                titleFont {
                    pointSize: 25
                    kerning: true
                    family: "Arial"
                }

                //theme: ChartView.ChartThemeBlueCerulean
                localizeNumbers: true
                antialiasing: true
                id: chartView
                animationOptions: ChartView.AllAnimations
                anchors.fill: parent

                ValuesAxis {
                    id: xAxis
                    min: 0
                    max: 1000
                    gridVisible: false
                }
                ValuesAxis {
                    id: yAxis
                    min: 0
                    max: 1025
                    gridVisible: false
                }


                anchors {
                    top: parent.top
                    topMargin: 5
                    left: parent.left
                    leftMargin: 5
                }
                onSeriesAdded: {                    
                    //
                }

                SplineSeries {
                    id: tgs2600
                    capStyle: Qt.FlatCap
                    name: "TGS2600"
                    color: "#CC0000"
                    width: seriesWidth
                    useOpenGL: true
                    onClicked: indexVal = point.x
                    onDoubleClicked: console.log("Dbl clk")
                    onPressed: chartView.zoom(xoom)
                    onHovered: {
                        //chartView.zoom(1.1)
                        refreshTimer.start()
                        hoveredOverpt.text = Math.floor(point.x) + ", " + Math.floor(point.y)
                        if (hovered) {
                            refreshTimer.restart()
                        }
                    }
                    onReleased: chartView.zoomReset()
                }
                SplineSeries {
                    id: tgs2602
                    capStyle: Qt.SquareCap
                    name: "TGS2602"
                    color: "#0000CD"
                    width: seriesWidth
                    useOpenGL: true
                    onClicked: indexVal = point.x
                    onDoubleClicked: console.log("Dbl clk")
                    onPressed: chartView.zoom(xoom)
                    onHovered: {
                        //chartView.zoom(1.1)
                        refreshTimer.start()
                        hoveredOverpt.text = Math.floor(point.x) + ", " + Math.floor(point.y)
                        if (hovered) {
                            refreshTimer.restart()
                        }
                    }
                    onReleased: chartView.zoomReset()
                }
                SplineSeries {
                    id: tgs2603
                    capStyle: Qt.RoundCap
                    name: "TGS2603"
                    color: "#202020"
                    width: seriesWidth
                    useOpenGL: true
                    onClicked: indexVal = point.x
                    onDoubleClicked: console.log("Dbl clk")
                    onPressed: chartView.zoom(xoom)
                    onHovered: {
                        //chartView.zoom(1.1)
                        refreshTimer.start()
                        hoveredOverpt.text = Math.floor(point.x) + ", " + Math.floor(point.y)
                        if (hovered) {
                            refreshTimer.restart()
                        }
                    }
                    onReleased: chartView.zoomReset()
                }
                SplineSeries {
                    id: tgs2610
                    name: "TGS2610"
                    color: "#9932CC"
                    width: seriesWidth
                    useOpenGL: true
                    onClicked: indexVal = point.x
                    onDoubleClicked: console.log("Dbl clk")
                    onPressed: chartView.zoom(xoom)
                    onHovered: {
                        //chartView.zoom(1.1)
                        refreshTimer.start()
                        hoveredOverpt.text = Math.floor(point.x) + ", " + Math.floor(point.y)
                        if (hovered) {
                            refreshTimer.restart()
                        }
                    }
                    onReleased: chartView.zoomReset()
                }
                SplineSeries {
                    id: tgs2611
                    name: "TGS2611"
                    color: "#D2691E"
                    width: seriesWidth
                    useOpenGL: true
                    onClicked: indexVal = point.x
                    onDoubleClicked: console.log("Dbl clk")
                    onPressed: chartView.zoom(xoom)
                    onHovered: {
                        //chartView.zoom(1.1)
                        refreshTimer.start()
                        hoveredOverpt.text = Math.floor(point.x) + ", " + Math.floor(point.y)
                        if (hovered) {
                            refreshTimer.restart()
                        }
                    }
                    onReleased: chartView.zoomReset()
                }
                SplineSeries {
                    id: tgs2620
                    name: "TGS2620"
                    color: "#008000"
                    width: seriesWidth
                    useOpenGL: true
                    onClicked: indexVal = point.x
                    onDoubleClicked: console.log("Dbl clk")
                    onPressed: chartView.zoom(xoom)
                    onHovered: {
                        //chartView.zoom(1.1)
                        refreshTimer.start()
                        hoveredOverpt.text = Math.floor(point.x) + ", " + Math.floor(point.y)
                        if (hovered) {
                            refreshTimer.restart()
                        }
                    }
                    onReleased: chartView.zoomReset()
                }
                SplineSeries {
                    id: mq3
                    name: "MQ3"
                    color: "#FF8C00"
                    width: seriesWidth
                    useOpenGL: true
                    onClicked: indexVal = point.x
                    onDoubleClicked: console.log("Dbl clk")
                    onPressed: chartView.zoom(xoom)
                    onHovered: {
                        //chartView.zoom(1.1)
                        refreshTimer.start()
                        hoveredOverpt.text = Math.floor(point.x) + ", " + Math.floor(point.y)
                        if (hovered) {
                            refreshTimer.restart()
                        }
                    }
                    onReleased: chartView.zoomReset()
                }
                SplineSeries {
                    id: mq7
                    name: "MQ7"
                    color: "#FF00FF"
                    width: seriesWidth
                    useOpenGL: true
                    onClicked: indexVal = point.x
                    onDoubleClicked: console.log("Dbl clk")
                    onPressed: chartView.zoom(xoom)
                    onHovered: {
                        //chartView.zoom(1.1)
                        refreshTimer.start()
                        hoveredOverpt.text = Math.floor(point.x) + ", " + Math.floor(point.y)
                        if (hovered) {
                            refreshTimer.restart()
                        }
                    }
                    onReleased: chartView.zoomReset()
                }
                SplineSeries {
                    id: mq135
                    name: "MQ135"
                    color: "#808080"
                    width: seriesWidth
                    useOpenGL: true
                    onClicked: indexVal = point.x
                    onDoubleClicked: console.log("Dbl clk")
                    onPressed: chartView.zoom(xoom)
                    onHovered: {
                        //chartView.zoom(1.1)
                        refreshTimer.start()
                        hoveredOverpt.text = Math.floor(point.x) + ", " + Math.floor(point.y)
                        if (hovered) {
                            refreshTimer.restart()
                        }
                    }
                    onReleased: chartView.zoomReset()
                }
                Component.onCompleted: {
                    tgs2600.axisX = xAxis
                    tgs2600.axisY = yAxis
                    tgs2602.axisX = xAxis
                    tgs2602.axisY = yAxis
                    tgs2603.axisX = xAxis
                    tgs2603.axisY = yAxis
                    tgs2610.axisX = xAxis
                    tgs2610.axisY = yAxis
                    tgs2611.axisX = xAxis
                    tgs2611.axisY = yAxis
                    tgs2620.axisX = xAxis
                    tgs2620.axisY = yAxis
                    mq3.axisX = xAxis
                    mq3.axisY = yAxis
                    mq7.axisX = xAxis
                    mq7.axisY = yAxis
                    mq135.axisX = xAxis
                    mq135.axisY = yAxis
                }
            }
        }

        Rectangle {
            id: maxValuesBox
            anchors {
                bottom: hoveredOver.top
                bottomMargin: 10
                left: parent.left
            }
            width: parent.width / 7
            height: (parent.height / 2) - 150
            //border.color: "blue"
            Label {
                id: maxValsHeader
                text: "Peak Values"
                anchors {
                    top: parent.top
                    topMargin: 10
                    left: parent.left
                    leftMargin: sideMargin
                }
                font.pointSize: 20
            }
            Label {
                id: tgs2600Peak
                text: "TGS2600 -> (" + tgs2600Max.x + ", " + tgs2600Max.y + ")"
                anchors {
                    top: maxValsHeader.bottom
                    topMargin: 3
                    left: parent.left
                    leftMargin: sideMargin
                }
                font.pointSize: 14
                color: "#CC0000"
            }
            Label {
                id: tgs2602Peak
                text: "TGS2602 -> (" + tgs2602Max.x + ", " + tgs2602Max.y + ")"
                anchors {
                    top: tgs2600Peak.bottom
                    topMargin: 3
                    left: parent.left
                    leftMargin: sideMargin
                }
                font.pointSize: 14
                color: "#0000CD"
            }
            Label {
                id: tgs2603Peak
                text: "TGS2603 -> (" + tgs2603Max.x + ", " + tgs2603Max.y + ")"
                anchors {
                    top: tgs2602Peak.bottom
                    topMargin: 3
                    left: parent.left
                    leftMargin: sideMargin
                }
                font.pointSize: 14
                color: "#202020"
            }
            Label {
                id: tgs2610Peak
                text: "TGS2610 -> (" + tgs2610Max.x + ", " + tgs2610Max.y + ")"
                anchors {
                    top: tgs2603Peak.bottom
                    topMargin: 3
                    left: parent.left
                    leftMargin: sideMargin
                }
                font.pointSize: 14
                color: "#9932CC"
            }
            Label {
                id: tgs2611Peak
                text: "TGS2611 -> (" + tgs2611Max.x + ", " + tgs2611Max.y + ")"
                anchors {
                    top: tgs2610Peak.bottom
                    topMargin: 3
                    left: parent.left
                    leftMargin: sideMargin
                }
                font.pointSize: 14
                color: "#D2691E"
            }
            Label {
                id: tgs2620Peak
                text: "TGS2620 -> (" + tgs2620Max.x + ", " + tgs2620Max.y + ")"
                anchors {
                    top: tgs2611Peak.bottom
                    topMargin: 3
                    left: parent.left
                    leftMargin: sideMargin
                }
                font.pointSize: 14
                color: "#008000"
            }
            Label {
                id: mq3Peak
                text: "MQ3       -> (" + mq3Max.x + ", " + mq3Max.y + ")"
                anchors {
                    top: tgs2620Peak.bottom
                    topMargin: 3
                    left: parent.left
                    leftMargin: sideMargin
                }
                font.pointSize: 14
                color: "#FF8C00"
            }
            Label {
                id: mq7Peak
                text: "MQ7       -> (" + mq7Max.x + ", " + mq7Max.y + ")"
                anchors {
                    top: mq3Peak.bottom
                    topMargin: 3
                    left: parent.left
                    leftMargin: sideMargin
                }
                font.pointSize: 14
                color: "#FF00FF"
            }
            Label {
                id: mq135Peak
                text: "MQ135   -> (" + mq135Max.x + ", " + mq135Max.y + ")"
                anchors {
                    top: mq7Peak.bottom
                    topMargin: 3
                    left: parent.left
                    leftMargin: sideMargin
                }
                font.pointSize: 14
                color: "#808080"
            }
        }
        Rectangle {
            id: indexValuesBox
            anchors {
                bottom: hoveredOver.top
                bottomMargin: 10
                left: maxValuesBox.right
            }
            width: parent.width / 7
            height: (parent.height / 2) - 150
            //border.color: "red"
            Label {
                id: indexValsHeader
                text: "   Index Values"
                anchors {
                    top: parent.top
                    topMargin: 10
                    horizontalCenter: parent.horizontalCenter
                }
                font.pointSize: 20
            }
            Label {
                id: tg2600Index
                text: "TGS2600 -> (" + indexVal + ", " + tgs2600.at(indexVal).y + ")"
                anchors {
                    top: indexValsHeader.bottom
                    topMargin: 3
                    left: parent.left
                    leftMargin: sideMargin
                }
                font.pointSize: 14
                color: "#CC0000"
            }
            Label {
                id: tgs2602Index
                text: "TGS2602 -> (" + indexVal + ", " + tgs2602.at(indexVal).y + ")"
                anchors {
                    top: tg2600Index.bottom
                    topMargin: 3
                    left: parent.left
                    leftMargin: sideMargin
                }
                font.pointSize: 14
                color: "#0000CD"
            }
            Label {
                id: tgs2603Index
                text: "TGS2603 -> (" + indexVal + ", " + tgs2603.at(indexVal).y + ")"
                anchors {
                    top: tgs2602Index.bottom
                    topMargin: 3
                    left: parent.left
                    leftMargin: sideMargin
                }
                font.pointSize: 14
                color: "#202020"
            }
            Label {
                id: tgs2610Index
                text: "TGS2610 -> (" + indexVal + ", " + tgs2610.at(indexVal).y + ")"
                anchors {
                    top: tgs2603Index.bottom
                    topMargin: 3
                    left: parent.left
                    leftMargin: sideMargin
                }
                font.pointSize: 14
                color: "#9932CC"
            }
            Label {
                id: tgs2611Index
                text: "TGS2611 -> (" + indexVal + ", " + tgs2611.at(indexVal).y + ")"
                anchors {
                    top: tgs2610Index.bottom
                    topMargin: 3
                    left: parent.left
                    leftMargin: sideMargin
                }
                font.pointSize: 14
                color: "#D2691E"
            }
            Label {
                id: tgs2620Index
                text: "TGS2620 -> (" + indexVal + ", " + tgs2620.at(indexVal).y + ")"
                anchors {
                    top: tgs2611Index.bottom
                    topMargin: 3
                    left: parent.left
                    leftMargin: sideMargin
                }
                font.pointSize: 14
                color: "#008000"
            }
            Label {
                id: mq3Index
                text: "MQ3       -> (" + indexVal + ", " + mq3.at(indexVal).y + ")"
                anchors {
                    top: tgs2620Index.bottom
                    topMargin: 3
                    left: parent.left
                    leftMargin: sideMargin
                }
                font.pointSize: 14
                color: "#FF8C00"
            }
            Label {
                id: mq7Index
                text: "MQ7       -> (" + indexVal + ", " + mq7.at(indexVal).y + ")"
                anchors {
                    top: mq3Index.bottom
                    topMargin: 3
                    left: parent.left
                    leftMargin: sideMargin
                }
                font.pointSize: 14
                color: "#FF00FF"
            }
            Label {
                id: mq135Index
                text: "MQ135   -> (" + indexVal + ", " + mq135.at(indexVal).y + ")"
                anchors {
                    top: mq7Index.bottom
                    topMargin: 3
                    left: parent.left
                    leftMargin: sideMargin
                }
                font.pointSize: 14
                color: "#808080"
            }
        }

        Rectangle {
            id: infoArea
            width: parent.width * .3
            height: parent.height / 2
            anchors {
                top: parent.top
                topMargin: 10
                left: parent.left
                leftMargin: 10
            }

            Label {
                id: readingInfo
                text: qsTr("Ready")
                font {
                    pointSize: 20
                }
            }

            TextField {
                id: beer
                width: 300
                height: 40
                maximumLength: 50
                color: "black"
                placeholderText: qsTr("beer")
                font.pointSize: 15
                anchors {
                    top: readingInfo.bottom
                    topMargin: 20
                    left: parent.left
                    leftMargin: 15
                }
            }

            TextField {
                id: take
                width: 300
                height: 40
                maximumLength: 50
                placeholderText: qsTr("take")
                font.pointSize: 15
                anchors {
                    top: beer.bottom
                    topMargin: 10
                    left: parent.left
                    leftMargin: 15
                }
                onEditingFinished: enose.setTake(text)
            }

            TextField {
                id: ingredients
                width: 300
                height: 40
                maximumLength: 200
                placeholderText: qsTr("ingredients")
                font.pointSize: 15
                anchors {
                    top: take.bottom
                    topMargin: 10
                    left: parent.left
                    leftMargin: 15
                }
                onEditingFinished: enose.setIngredients(text)
            }

        }

        /*
        MouseArea {
                anchors.fill: parent
                onClicked: {

                }
            }
*/
        Button {
            id: runButton
            //width: 70
            text: qsTr("run")
            anchors {
                bottom: parent.bottom
                bottomMargin: 50
                right: parent.right
                rightMargin: 50
            }
            onClicked: {
                tgs2600.clear()
                tgs2602.clear()
                tgs2603.clear()
                tgs2610.clear()
                tgs2611.clear()
                tgs2620.clear()
                mq3.clear()
                mq7.clear()
                mq135.clear()
                resetMaxValues()
                visible = false
                resetButton.visible = true
                dbWriteButton.visible = true
                //refreshTimer.running = true
                enose.start()
            }
        }

        Button {
            id: resetButton
            text: qsTr("reset")
            anchors {
                bottom: parent.bottom
                bottomMargin: 50
                right: parent.right
                rightMargin: 50
            }
            visible: false
            onClicked: {
                visible = false
                runButton.visible = true
                dbWriteButton.visible = false
                enose.reset()
            }
        }

        Button {
            id: dbWriteButton
            text: qsTr("post")
            anchors {
                bottom: resetButton.top
                bottomMargin: 10
                right: parent.right
                rightMargin: 50
            }
            visible: false
            onClicked: {
                enose.updateDB(beer.text + " ");
                visible = false
                resetButton.visible = false
                runButton.visible = true
            }
        }
    }

    function resetMaxValues() {
        tgs2600Max = tgs2602Max = tgs2603Max = tgs2610Max = Qt.point(0, 0);
        tgs2611Max = tgs2620Max = mq3Max =  mq7Max = mq135Max = Qt.point(0, 0)
    }
}
