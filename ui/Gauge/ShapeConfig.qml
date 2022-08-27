import QtQuick 2.0
import "struct.js" as HandlerEnums
import "styles.js" as Styles

QtObject {
    id: gauge_sConfig2

    property bool inited: false

    property int shapeType: HandlerEnums.Type.CIRCULAR_GTYPE;
    property var titlePropertes;
    property var measureUnitPropertes;
    property var digitValuePropertes;
    property var gaugeCoefPropertes;
    property double digitValueCoef: 1;
    property double gaugeValueCoef: 1;
    property int digitalDecimalCount: 2
    property int style: 0

    property int gagueCircleFrom: -135;
    property int gagueCircleTo: 135;
    property double gaugeAnalogFrom: 0
    property double gaugeAnalogTo: 100
    property int gaugeValueFrom: 0
    property int gaugeValueTo: 1000
    property double gaugeDigitalFrom: 0
    property double gaugeDigitalTo: 100
    property double bigMarkRange: 1
    property double smallMarkRange: 0.5
    property double rangeDivider: 1;
    property int minorTickmarkCount: 0;
    property int mainTickmarkCount: 0;
    property double degreeCoefficient;
    property bool barAnimation: false;
    property var colorRangeRGB;
    property var __colorRangeRGBSortedKeys;


    property int displayHeightRange: 100;
    property int visibleRangeIndex: 1;

    property int colorizedShapeType: HandlerEnums.ColorizeShapeType.CIRCULAR_CSHT;
    property int barWidth: 50

    function init() {
        gaugeValueCoef      = ( Math.abs(gaugeValueFrom-gaugeValueTo) ) / Math.abs(gaugeAnalogFrom-gaugeAnalogTo)
        digitValueCoef      = ( Math.abs(gaugeValueFrom-gaugeValueTo) ) / Math.abs(gaugeDigitalFrom-gaugeDigitalTo)

        if( titlePropertes === undefined )
            titlePropertes = {}
        if( measureUnitPropertes === undefined )
            measureUnitPropertes = {}
        if( digitValuePropertes === undefined )
            digitValuePropertes = {}
        if( gaugeCoefPropertes === undefined )
            gaugeCoefPropertes = {}

        if( shapeType === HandlerEnums.Type.CIRCULAR_GTYPE )
        {
            mainTickmarkCount   = ( Math.abs(gaugeAnalogFrom-gaugeAnalogTo) / bigMarkRange )
            minorTickmarkCount  = (bigMarkRange / smallMarkRange) -1

        }
        else if( shapeType === HandlerEnums.Type.COLORIZE_FILL_GTYPE ) {
            mainTickmarkCount   = ( Math.abs(gaugeAnalogFrom-gaugeAnalogTo) / bigMarkRange ) + 1
            minorTickmarkCount  = (bigMarkRange / smallMarkRange) -1
        }

        __colorRangeRGBSortedKeys  = Object.keys(colorRangeRGB).sort(function(a, b){return a-b})
        rangeDivider    = mainTickmarkCount > 0 && Math.abs(gaugeAnalogFrom-gaugeAnalogTo) > 0 ? (mainTickmarkCount*10)/Math.abs(gaugeAnalogFrom-gaugeAnalogTo) : 1;
        for( var i = 0 ; i < rangeCount() ; i++ ) {
                __colorRangeRGBSortedKeys[i]   = parseInt(__colorRangeRGBSortedKeys[i])
        }
        inited  = true
    }

    function copy(source) {
        if( source === undefined )
            return ;
        digitalDecimalCount = source.digitalDecimalCount
        gaugeValueFrom  = source.gaugeValueFrom
        gaugeValueTo    = source.gaugeValueTo
        gaugeDigitalFrom    = source.gaugeDigitalFrom
        gaugeDigitalTo      = source.gaugeDigitalTo
        gagueCircleFrom  = source.gagueCircleFrom
        gagueCircleTo  = source.gagueCircleTo
        gaugeAnalogFrom  = source.gaugeAnalogFrom
        gaugeAnalogTo  = source.gaugeAnalogTo
        bigMarkRange  = source.bigMarkRange
        smallMarkRange = source.smallMarkRange
        rangeDivider  = source.rangeDivider
        minorTickmarkCount  = source.minorTickmarkCount
        mainTickmarkCount  = source.mainTickmarkCount
        degreeCoefficient  = source.degreeCoefficient
        barAnimation  = source.barAnimation
        colorRangeRGB  = source.colorRangeRGB
        markerDirection  = source.markerDirection
        markerStyle  = source.markerStyle
        displayHeightRange  = source.displayHeightRange
        visibleRangeIndex  = source.visibleRangeIndex
        colorizedShapeType  = source.colorizedShapeType
        barWidth  = source.barWidth
        shapeType       = source.shapeType
        titlePropertes  = source.titlePropertes
        measureUnitPropertes  = source.measureUnitPropertes
        digitValuePropertes  = source.digitValuePropertes
        gaugeCoefPropertes  = source.gaugeCoefPropertes
        digitValueCoef  = source.digitValueCoef
        gaugeValueCoef  = source.gaugeValueCoef
        style  = source.style
    }

    function setQMLObjectProperties(lbl_title,lbl_measureUnit,lbl_digitValue,lbl_gaugeCoef,itm_labels) {
        lbl_title.text          = titlePropertes["text"] === undefined ? "" : titlePropertes["text"]
        lbl_measureUnit.text    = measureUnitPropertes["text"] === undefined ? "" : measureUnitPropertes["text"]
        lbl_gaugeCoef.text      = gaugeCoefPropertes["text"] === undefined ? "" : gaugeCoefPropertes["text"]
        if( style === 1 )
            Styles.style_a1(lbl_title,lbl_measureUnit,lbl_digitValue,lbl_gaugeCoef,itm_labels)
        else if( style === 2 )
            Styles.style_a2(lbl_title,lbl_measureUnit,lbl_digitValue,lbl_gaugeCoef,itm_labels)
        else if( style === 3 )
            Styles.style_a3(lbl_title,lbl_measureUnit,lbl_digitValue,lbl_gaugeCoef,itm_labels)
        else if( style === 4 )
            Styles.style_a4(lbl_title,lbl_measureUnit,lbl_digitValue,lbl_gaugeCoef,itm_labels)
        else if( style === 5 )
            Styles.style_a5(lbl_title,lbl_measureUnit,lbl_digitValue,lbl_gaugeCoef,itm_labels)
        else if( style === 6 )
            Styles.style_a6(lbl_title,lbl_measureUnit,lbl_digitValue,lbl_gaugeCoef,itm_labels)
        if( titlePropertes !== undefined && titlePropertes["visible"] !== undefined ) {
            lbl_title.visible   = titlePropertes["visible"]
        }

        if( measureUnitPropertes !== undefined && measureUnitPropertes["visible"] !== undefined ) {
            lbl_measureUnit.visible   = measureUnitPropertes["visible"]
        }

        if( gaugeCoefPropertes !== undefined && gaugeCoefPropertes["visible"] !== undefined ) {
            lbl_gaugeCoef.visible   = gaugeCoefPropertes["visible"]
        }

        if( digitValuePropertes !== undefined && digitValuePropertes["visible"] !== undefined ) {
            lbl_digitValue.visible   = digitValuePropertes["visible"]
        }
    }

    function getcolorRangeRGB(v) {
        if( !inited )
            return "green";
        if( colorRangeRGB.length === 0 )
            return "green";

        var cSelectedRange = __colorRangeRGBSortedKeys[rangeCount()-1];
        for (var i=0 ; i < rangeCount() ; i++ ) {
            if( __colorRangeRGBSortedKeys[i] > v ) {
                cSelectedRange  = __colorRangeRGBSortedKeys[i];
                break;
            }
        }
        return colorRangeRGB[cSelectedRange]
    }

    function rangeIndex(idx) {
        if( idx >= __colorRangeRGBSortedKeys.length )
            return 0;
        return __colorRangeRGBSortedKeys[idx];
    }

    function rangeCount() {
        if( !inited )
            return 0;
        return __colorRangeRGBSortedKeys.length;
    }
}
