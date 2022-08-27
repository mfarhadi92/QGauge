import QtQuick 2.0
import QtQuick.Extras 1.4
import QtQuick.Controls.Styles 1.4
import QtQuick.Controls 1.4
import "struct.js" as HandlerEnums

Item {
    id: root
    property color backgroundColor: "black"
    property double value: 0
    property var config: gauge_sConfig


    function degreesToRadians(degrees) {
        return degrees * (Math.PI / 180);
    }

    function reload() {
        gauge_sConfig.init()
        widget_gauge.visible    = false
        widget_gauge.updateLabelPixSize()
        canvas_bg.requestPaint()
        widget_gauge.update()

        gauge_sConfig.setQMLObjectProperties(lbl_title,lbl_measureUnit,lbl_digitValue,lbl_gaugeCoefficient,itm_labels)
        widget_gauge.visible    = true
    }

    function init() {
        reload()
    }


    ShapeConfig {
        id: gauge_sConfig
        shapeType: HandlerEnums.Type.CIRCULAR_GTYPE
    }


    Canvas {
        id: canvas_bg
        anchors.fill: parent

        function drawDefaultCircle(ctx) {
            ctx.beginPath();
            ctx.lineWidth = 10
            ctx.strokeStyle = "green"
            var clockWise   = widget_gauge.__style.minimumValueAngle > widget_gauge.__style.maximumValueAngle ? true : false
            var startDegree = widget_gauge.__style.valueToAngle(gauge_sConfig.gaugeAnalogFrom*gauge_sConfig.rangeDivider)-90
            var endDegree   = widget_gauge.__style.valueToAngle(gauge_sConfig.gaugeAnalogTo*gauge_sConfig.rangeDivider)-90
            ctx.arc(root.width/2, root.width/2, root.width/2 - ctx.lineWidth / 2,
                    degreesToRadians(startDegree)
                    , degreesToRadians(endDegree),clockWise);

            ctx.stroke();
        }

        onPaint: {
            if( !gauge_sConfig.inited )
                return ;
            var ctx = getContext("2d");
            ctx.reset();
            ctx.beginPath();
            ctx.lineWidth = 0
            ctx.strokeStyle = root.backgroundColor;
            ctx.fillStyle = root.backgroundColor;
            ctx.arc(root.width/2, root.width/2, root.width/2, 0, 2 * Math.PI);
            ctx.fill();

            drawDefaultCircle(ctx)


            var clockWise   = widget_gauge.__style.minimumValueAngle > widget_gauge.__style.maximumValueAngle ? true : false
            var rangeCnt    = gauge_sConfig.rangeCount()
            for( var crIdx = 0 ; crIdx < rangeCnt ; crIdx++ ) {
                ctx.beginPath();
                ctx.lineWidth = 10
                ctx.strokeStyle = gauge_sConfig.getcolorRangeRGB(crIdx===0?gauge_sConfig.gaugeAnalogFrom:gauge_sConfig.rangeIndex(crIdx-1));
                var startDegree = crIdx === 0 ? widget_gauge.__style.valueToAngle(gauge_sConfig.gaugeAnalogFrom*gauge_sConfig.rangeDivider)-90 : widget_gauge.__style.valueToAngle(gauge_sConfig.rangeIndex(crIdx-1)*gauge_sConfig.rangeDivider)-90
                var endDegree   = crIdx === 0 ? widget_gauge.__style.valueToAngle(gauge_sConfig.rangeIndex(crIdx)*gauge_sConfig.rangeDivider)-90 : widget_gauge.__style.valueToAngle(gauge_sConfig.rangeIndex(crIdx)*gauge_sConfig.rangeDivider)-90
                ctx.arc(root.width/2, root.width/2, root.width/2 - ctx.lineWidth / 2,
                        degreesToRadians(startDegree)
                        , degreesToRadians(endDegree),clockWise);

                ctx.stroke();
            }
        }
    }



    CircularGauge {
        id: widget_gauge
        anchors.fill: parent
        anchors.margins: 15
        value: root.value*gauge_sConfig.rangeDivider/gauge_sConfig.gaugeValueCoef
        minimumValue: gauge_sConfig.gaugeAnalogFrom*gauge_sConfig.rangeDivider
        maximumValue: gauge_sConfig.gaugeAnalogTo*gauge_sConfig.rangeDivider
        property double lblPixSize: 4
        onWidthChanged: updateLabelPixSize()
        //        stepSize: 1

        function updateLabelPixSize() {
            if( widget_gauge.width <= 0 || __style.tickmarkCount <= 0 || __style.tickmarkCount === undefined )
            {
                lblPixSize = 4
                return ;
            }

            var perimeter   = Math.PI*2*widget_gauge.width*(Math.abs(__style.angleRange)/360)
            var fSize = perimeter/(__style.tickmarkCount*4.5)
            if( fSize > 20 )
                fSize   = 20;
            else if( fSize <= 4 )
                fSize = 4;
            lblPixSize  = fSize
        }



        style: CircularGaugeStyle {
            id: style_gauge
            minimumValueAngle: gauge_sConfig.gagueCircleFrom
            maximumValueAngle: gauge_sConfig.gagueCircleTo
            minorTickmarkCount: gauge_sConfig.minorTickmarkCount
            //            needle: Rectangle {
            //                y: outerRadius * 0.15
            //                implicitWidth: outerRadius * 0.03
            //                implicitHeight: outerRadius * 0.9
            //                antialiasing: true
            //                color: Qt.rgba(0.66, 0.3, 0, 1)
            //            }


            background: Canvas {
                onPaint: {
                    var ctx = getContext("2d");
                    ctx.reset();
                    //                    ctx.beginPath();
                    //                    ctx.strokeStyle = root.backgroundColor;
                    //                    ctx.fillStyle = root.backgroundColor;
                    //                    ctx.arc(outerRadius, outerRadius, outerRadius, 0, 2 * Math.PI);
                    //                    ctx.fill();
                    //                    ctx.beginPath();
                    //                    ctx.strokeStyle = "#e34c22";
                    //                    ctx.lineWidth = outerRadius * 0.02;

                    //                    ctx.arc(outerRadius, outerRadius, outerRadius - ctx.lineWidth / 2,
                    //                            degreesToRadians(valueToAngle(80) - 90), degreesToRadians(valueToAngle(100) - 90)
                    //                            ,maximumValueAngle>minimumValueAngle?false:true);
                    //                    ctx.stroke();
                }
            }


            tickmark: Rectangle {
                implicitWidth: outerRadius * 0.02
                antialiasing: true
                implicitHeight: outerRadius * 0.06
                onVisibleChanged: color = gauge_sConfig.getcolorRangeRGB(styleData.value/gauge_sConfig.rangeDivider)
                visible: {
                    if( Math.abs(gauge_sConfig.gagueCircleFrom-gauge_sConfig.gagueCircleTo)>= 360 && styleData.value / gauge_sConfig.rangeDivider === gauge_sConfig.gaugeAnalogTo )
                        return false
                    return true
                }
            }

            minorTickmark: Rectangle {
                implicitWidth: outerRadius * 0.01
                antialiasing: true
                implicitHeight: outerRadius * 0.03
                onVisibleChanged: if( visible ) color = gauge_sConfig.getcolorRangeRGB(styleData.value /gauge_sConfig.rangeDivider)
            }

            tickmarkLabel:  Text {
                font.pixelSize: widget_gauge.lblPixSize
                text:  HandlerEnums.fn_roundNumber(styleData.value / gauge_sConfig.rangeDivider)
                visible: {
                    if( Math.abs(gauge_sConfig.gagueCircleFrom-gauge_sConfig.gagueCircleTo)>= 360 && styleData.value / gauge_sConfig.rangeDivider === gauge_sConfig.gaugeAnalogTo )
                        return false
                    if( gauge_sConfig.visibleRangeIndex > 0 )
                        return styleData.index%gauge_sConfig.visibleRangeIndex === 0 ? true : false
                    return true
                }
                onVisibleChanged: color = gauge_sConfig.getcolorRangeRGB(styleData.value/gauge_sConfig.rangeDivider)
                antialiasing: true
            }

            //            foreground: Item {
            //                Rectangle {
            //                    width: outerRadius * 0.2
            //                    height: width
            //                    radius: width / 2
            //                    color: "#e5e5e5"
            //                    anchors.centerIn: parent
            //                }
            //            }
        }

        Behavior on value {
            enabled: gauge_sConfig.barAnimation
            NumberAnimation {
                duration: 1000
            }
        }

        Item {
            id: itm_labels
            anchors.fill: widget_gauge

            Rectangle {
                id: lbl_digitValue
                property int verticalAlignment: 0
                property int horizontalAlignment: 0
                property color textColor: "white"
                property font font
                z: 30


                Text {
                    anchors.fill: parent
                    property double calcValue: root.value/gauge_sConfig.digitValueCoef
                    text: lbl_digitValue.visible ? calcValue.toFixed(gauge_sConfig.digitalDecimalCount) : 0
                    color: parent.textColor
                    font: parent.font
                    anchors.horizontalCenter: parent.horizontalCenter
                    verticalAlignment: parent.verticalAlignment
                    horizontalAlignment: parent.horizontalAlignment
                }

            }

            Rectangle {
                id: lbl_gaugeCoefficient
                property string text
                property int verticalAlignment: 0
                property int horizontalAlignment: 0
                property color textColor: "white"
                property font font
                visible: text.length <= 0 ? false : true


                Text {
                    anchors.fill: parent
                    text: parent.text
                    color: parent.textColor
                    font: parent.font
                    anchors.horizontalCenter: parent.horizontalCenter
                    verticalAlignment: parent.verticalAlignment
                    horizontalAlignment: parent.horizontalAlignment
                }

            }

            Rectangle {
                id: lbl_title
                property string text
                property int verticalAlignment: 0
                property int horizontalAlignment: 0
                property color textColor: "white"
                property font font
                visible: text.length <= 0 ? false : true


                Text {
                    anchors.fill: parent
                    text: parent.text
                    color: parent.textColor
                    font: parent.font
                    anchors.horizontalCenter: parent.horizontalCenter
                    verticalAlignment: parent.verticalAlignment
                    horizontalAlignment: parent.horizontalAlignment
                }
            }

            Rectangle {
                id: lbl_measureUnit
                property string text
                property int verticalAlignment: 0
                property int horizontalAlignment: 0
                property color textColor: "white"
                property font font
                visible: text.length <= 0 ? false : true


                Text {
                    anchors.fill: parent
                    text: parent.text
                    color: parent.textColor
                    font: parent.font
                    anchors.horizontalCenter: parent.horizontalCenter
                    verticalAlignment: parent.verticalAlignment
                    horizontalAlignment: parent.horizontalAlignment
                }

            }
        }
    }
}
