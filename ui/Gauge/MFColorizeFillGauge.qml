import QtQuick 2.0
import QtQuick.Extras 1.4
import QtQuick.Controls.Styles 1.4
import QtQuick.Controls 1.4
import QtQuick.Shapes 1.12
import QtQuick.Extras 1.4 as EX
import "struct.js" as HandlerEnums

Item {
    id: root
    property color backgroundColor: "black"
    property double value: 0
    property var config: gauge_sConfig

    onValueChanged: {
        canvas_value.requestPaint()
    }

    function reload() {
        gauge_sConfig.init()
        gauge_sConfig.setQMLObjectProperties(lbl_title,lbl_measureUnit,lbl_digitValue,lbl_gaugeCoefficient,itm_labels)
        repeater_num_hGauge.model       = gauge_sConfig.colorizedShapeType === HandlerEnums.ColorizeShapeType.HORIZONTAL_CSHT ? gauge_sConfig.mainTickmarkCount : 0
        repeater_num_vGauge.model       = gauge_sConfig.colorizedShapeType === HandlerEnums.ColorizeShapeType.VERTICAL_CSHT ? gauge_sConfig.mainTickmarkCount: 0
        repeater_num_circularGauge.model= gauge_sConfig.colorizedShapeType === HandlerEnums.ColorizeShapeType.CIRCULAR_CSHT ? gauge_sConfig.mainTickmarkCount: 0
        repeater_circularSmallMark.model= gauge_sConfig.colorizedShapeType === HandlerEnums.ColorizeShapeType.CIRCULAR_CSHT ? gauge_sConfig.minorTickmarkCount*(gauge_sConfig.mainTickmarkCount-1) : 0
        repeater_vSmallMark.model       = gauge_sConfig.colorizedShapeType === HandlerEnums.ColorizeShapeType.VERTICAL_CSHT ? gauge_sConfig.minorTickmarkCount*(gauge_sConfig.mainTickmarkCount-1) : 0
        repeater_hSmallMark.model       = gauge_sConfig.colorizedShapeType === HandlerEnums.ColorizeShapeType.HORIZONTAL_CSHT ? gauge_sConfig.minorTickmarkCount*(gauge_sConfig.mainTickmarkCount-1) : 0
        fixedSize();
        canvas_colorRangeRGB.requestPaint()
        canvas_value.requestPaint()
        repeater_num_hGauge.update()
        repeater_num_circularGauge.update()
        repeater_num_vGauge.update()
    }

    function init() {
        reload()
    }

    function fixedSize() {
        if( gauge_sConfig.colorizedShapeType === HandlerEnums.ColorizeShapeType.CIRCULAR_CSHT ) {
            canvas_colorRangeRGB.anchors.fill      = root
            canvas_colorRangeRGB.anchors.margins   = 30

            marker.width    = canvas_colorRangeRGB.width
            marker.height   = 3
            marker.anchors.horizontalCenter     = canvas_value.horizontalCenter
            marker.anchors.verticalCenter       = canvas_value.verticalCenter
        }
        else if( gauge_sConfig.colorizedShapeType === HandlerEnums.ColorizeShapeType.HORIZONTAL_CSHT ) {
            canvas_colorRangeRGB.width     = gauge_sConfig.displayHeightRange+6
            canvas_colorRangeRGB.height    = gauge_sConfig.barWidth+6
            canvas_colorRangeRGB.anchors.left      = root.left
            canvas_colorRangeRGB.anchors.bottom    = root.bottom
            canvas_colorRangeRGB.anchors.leftMargin= 5
            marker.width    = 20
            marker.height   = marker.width
            marker.anchors.top    = canvas_value.top
            marker.rotation = -90
        }
        else if( gauge_sConfig.colorizedShapeType === HandlerEnums.ColorizeShapeType.VERTICAL_CSHT ) {
            canvas_colorRangeRGB.width     = gauge_sConfig.barWidth+6
            canvas_colorRangeRGB.height    = gauge_sConfig.displayHeightRange+6
            canvas_colorRangeRGB.anchors.verticalCenter    = root.verticalCenter
            canvas_colorRangeRGB.anchors.horizontalCenter  = root.horizontalCenter
            marker.width    = 20
            marker.height   = marker.width
            marker.anchors.right    = canvas_value.right
        }
    }

    function degreesToRadians(degrees) {
        return degrees * (Math.PI / 180);
    }

    ShapeConfig {
        id: gauge_sConfig
        shapeType: HandlerEnums.Type.COLORIZE_FILL_GTYPE
        property int __range: Math.abs(gagueCircleFrom-gagueCircleTo)
        property int __lblRange: Math.abs(gaugeAnalogFrom-gaugeAnalogTo)
        property int __tickDistance: displayHeightRange > 0 && __range > 0 ? displayHeightRange/__range : 10*cmr
        property int __circularDegreeDistance: __lblRange > 0 ? __range/__lblRange : 1

        function valueToAngle(value) {
            var normalised = (value - gaugeAnalogFrom) / (gaugeAnalogTo - gaugeAnalogFrom);
            return (gagueCircleTo - gagueCircleFrom) * normalised + gagueCircleFrom;
        }

        function valueToY(value) {
            var normalised = (value - gaugeAnalogFrom) / (gaugeAnalogTo - gaugeAnalogFrom);
            return displayHeightRange - (displayHeightRange * normalised);
        }
    }


    Canvas {
        id: canvas_colorRangeRGB
        onPaint: {
            var ctx = getContext("2d");
            ctx.reset();

            if( gauge_sConfig.colorizedShapeType === HandlerEnums.ColorizeShapeType.CIRCULAR_CSHT ) {
                ctx.beginPath();
                ctx.lineWidth = 0
                ctx.strokeStyle = root.backgroundColor;
                ctx.fillStyle = root.backgroundColor;
                ctx.arc(width/2, width/2, width/2, 0, 2 * Math.PI);
                ctx.fill();

                var clockWise   = gauge_sConfig.gagueCircleFrom > gauge_sConfig.gagueCircleTo ? true : false


                for( var crIdx = 0 ; crIdx < gauge_sConfig.rangeCount() ; crIdx++ ) {
                    ctx.beginPath();
                    ctx.lineWidth = 10
                    ctx.strokeStyle = gauge_sConfig.getcolorRangeRGB(crIdx===0?gauge_sConfig.gaugeAnalogFrom:gauge_sConfig.rangeIndex(crIdx-1));
                    var startDegree = crIdx === 0 ? gauge_sConfig.valueToAngle(gauge_sConfig.gaugeAnalogFrom)-90 : gauge_sConfig.valueToAngle(gauge_sConfig.rangeIndex(crIdx-1))-90
                    ctx.arc(width/2, width/2, width/2 - ctx.lineWidth / 2,
                            degreesToRadians(startDegree)
                            , degreesToRadians(gauge_sConfig.valueToAngle(gauge_sConfig.rangeIndex(crIdx))-90),clockWise);

                    ctx.stroke();
                }
            }
            else if( gauge_sConfig.colorizedShapeType === HandlerEnums.ColorizeShapeType.HORIZONTAL_CSHT || gauge_sConfig.colorizedShapeType === HandlerEnums.ColorizeShapeType.VERTICAL_CSHT ) {
                ctx.beginPath();
                ctx.lineWidth = 0
                ctx.fillStyle = "black";
                ctx.fillRect(0,0,width-0,height-0);
                ctx.lineWidth = 1
                ctx.strokeStyle = lbl_digitValue.border.color;
                ctx.rect(0,0,width-0,height-0);
                ctx.stroke();
            }
        }
    }

    Canvas {
        id: canvas_value
        anchors.fill: gauge_sConfig.colorizedShapeType === HandlerEnums.ColorizeShapeType.CIRCULAR_CSHT ? root : undefined
        width: {
            if( gauge_sConfig.colorizedShapeType === HandlerEnums.ColorizeShapeType.HORIZONTAL_CSHT )
                return gauge_sConfig.displayHeightRange;
            else if( gauge_sConfig.colorizedShapeType === HandlerEnums.ColorizeShapeType.VERTICAL_CSHT )
                return gauge_sConfig.barWidth;
            return undefined
        }

        height: {
            if( gauge_sConfig.colorizedShapeType === HandlerEnums.ColorizeShapeType.HORIZONTAL_CSHT )
                return gauge_sConfig.barWidth;
            else if( gauge_sConfig.colorizedShapeType === HandlerEnums.ColorizeShapeType.VERTICAL_CSHT )
                return gauge_sConfig.displayHeightRange;
            return undefined
        }
        anchors.horizontalCenter: canvas_colorRangeRGB.horizontalCenter
        anchors.verticalCenter: canvas_colorRangeRGB.verticalCenter
        anchors.margins: gauge_sConfig.colorizedShapeType === HandlerEnums.ColorizeShapeType.CIRCULAR_CSHT ? 43 : 0
        anchors.topMargin: gauge_sConfig.colorizedShapeType !== HandlerEnums.ColorizeShapeType.CIRCULAR_CSHT ? 5 : 43
        anchors.leftMargin: gauge_sConfig.colorizedShapeType !== HandlerEnums.ColorizeShapeType.CIRCULAR_CSHT ? 5 : 43
        onPaint: {
            var ctx = getContext("2d");
            ctx.reset();
            var lastEndVal  = 0;
            let gaugeVal    = root.value/gauge_sConfig.gaugeValueCoef

            if( gauge_sConfig.colorizedShapeType === HandlerEnums.ColorizeShapeType.CIRCULAR_CSHT ) {
                var clockWise   = gauge_sConfig.gagueCircleFrom > gauge_sConfig.gagueCircleTo ? true : false
                marker.rotation = gauge_sConfig.valueToAngle(gaugeVal)-90

                for( var crIdx = 0 ; crIdx < gauge_sConfig.rangeCount() ; crIdx++ ) {
                    let ri  = gauge_sConfig.rangeIndex(crIdx)
                    if( gaugeVal < ri && gaugeVal < lastEndVal  && crIdx > 0  )
                        break;

                    ctx.beginPath();
                    ctx.lineWidth = gauge_sConfig.barWidth
                    ctx.strokeStyle = gauge_sConfig.getcolorRangeRGB(crIdx===0?gauge_sConfig.gaugeAnalogFrom:gauge_sConfig.rangeIndex(crIdx-1));
                    let startDegree = crIdx === 0 ? gauge_sConfig.valueToAngle(gauge_sConfig.gaugeAnalogFrom)-90 : gauge_sConfig.valueToAngle(gauge_sConfig.rangeIndex(crIdx-1))-90
                    let endDegree   = ri < gaugeVal ? gauge_sConfig.valueToAngle(gauge_sConfig.rangeIndex(crIdx))-90 :
                                                      gauge_sConfig.valueToAngle(gaugeVal)-90
                    ctx.arc(canvas_value.width/2, canvas_value.width/2, canvas_value.width/2 - ctx.lineWidth / 2,
                            degreesToRadians(startDegree)
                            , degreesToRadians(endDegree),clockWise);

                    ctx.stroke();
                    lastEndVal  = gauge_sConfig.rangeIndex(crIdx);
                }
            }
            else if( gauge_sConfig.colorizedShapeType === HandlerEnums.ColorizeShapeType.VERTICAL_CSHT ) {
                marker.y =  canvas_value.y + gauge_sConfig.valueToY(gaugeVal)
                for( let crIdx = 0 ; crIdx < gauge_sConfig.rangeCount() ; crIdx++ ) {
                    let ri  = gauge_sConfig.rangeIndex(crIdx)
                    if( gaugeVal < ri && gaugeVal < lastEndVal  && crIdx > 0  )
                        break;

                    ctx.beginPath();
                    ctx.lineWidth   = 0
                    ctx.fillStyle   = gauge_sConfig.getcolorRangeRGB(crIdx===0?gauge_sConfig.gaugeAnalogFrom:gauge_sConfig.rangeIndex(crIdx-1));
                    ctx.strokeStyle = ctx.fillStyle
                    let startPos = crIdx === 0 ? gauge_sConfig.valueToY(gauge_sConfig.gaugeAnalogFrom) : gauge_sConfig.valueToY(gauge_sConfig.rangeIndex(crIdx-1))
                    let endPos   = ri < gaugeVal ? gauge_sConfig.valueToY(gauge_sConfig.rangeIndex(crIdx)) :
                                                   gauge_sConfig.valueToY(gaugeVal)
                    ctx.fillRect(0,endPos,gauge_sConfig.barWidth,startPos-endPos);
                    ctx.stroke();
                    lastEndVal  = gauge_sConfig.rangeIndex(crIdx);
                }
            }
            else if( gauge_sConfig.colorizedShapeType === HandlerEnums.ColorizeShapeType.HORIZONTAL_CSHT ) {
                marker.x =  canvas_value.x + gauge_sConfig.valueToY(gaugeVal)
                for( let crIdx = 0 ; crIdx < gauge_sConfig.rangeCount() ; crIdx++ ) {
                    let ri  = gauge_sConfig.rangeIndex(crIdx)
                    if( gaugeVal < ri && gaugeVal < lastEndVal  && crIdx > 0  )
                        break;

                    ctx.beginPath();
                    ctx.lineWidth   = 0
                    ctx.fillStyle   = gauge_sConfig.getcolorRangeRGB(crIdx===0?gauge_sConfig.gaugeAnalogFrom:gauge_sConfig.rangeIndex(crIdx-1));
                    ctx.strokeStyle = ctx.fillStyle
                    let startPos = crIdx === 0 ? gauge_sConfig.valueToY(gauge_sConfig.gaugeAnalogFrom) : gauge_sConfig.valueToY(gauge_sConfig.rangeIndex(crIdx-1))
                    let endPos   = ri < gaugeVal ? gauge_sConfig.valueToY(gauge_sConfig.rangeIndex(crIdx)) :
                                                   gauge_sConfig.valueToY(gaugeVal)
                    ctx.fillRect(endPos,0,startPos-endPos,gauge_sConfig.barWidth);
                    ctx.stroke();
                    lastEndVal  = gauge_sConfig.rangeIndex(crIdx);
                }
            }
        }
    }

    Item {
        id: itm_num_circularGauge
        anchors.fill: canvas_colorRangeRGB
        anchors.margins: -30
        enabled: visible
        visible: gauge_sConfig.colorizedShapeType === HandlerEnums.ColorizeShapeType.CIRCULAR_CSHT

        Repeater {
            id: repeater_num_circularGauge
            Rectangle {
                width: 10
                height: parent.height
                anchors.horizontalCenter: parent.horizontalCenter
                rotation: gauge_sConfig.gagueCircleFrom+180+gauge_sConfig.__range*index/(gauge_sConfig.mainTickmarkCount-1)
                y: 0
                color: "transparent"

                Rectangle {
                    color: txt_num_circularGauge.color
                    width: 3
                    height: 10
                    anchors.bottom: parent.bottom
                    anchors.bottomMargin: 17
                    anchors.horizontalCenter: parent.horizontalCenter
                    antialiasing: true
                    smooth: true
                }

                Text {
                    id: txt_num_circularGauge
                    anchors.bottom: parent.bottom
                    text: HandlerEnums.fn_roundNumber(gauge_sConfig.gaugeAnalogFrom+index*gauge_sConfig.__lblRange/(gauge_sConfig.mainTickmarkCount-1))
                    color: gauge_sConfig.getcolorRangeRGB(text)
                    verticalAlignment: Text.AlignTop
                    horizontalAlignment: Text.AlignHCenter
                    anchors.horizontalCenter: parent.horizontalCenter
                    rotation: -1*parent.rotation

                }
            }
        }


        Repeater {
            id: repeater_circularSmallMark

            Rectangle {
                property int groupIdx: index/gauge_sConfig.minorTickmarkCount
                property int idxInGroup: index%gauge_sConfig.minorTickmarkCount
                property int value: gauge_sConfig.smallMarkRange*(idxInGroup+1)+groupIdx*gauge_sConfig.bigMarkRange
                width: 10
                height: parent.height
                anchors.horizontalCenter: parent.horizontalCenter
                rotation: gauge_sConfig.valueToAngle(value)+180
                y: 0
                color: "transparent"

                Rectangle {
                    color: gauge_sConfig.getcolorRangeRGB(''+ parent.value )
                    width: 1.5
                    height: 5
                    anchors.bottom: parent.bottom
                    anchors.bottomMargin: 17
                    anchors.horizontalCenter: parent.horizontalCenter
                    antialiasing: true
                    smooth: true
                }
            }
        }

    }


    Item {
        id: itm_num_verticalGauge
        anchors.left: canvas_value.right
        anchors.top: canvas_value.top
        anchors.bottom: canvas_value.bottom
        width: 70
        enabled: visible
        visible: gauge_sConfig.colorizedShapeType === HandlerEnums.ColorizeShapeType.VERTICAL_CSHT

        Rectangle {
            color: "white"
            anchors.left: parent.left
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            width: 1
            anchors.leftMargin: 5
        }

        Repeater {
            id: repeater_num_vGauge

            Item {
                anchors.left: parent.left
                anchors.leftMargin: 8
                height: 20
                y: gauge_sConfig.valueToY(((gauge_sConfig.__lblRange*index)/(gauge_sConfig.mainTickmarkCount-1))+gauge_sConfig.gaugeAnalogFrom)-height

                Rectangle {
                    x: 0
                    y: parent.height
                    width: 8
                    height: 1
                    color: "white"
                }
                Text {
                    x: 11
                    y: parent.height/2
                    text: HandlerEnums.fn_roundNumber(gauge_sConfig.gaugeAnalogFrom+index*gauge_sConfig.__lblRange/(gauge_sConfig.mainTickmarkCount-1))
                    color: "white"
                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: Text.AlignLeft
                    height: parent.height
                }
            }
        }

        Repeater {
            id: repeater_vSmallMark
            Rectangle {
                property int groupIdx: index/gauge_sConfig.minorTickmarkCount
                property int idxInGroup: index%gauge_sConfig.minorTickmarkCount
                property int value: gauge_sConfig.smallMarkRange*(idxInGroup+1)+groupIdx*gauge_sConfig.bigMarkRange
                anchors.left: parent.left
                anchors.leftMargin: 8
                height: 20
                y: gauge_sConfig.valueToY(value)-height
                color: "transparent"

                Rectangle {
                    x: 0
                    y: parent.height
                    width: 5
                    height: 2
                    color: gauge_sConfig.getcolorRangeRGB(''+ parent.value )
                }
            }
        }
    }

    Item {
        id: itm_num_horizontalGauge
        anchors.bottom: canvas_value.top
        anchors.left: canvas_value.left
        anchors.right: canvas_value.right
        height: 70
        enabled: visible
        visible: gauge_sConfig.colorizedShapeType === HandlerEnums.ColorizeShapeType.HORIZONTAL_CSHT



        Rectangle {
            color: "white"
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            height: 1
            anchors.bottomMargin: 5
        }

        Repeater {
            id: repeater_num_hGauge

            Item {
                anchors.bottom: parent.bottom
                anchors.bottomMargin: 8
                height: 20
                width: height
                x: gauge_sConfig.valueToY(((gauge_sConfig.__lblRange*index)/(gauge_sConfig.mainTickmarkCount-1))+gauge_sConfig.gaugeAnalogFrom)-width/2

                Rectangle {
                    x: parent.width/2
                    anchors.bottom: parent.bottom
                    width: 1
                    height: 8
                    color: "white"
                }
                Text {
                    anchors.bottom: parent.bottom
                    anchors.bottomMargin: 10
                    text: HandlerEnums.fn_roundNumber(gauge_sConfig.gaugeAnalogFrom+index*gauge_sConfig.__lblRange/(gauge_sConfig.mainTickmarkCount-1))
                    color: "white"
                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: Text.AlignHCenter
                    height: parent.height
                    width: 10
                    anchors.horizontalCenter: parent.horizontalCenter
                }
            }
        }

        Repeater {
            id: repeater_hSmallMark
            Rectangle {
                property int groupIdx: index/gauge_sConfig.minorTickmarkCount
                property int idxInGroup: index%gauge_sConfig.minorTickmarkCount
                property int value: gauge_sConfig.smallMarkRange*(idxInGroup+1)+groupIdx*gauge_sConfig.bigMarkRange
                anchors.bottom: parent.bottom
                anchors.bottomMargin: 8
                height: 20
                width: height
                x: gauge_sConfig.valueToY(value)-width/2
                color: "transparent"

                Rectangle {
                    x: parent.width/2
                    anchors.bottom: parent.bottom
                    width: 2
                    height: 5
                    color: gauge_sConfig.getcolorRangeRGB(''+ parent.value )
                }
            }
        }
    }


    Item {
        id: itm_labels
        anchors.fill: canvas_colorRangeRGB

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

    Item {
        id: marker

        Rectangle {
            color: "white"
            anchors.right: parent.right
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            width: gauge_sConfig.barWidth+40
            antialiasing: true
            smooth: true
            visible: gauge_sConfig.colorizedShapeType === HandlerEnums.ColorizeShapeType.CIRCULAR_CSHT ? true : false
        }

        Shape {
            id: shape_marker
            visible: gauge_sConfig.colorizedShapeType === HandlerEnums.ColorizeShapeType.CIRCULAR_CSHT ? false : true
            antialiasing: true
            smooth: true
            width: 20
            height: 20
            rotation: 90

            ShapePath {
                id: path_marker

                strokeWidth: 1
                strokeColor: "white"
                strokeStyle: ShapePath.SolidLine
                fillColor: "white"

                property var startPoint: Qt.point(0,0)
                startX: startPoint.x
                startY: startPoint.y
                PathLine{x:path_marker.startPoint.x+cmr*2.5;y:path_marker.startPoint.y+5*cmr}
                PathLine{x:path_marker.startPoint.x-cmr*2.5;y:path_marker.startPoint.y+5*cmr}
                PathLine{x:path_marker.startPoint.x;y:path_marker.startPoint.y}
            }
        }


    }
}
