import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12

ApplicationWindow {
    id: window
    visible: true
    width: 1200
    height: 1000
    title: qsTr("Gauge Example")


    GaugePage {
        x: 0
        y: 0
        width: parent.width
        height: parent.height
    }
}
