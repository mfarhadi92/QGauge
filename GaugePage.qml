import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12
import "ui/Gauge/" as GaugeSymbolModule
import "ui/Gauge/struct.js" as HandlerEnums


Page{
    id: page
    title: "Gauge Symbol"
    background: Rectangle{
        anchors.fill: parent
        color: "#a9a9a9"
    }

    Timer {
        id: timer_animation
        property int currentStep: 0
        interval: 1000/60
        running: false
        repeat: true
        onTriggered: {
            currentStep ++;
            spin_value.value    = spin_value.from+(currentStep*20)%(spin_value.to-spin_value.from)
        }
    }

    RowLayout {
        anchors.fill: parent
        spacing: 0

        ColumnLayout {
            id: settingCategory_box
            Layout.maximumWidth: 250*CMR
            Layout.minimumWidth: 250*CMR
            height: 150*CMR + 60
            clip: true

            TabBar {
                id: bar_gauges
                Layout.fillWidth: true
                height: 40

                currentIndex: 0
                onCurrentIndexChanged: swipe_gauges.currentIndex   = currentIndex

                TabButton {
                    text: qsTr("Circular Gauge")
                }

                TabButton {
                    text: qsTr("Circular Color Gauge")
                }

                TabButton {
                    text: qsTr("Horizontal Color Gauge")
                }

                TabButton {
                    text: qsTr("Vertical Color Gauge")
                }
            }

            SwipeView {
                id: swipe_gauges
                Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                Layout.minimumWidth: 150*CMR
                Layout.maximumWidth: 150*CMR
                clip: true

                Layout.maximumHeight: 150*CMR
                Layout.fillHeight: true
                onCurrentIndexChanged: {
                    bar_gauges.currentIndex = currentIndex
                    spin_value.updateBound()
                }

                GaugeSymbolModule.Gauge {
                    id: qmlwidget_circularGauge
                    Component.onCompleted:  {
                        createComponent(HandlerEnums.Type.CIRCULAR_GTYPE)
                        config.colorRangeRGB        = { '20': "green", '10': "blue", '0': "#e34c22" };
                        config.shapeType         = HandlerEnums.Type.CIRCULAR_GTYPE;
                        config.gagueCircleFrom  = -140;
                        config.gagueCircleTo    = 140;
                        config.gaugeValueFrom   = -200
                        config.gaugeValueTo     = 200
                        config.gaugeAnalogFrom  = -20;
                        config.gaugeAnalogTo    = 20;
                        config.gaugeDigitalFrom = -200
                        config.gaugeDigitalTo   = 200
                        config.digitalDecimalCount  = 1
                        config.bigMarkRange= 2;
                        config.smallMarkRange= 1;
                        config.barAnimation      = false;
                        config.style             = 1
                        config.titlePropertes    = {"text":"Speed"}
                        config.measureUnitPropertes     = {"text":"km/h"}
                        config.gaugeCoefPropertes       = {"text":"10 kmph"}
                        qmlwidget_gauge.init()
                        spin_value.updateBound()
                    }
                }


                GaugeSymbolModule.Gauge {
                    id: qmlwidget_cCircularCFillableGauge
                    Component.onCompleted:  {
                        createComponent(HandlerEnums.Type.COLORIZE_FILL_GTYPE)
                        config.colorRangeRGB        = { '90': "green", '60': "blue", '50': "#e34c22" };
                        config.shapeType         = HandlerEnums.Type.COLORIZE_FILL_GTYPE;
                        config.colorizedShapeType   = HandlerEnums.ColorizeShapeType.CIRCULAR_CSHT
                        config.gagueCircleFrom  = -90;
                        config.gagueCircleTo    = 90;
                        config.gaugeValueFrom   = 0
                        config.gaugeValueTo     = 100
                        config.gaugeAnalogFrom  = 0;
                        config.gaugeAnalogTo    = 90;
                        config.gaugeDigitalFrom = 0
                        config.gaugeDigitalTo   = 90
                        config.digitalDecimalCount  = 2
                        config.bigMarkRange= 30;
                        config.smallMarkRange= 10;
                        config.barAnimation      = false;
                        config.style             = 1
                        config.titlePropertes    = {"text":"Speed"}
                        config.measureUnitPropertes     = {"text":"km/h"}
                        config.gaugeCoefPropertes       = {"text":"10 kmph"}
                        qmlwidget_gauge.init()
                    }
                }

                Rectangle {
                    color: "black"
                    property var qmlwidget_gauge: qmlwidget_cHorizontalCFillableGauge.qmlwidget_gauge
                    property var config: qmlwidget_cHorizontalCFillableGauge.qmlwidget_gauge.config
                    property alias value: qmlwidget_cHorizontalCFillableGauge.value
                    GaugeSymbolModule.Gauge {
                        id: qmlwidget_cHorizontalCFillableGauge
                        width: 370
                        height: 150
                        anchors.horizontalCenter: parent.horizontalCenter
                        anchors.verticalCenter: parent.verticalCenter

                        Component.onCompleted:  {
                            createComponent(HandlerEnums.Type.COLORIZE_FILL_GTYPE)
                            config.colorRangeRGB        = { '100': "green", '80': "yellow", '50': "#e34c22" };
                            config.shapeType            = HandlerEnums.Type.COLORIZE_FILL_GTYPE;
                            config.colorizedShapeType   = HandlerEnums.ColorizeShapeType.HORIZONTAL_CSHT
                            config.gaugeValueFrom   = 0
                            config.gaugeValueTo     = 200
                            config.gaugeAnalogFrom  = 0;
                            config.gaugeAnalogTo    = 100;
                            config.gaugeDigitalFrom = 0
                            config.gaugeDigitalTo   = 100
                            config.digitalDecimalCount  = 2
                            config.displayHeightRange   = 300
                            config.bigMarkRange= 20;
                            config.smallMarkRange= 5;
                            config.barAnimation      = false;
                            config.style             = 4
                            config.titlePropertes    = {"text":"Speed"}
                            config.measureUnitPropertes     = {"text":"km/h"}
                            config.gaugeCoefPropertes       = {"text":"2 kmph"}
                            qmlwidget_gauge.init()
                        }
                    }
                }



                GaugeSymbolModule.Gauge {
                    id: qmlwidget_cVerticalCFillableGauge

                    Component.onCompleted:  {
                        createComponent(HandlerEnums.Type.COLORIZE_FILL_GTYPE)
                        config.colorRangeRGB        = { '100': "green", '80': "yellow", '50': "#e34c22" };
                        config.shapeType            = HandlerEnums.Type.COLORIZE_FILL_GTYPE;
                        config.colorizedShapeType   = HandlerEnums.ColorizeShapeType.VERTICAL_CSHT
                        config.gaugeValueFrom   = 0
                        config.gaugeValueTo     = 200
                        config.gaugeAnalogFrom  = 0;
                        config.gaugeAnalogTo    = 100;
                        config.gaugeDigitalFrom = 0
                        config.gaugeDigitalTo   = 100
                        config.digitalDecimalCount  = 2
                        config.displayHeightRange   = 300
                        config.bigMarkRange     = 20;
                        config.smallMarkRange   = 5;
                        config.barAnimation     = false;
                        config.style            = 3
                        config.titlePropertes   = {"text":"Speed"}
                        config.measureUnitPropertes     = {"text":"km/h"}
                        config.gaugeCoefPropertes       = {"text":"2 kmph"}
                        qmlwidget_gauge.init()
                    }

                }

            }
        }




        GridLayout {
            columns: 2
            id: grid_settings


            Label {
                text: "Value"
                font.pixelSize: 12
                Layout.minimumWidth: 50
            }

            DoubleSpinBox{
                id: spin_value
                stepSize: 100
                Layout.maximumWidth: 120
                value: from
                onRealValueChanged: {
                    if( swipe_gauges.currentItem.qmlwidget_gauge === undefined )
                        return ;
                    swipe_gauges.currentItem.value = realValue
                }

                function updateBound() {
                    if( swipe_gauges.currentItem.config !== undefined ) {
                        spin_value.from         = swipe_gauges.currentItem.config.gaugeValueFrom*100
                        spin_value.to           = swipe_gauges.currentItem.config.gaugeValueTo*100
                    }
                }
            }

            Button {
                text: "Toggle Animation"
                onClicked: timer_animation.running = !timer_animation.running
            }
        }
    }
}
