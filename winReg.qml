import QtQuick 2.9
import QtQuick.Controls 2.2
import QtQuick.Window 2.2
import Qt.labs.calendar 1.0
import QtQuick.Window 2.3



Item {

    Connections{
        target: delegateAcc

        onToQmlRegistr: {

            if (result == "successfully"){
                rgstrWin.visible = ! rgstrWin.visible
            } else if (result == "login exist"){
                textLogRe1.visible = true
            }else{
                textLogRe.visible = true
            }

        }
    }

    Rectangle {
        id: rgstrWin
        x: (main.width - this.width)/2
        y: (main.height - this.height)/2
        width: 600
        height: 400
        color: "#3A3E52"
        visible: false


        TextField {
            id: textFieldlog
            x: 66
            y: 91
            width: 241
            height: 40
            text: qsTr("")
            renderType: Text.NativeRendering
            padding: 4
            placeholderText: "Имя пользователя"
            font.pointSize: 15
            font.pixelSize: 13
            font.capitalization: Font.MixedCase
        }

        TextField {
            id: textFieldpass
            x: 66
            y: 195
            width: 241
            height: 40
            text: qsTr("")
            font.capitalization: Font.MixedCase
            renderType: Text.NativeRendering
            placeholderText: "Пароль"

        }



        Button {
            id: buttonOk
            x: 326
            y: 338
            width: 226
            height: 40
            text: qsTr("OK")
            font.bold: true
            font.pointSize: 22

            contentItem: Text{
                text: buttonOk.text
                color: "white"
                font: buttonOk.font
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignHCenter
            }

            font.family: "Tahoma"
            display: AbstractButton.TextBesideIcon
            checkable: false
            checked: false
            focusPolicy: Qt.NoFocus
            background: Rectangle{
                id: innerRecR
                color: buttonOk.down ? "#585C6F" : "#2481CE"
               }

            onClicked: {
                    //delegateAcc.login(textField.text, textField1.text)
                if (textFieldpass2.text == textFieldpass.text){
                delegateAcc.registr(textFieldlog.text, textFieldpass.text, textFieldEmail.text)
                }else{
                    textPasRe.visible = true
                }
            }

            }





        Text {
            id: textLogRe
            x: 336
            y: 146
            visible: false
            width: 146
            height: 35
            color: "#f63232"
            text: qsTr("Такая почта уже занята")
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter
            font.pixelSize: 12
        }

        Text {
            id: textPasRe
            x: 338
            y: 210
            visible: false
            width: 146
            height: 35
            color: "#e63434"
            text: qsTr("Пароли не совпадают")
            font.pixelSize: 12
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
        }

        TextField {
            id: textFieldpass2
            x: 66
            y: 248
            width: 241
            height: 40
            text: qsTr("")
            renderType: Text.NativeRendering
            placeholderText: "Повторите пароль"
        }

        TextField {
            id: textFieldEmail
            x: 66
            y: 143
            width: 241
            height: 40
            text: qsTr("")
            renderType: Text.NativeRendering
            font.pixelSize: 13
            placeholderText: "email"
            font.pointSize: 15
            font.capitalization: Font.MixedCase
        }

        Text {
            id: textLogRe1
            x: 335
            y: 97
            width: 146
            height: 35
            color: "#f63232"
            text: qsTr("Имя занято")
            font.pixelSize: 12
            visible: false
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
        }

    }

}
