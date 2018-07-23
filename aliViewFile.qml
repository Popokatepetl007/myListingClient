import QtQuick 2.9
import QtQuick.Controls 2.2
import QtQuick.Window 2.2
import Qt.labs.calendar 1.0
import QtQuick.Window 2.3
import QtWebEngine 1.0



Item {



    width: aliView.width
    height: aliView.height

    function test(result){
//       console.log(result)
       var t= "ereer"
       var re = new RegExp('src="', 'g');
       var ret = new RegExp('_50x50.jpg', 'g');
       var wor = result.replace(re, "@")
       wor = wor.replace(ret, "@")
       var frstArr = wor.split('</li>')
       for(var i=0; i< frstArr.length; i++){
//           console.log(frstArr[i].split('@')[1])
//           if (str(frstArr[i].split('@')[1]) !== 'undefined'){
               picArr.push(frstArr[i].split('@')[1])
//           }
       }
       addItemAli.visible = true

    }

    property string titleAli: ""
    property string discription: ""
    property string price: ""
    property var picArr: []
    property string curentURL: ""


    Rectangle{
        id: aliViewInn
        Rectangle{
            id: headerAli
            x: 0
            y: 0
            width: workView.width
            height: 55
            color: "#2481CE"
            z: 2

            Button{
                id: backButton
                x: 20
                anchors.verticalCenter: parent.verticalCenter
                width: 32
                height: 20
                display: AbstractButton.TextOnly

                Rectangle{
                    id: backButadd
                    x: -4
                    y: -5
                    width: 40
                    height: 30
                    color: "#2196F3"
                    radius: 20
                    Text{
                        anchors.verticalCenter: parent.verticalCenter
                        x: 15
                        text: "<"
                        font.pointSize: 14
                        color: "#FEFEFE"
                    }

                    gradient: Gradient {
//                            GradientStop { position: 0 ; color: addItemButton.pressed ? "#2196F3" : "#2196F3" }
                        GradientStop { position: 0 ; color: addItemButton.pressed ? "#3092E3" : "#2196F3" }
                    }

                }

                onClicked: {
                    webAli.goBack()
                }
            }

            Button{
                id: refButton
                x: 65
                anchors.verticalCenter: parent.verticalCenter
                width: 32
                height: 20
                display: AbstractButton.TextOnly

                Rectangle{
                    id: refButadd
                    x: -4
                    y: -5
                    width: 40
                    height: 30
                    color: "#2196F3"
                    radius: 20
                    Text{
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.horizontalCenter: parent.horizontalCenter
                        text: "O"
                        font.pointSize: 20
                        color: "#FEFEFE"
                    }

                    gradient: Gradient {
//                            GradientStop { position: 0 ; color: addItemButton.pressed ? "#2196F3" : "#2196F3" }
                        GradientStop { position: 0 ; color: addItemButton.pressed ? "#3092E3" : "#2196F3" }
                    }

                }

                onClicked: {
                    webAli.reload()
                }
            }

            Button{
                id: fortButton
                x: 110
                anchors.verticalCenter: parent.verticalCenter
                width: 32
                height: 20
                display: AbstractButton.TextOnly

                Rectangle{
                    id: fortButadd
                    x: -4
                    y: -5
                    width: 40
                    height: 30
                    color: "#2196F3"
                    radius: 20
                    Text{
                        anchors.verticalCenter: parent.verticalCenter
                        x: 15
                        text: ">"
                        font.pointSize: 14
                        color: "#FEFEFE"
                    }

                    gradient: Gradient {
//                            GradientStop { position: 0 ; color: addItemButton.pressed ? "#2196F3" : "#2196F3" }
                        GradientStop { position: 0 ; color: addItemButton.pressed ? "#3092E3" : "#2196F3" }
                    }

                }

                onClicked: {
                    webAli.goForward()
                }
            }


        }


        anchors.fill: parent
        WebEngineView{
            id: webAli
            visible: true
            anchors {top: headerAli.bottom; left: parent.left; right: parent.right; bottom: parent.bottom }
            url: "https://www.aliexpress.com/"
            //url: "https://vk.com"

           onLinkHovered: {
//               console.log(hoveredUrl)
//               webAli.url = hoveredUrl
               curentURL = hoveredUrl
               if (curentURL === ""){
                   webArea.z = 0
               }else{
                   webArea.z = 1
               }
           }

           MouseArea{
               id: webArea

               anchors.fill: parent
               onClicked: {
//                   console.log(curentURL)
//                   if(curentURL == ""){
//                       z = 0
//                   }

                   webAli.url = curentURL
               }
           }

            onLoadingChanged: {
                console.log("urlCh")
                var resArr = []
                titleAli = ''
                discription = ''
                price = ''
                picArr= []

                var js = "document.documentElement.outerHTML";
//                            webAli.runJavaScript(js, function(result){console.log(result);})
                js = "document.getElementsByClassName('product-name')[0].innerHTML"
                webAli.runJavaScript(js, function(result){titleAli = result; })

                js = "document.getElementsByClassName('product-property-list')[0].outerHTML"
                webAli.runJavaScript(js, function(result){discription= result; })

                js = "document.getElementById('j-sku-discount-price').innerHTML"
                webAli.runJavaScript(js, function(result){price = result; })

                js = "document.getElementById('j-image-thumb-list').innerHTML;"

                webAli.runJavaScript(js, function(result){ test(result)})
                addItemAli.visible = false
            }
        }

        Rectangle{
            id: addItemAli
            visible: false
            width: 100
            height: 100
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            anchors {rightMargin: 20; bottomMargin: 20}
            color: "#3A3E52"
            radius: 50

            Rectangle{
                id: horPl
                anchors.verticalCenter: addItemAli.verticalCenter
                anchors.horizontalCenter: addItemAli.horizontalCenter
                color: "#2481CE"
                width: 50
                height: 10
            }
            Rectangle{
                anchors.verticalCenter: addItemAli.verticalCenter
                anchors.horizontalCenter: addItemAli.horizontalCenter
                color: "#2481CE"
                width: horPl.height
                height: horPl.width
            }

//            Text{
//                y: 1
//                width: 85
//                height: 89
//                anchors.verticalCenter: parent.verticalCenter
//                anchors.horizontalCenter: parent.horizontalCenter
//                color: "#2481CE"
//                text: "+"
//                verticalAlignment: Text.AlignTop
//                anchors.verticalCenterOffset: -25
//                anchors.horizontalCenterOffset: 1
////                verticalAlignment: Text.AlignTop
//                horizontalAlignment: Text.AlignHCenter
//                font.pointSize: 103
//            }

            MouseArea{
                anchors.fill: parent
                onClicked: {
                    setItemAliToEbay(titleAli, price, discription, picArr, webAli.url)
                }
            }
        }
    }
}
