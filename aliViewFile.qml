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



        anchors.fill: parent
        WebEngineView{
            id: webAli
            visible: true
            anchors.fill: parent
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
            Text{
                y: 1
                width: 85
                height: 89
                anchors.verticalCenter: parent.verticalCenter
                anchors.horizontalCenter: parent.horizontalCenter
                color: "#2481CE"
                text: "+"
                verticalAlignment: Text.AlignTop
                anchors.verticalCenterOffset: -25
                anchors.horizontalCenterOffset: 1
//                verticalAlignment: Text.AlignTop
                horizontalAlignment: Text.AlignHCenter
                font.pointSize: 103
            }

            MouseArea{
                anchors.fill: parent

                onClicked: {

                    setItemAliToEbay(titleAli, price, discription, picArr, webAli.url)


                }
            }
        }
    }
}
