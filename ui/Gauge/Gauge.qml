import QtQuick 2.0
import QtQuick.Extras 1.4

Rectangle {
    id:box
    width: 150*cmr
    height: 150*cmr
    clip: true
    color: "black"
    property double cmr: CMR
    property var config
    property double value: 0
    onValueChanged: qmlwidget_gauge.value = value
    property double mScale: 1
    transform: Scale { origin.x: 0; origin.y: 0; xScale: mScale;yScale: mScale;}
    property var qmlwidget_gauge

    function createComponent(typeId) {
        var types   = ["MFCircularGauge.qml","MFColorizeFillGauge.qml"]
        var gComp   = Qt.createComponent(types[typeId]);
        if (gComp.status === Component.Ready) {
            qmlwidget_gauge = gComp.createObject(box,{value:box.value});
            qmlwidget_gauge.anchors.fill = box
            config  = qmlwidget_gauge.config
        }
        else {
            console.log( gComp.errorString() )
            return ;
        }
    }

}
