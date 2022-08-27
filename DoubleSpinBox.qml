import QtQuick 2.12
import QtQuick.Controls 2.12

SpinBox{
    id: spin
    property int decimals: 2
    property double realValue: value / 100
    editable: true


    validator: DoubleValidator {
        bottom: Math.min(spin.from, spin.to)
        top:  Math.max(spin.from, spin.to)
    }
    textFromValue: function(value, locale) {
        return Number(value / 100).toLocaleString(locale, 'f', spin.decimals)
    }

    valueFromText: function(text, locale) {
        return Number.fromLocaleString(locale, text) * 100
    }


    contentItem: TextInput {
           z: 2
           text: spin.textFromValue(spin.value, spin.locale)

           font: spin.font
           color: "#21be2b"
           selectionColor: "#21be2b"
           selectedTextColor: "#ffffff"
           horizontalAlignment: Qt.AlignHCenter
           verticalAlignment: Qt.AlignVCenter

           readOnly: !spin.editable
           validator: spin.validator
           inputMethodHints: Qt.ImhFormattedNumbersOnly
       }

       up.indicator: Rectangle {
           x: spin.mirrored ? 0 : parent.width - width
           height: parent.height
           implicitWidth: 30
           implicitHeight: 30
           color: spin.up.pressed ? "#e4e4e4" : "#f6f6f6"
           border.color: enabled ? "#21be2b" : "#bdbebf"

           Text {
               text: "+"
               font.pixelSize: spin.font.pixelSize * 2
               color: "#21be2b"
               anchors.fill: parent
               fontSizeMode: Text.Fit
               horizontalAlignment: Text.AlignHCenter
               verticalAlignment: Text.AlignVCenter
           }
       }

       down.indicator: Rectangle {
           x: spin.mirrored ? parent.width - width : 0
           height: parent.height
           implicitWidth: 30
           implicitHeight: 30
           color: spin.down.pressed ? "#e4e4e4" : "#f6f6f6"
           border.color: enabled ? "#21be2b" : "#bdbebf"

           Text {
               text: "-"
               font.pixelSize: spin.font.pixelSize * 2
               color: "#21be2b"
               anchors.fill: parent
               fontSizeMode: Text.Fit
               horizontalAlignment: Text.AlignHCenter
               verticalAlignment: Text.AlignVCenter
           }
       }

       background: Rectangle {
           implicitWidth: 120
           border.color: "#bdbebf"
       }

}
