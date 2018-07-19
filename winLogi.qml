import QtQuick 2.9
import QtQuick.Controls 2.2
import QtQuick.Window 2.2
import Qt.labs.calendar 1.0
import QtQuick.Window 2.3

Item {

    Connections{

        target: delegateAcc

        onToQMLLogin: {

            textLog.visible = false
            textPas.visible = false

            if (result == "successfully"){
                loginWin.visible = ! loginWin.visible
                if (eBayUrl!= "none"){
                    webV.url = eBayUrl
                    ebayAuth.visible = true
                }
                mainView.visible = true
                delegateAcc.getListing()
            } else if (result == "bad login"){
                textLog.visible = true
            }else{
                textPas.visible = true
            }
        }

    }


        Rectangle {
            id: loginWin
            x: (main.width - this.width)/2
            y: (main.height - this.height)/2
            width: 600
            height: 400
            color: "#3A3E52"
            visible: true


            TextField {
                id: textField
                x: 174
                y: 118
                width: 241
                height: 40
                text: qsTr("")
                placeholderText: "Имя пользователя"
                font.pointSize: 15
                font.pixelSize: 13
                font.capitalization: Font.MixedCase
            }

            TextField {
                id: textField1
                x: 174
                y: 192
                width: 241
                height: 40
                text: qsTr("")
                placeholderText: "Пароль"

            }



            Button {
                id: button
                x: 174
                y: 266
                width: 241
                height: 40
                text: qsTr("Login")
                font.bold: true
                font.pointSize: 22

                contentItem: Text{
                    color: "white"
                    text: "Login"
                    font: button.font
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignHCenter
                }

                font.family: "Tahoma"
                display: AbstractButton.TextBesideIcon
                checkable: false
                checked: false
                focusPolicy: Qt.NoFocus
                background: Rectangle{
                    id: innerRec
                    color: button.down ? "#2481CE" : "#2196F3"
                   }

                onClicked: {
                        delegateAcc.login(textField.text, textField1.text)
                }

                }



            Button {
                id: button1
                x: 173
                y: 334
                width: 241
                height: 40
                text: qsTr("Регистрация")
                onClicked: {
                    //loginWin.visible = false
                    //rgstrWin.visible = true
                    rgstrView.visible = true
                }
            }

            Text {
                id: textLog
                x: 420
                y: 121
                visible: false
                width: 146
                height: 35
                color: "#f63232"
                text: qsTr("Неверное имя пользователя")
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
                font.pixelSize: 12
            }

            Text {
                id: textPas
                x: 424
                y: 195
                visible: false
                width: 146
                height: 35
                color: "#e63434"
                text: qsTr("Неверный пароль")
                font.pixelSize: 12
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
            }

            Image {
                id: image
                x: 187
                y: 29
                width: 211
                height: 57
                source: "web/logo.png"
            }



        }

}
