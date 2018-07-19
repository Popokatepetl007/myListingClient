import QtQuick 2.9
import QtQuick.Controls 2.2
import QtQuick.Window 2.2
import Qt.labs.calendar 1.0
import QtQuick.Window 2.3



Item {
    function ready(){
        if (textFieldEmail.text != "" && textFieldlog!= "" && textFieldpass.text != "" && textFieldpass2.text != ""){
            buttonOk.enabled = true

        } else{
            buttonOk.enabled = false

        }
    }

    Connections{
        target: delegateAcc

        onToQmlRegistr: {

            textLogRe.visible = false
            textLogRe1.visible = false

            if (result == "successfully"){
                rgstrWin.visible = ! rgstrWin.visible
                msgAllOk.show()
            } else if (result == "login exist"){
                textLogRe1.visible = true
            }else{
                textLogRe.visible = true
            }

        }
    }

    Rectangle {
        id: rgstrWin
        x: 0
        y: 0
        width: rgstrView.width
        height: rgstrView.height
        color: "#3A3E52"
        //visible: false


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
            onDisplayTextChanged: {
                ready()
            }

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
            onDisplayTextChanged: {
                ready()
            }

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
            enabled: false
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
                textPasRe.visible = false
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
            onDisplayTextChanged: {
                ready()
            }
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
            onDisplayTextChanged: {
                ready()
            }
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

    Window{
        id: msgAllOk
        width: 400
        height: 110
        maximumHeight: height
        maximumWidth: width
        minimumHeight: height
        minimumWidth: width


        Text{
            text: "На почту отправлена ссыль прочекай"
            x: 73
            y: 20
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
        }
        Button{
            id: bob
            x: 145
            y: 60
            width: 110
            height: 40
            text: qsTr("OK")
            font.bold: true
            font.pointSize: 9

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

                color: bob.down ? "#585C6F" : "#2481CE"
               }

            onClicked: {
               msgAllOk.close()
               rgstrView.close()
            }

        }
    }

}

