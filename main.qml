import QtQuick 2.9
import QtQuick.Controls 2.2
import QtQuick.Window 2.2
import Qt.labs.calendar 1.0
import QtQuick.Window 2.3
import QtWebEngine 1.0



ApplicationWindow {

    property var listCategoty: []


    function setItemAliToEbay(title, price, discript, photoArr, aliUrl){

//        console.log(title)
//        console.log(price)
//        console.log(photoArr)
//        titleField.text = title
        delegateAcc.getCategorys()
        addItemeBay.show()

        main.sendToAdd(title, discript, price, photoArr, aliUrl)


    }


    function createJSArr(listArr, obd){
        var ld = []
        console.log("statr obd")
        for (var i=0; i< listArr.length; i++){
            var popi = new Object
            var keys = Object.keys(listArr[i])
            for (var j=0; j < Object.keys(listArr[i]).length; j++){
                popi[keys[j]]= listArr[i][keys[j]]
            }
            console.log(popi)
            obd.append(popi)
        }

//        return ld
    }

    function upListing(listArr){

    console.log('upList')
        listData.clear()
        for (var i=0; i< listArr.length; i++){
            var popi = new Object
            var keys = Object.keys(listArr[i])
            for (var j=0; j < Object.keys(listArr[i]).length; j++){
                popi[keys[j]]= listArr[i][keys[j]]
            }
            listData.append(popi)
        }

        listing.update()
    }

    id: main
    visible: true
    width: Screen.desktopAvailableWidth
    height: Screen.desktopAvailableHeight
    title: qsTr("MyListing")
    color: "#2B2D3C"

    signal sendToAdd(string title, string discript, string price, var picArr, string aliUrl)

    ListModel{
        id: listData
    }

    MouseArea{
        id: globalArea
        anchors.fill: parent
    }

    Connections{
        target: delegateAcc

        onToQMLendAddItem:{

        }

        onToQMLshowMainView:{
            mainView.visible = true
            console.log(Screen.desktopAvailableWidth)
            console.log(Screen.desktopAvailableHeight)
            console.log(listingView.width)
            delegateAcc.getListing()
            busyIndicator.running = true
        }

        onToQMLneedLogin:{
            loginView.visible = true

        }

        onToQMLBadEbay:{
            badEnay.visible = true
        }

        onToQMLsendListing:{
            busyIndicator.running = false
            upListing(data["activ"])

        }
        onToQMLsendCategor:{
//            listCategory = data
            console.log(data["items"][1].CategoryName)
            listCategoty = data["items"]

//            console.log(listCategory[4]["CategoryName"])
        }

        onToQMLErrorMessage:{

            messageBox.show()
            textError.text = err
        }

    }

    Rectangle{
        id: mainView
        visible: false
        anchors.fill: parent
        color: "#2B2D3C"
        Rectangle{
            id: leftPanel
            color: '#2F3242'
            x:0
            y: topPanel.height
            height: mainView.height - topPanel.height
            width: 60
            Rectangle{
                id: aliBut
                x: 0
                y: 0
                width: 60
                height: 55
                color: '#2F3242'

                Image {
                    id: imagButAli
                    anchors.fill: parent
                    anchors.margins: 20
                    source: "web/ali.png"
                }

                MouseArea{
                    anchors.fill: parent

                    onReleased: {
                        mlBut.color = '#2F3242'
                        aliBut.color = "#2B2D3C"
                    }

                    onClicked: {
                        aliView.visible = true
//                        webAli.url = "https://www.aliexpress.com/"
                        listingView.visible = false
//                        webAli.url = "https://www.aliexpress.com/item/Best-Selling-10-Pieces-Pack-juniper-bonsai-tree-potted-flowers-office-bonsai-purify-the-air-absorb/32470856363.html?spm=2114.search0104.3.46.7e292a744NmIuv&ws_ab_test=searchweb0_0,searchweb201602_2_10152_10151_10065_10068_10344_10342_10325_10546_10343_10340_10548_10341_5723217_10696_10084_10083_10618_10307_10059_100031_10103_10624_10623_10622_10621_10620,searchweb201603_12,ppcSwitch_7&algo_expid=0b2fb135-face-4c75-92d9-4fbfafb2cca7-6&algo_pvid=0b2fb135-face-4c75-92d9-4fbfafb2cca7&transAbTest=ae803_1&priceBeautifyAB=0"
                    }
                }
            }
            Rectangle{
                id: mlBut
                x: 0
                y: 55
                width: 60
                height: 55
                color: '#2F3242'

                Image {
                    id: imagButMl
                    height: 6
                    anchors.rightMargin: 15
                    anchors.bottomMargin: 20
                    anchors.fill: parent
                    anchors.margins: 20
                    source: "web/ml.png"
                }

                MouseArea{
                    anchors.fill: parent
                    onReleased: {
                        mlBut.color =  "#2B2D3C"
                        aliBut.color = '#2F3242'
                    }

                    onClicked: {
                        aliView.visible = false
                        listingView.visible = true
                        delegateAcc.getListing()
                        busyIndicator.running = true
                        listing.update()
//                        webAli.url = "https://www.aliexpress.com/item/Best-Selling-10-Pieces-Pack-juniper-bonsai-tree-potted-flowers-office-bonsai-purify-the-air-absorb/32470856363.html?spm=2114.search0104.3.46.7e292a744NmIuv&ws_ab_test=searchweb0_0,searchweb201602_2_10152_10151_10065_10068_10344_10342_10325_10546_10343_10340_10548_10341_5723217_10696_10084_10083_10618_10307_10059_100031_10103_10624_10623_10622_10621_10620,searchweb201603_12,ppcSwitch_7&algo_expid=0b2fb135-face-4c75-92d9-4fbfafb2cca7-6&algo_pvid=0b2fb135-face-4c75-92d9-4fbfafb2cca7&transAbTest=ae803_1&priceBeautifyAB=0"
                    }
                }
            }

        }
        Rectangle{
            id: topPanel
            x:0
            y:0
            height: 55
            z: 1
            width: mainView.width

            color: '#2F3242'

            Image {
                id: image
                anchors.verticalCenter: parent.verticalCenter
                x: 10
//                y: 16
                width: 110
                height: 25
                anchors.verticalCenterOffset: 0

                source: "web/logo.png"

            }




        }

        Rectangle{
            id: workView
            x: leftPanel.width
            y: topPanel.height
            width: mainView.width -leftPanel.width
            height: mainView.height - topPanel.height

            BusyIndicator {
                id: busyIndicator
                //enabled: false
                z: 1
                visible: true
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.verticalCenter: parent.verticalCenter

                contentItem: Item {
                        implicitWidth: 64
                        implicitHeight: 64

                        Item {
                            id: itemB
                            x: parent.width / 2 - 32
                            y: parent.height / 2 - 32
                            width: 64
                            height: 64
                            opacity: busyIndicator.running ? 1 : 0

                            Behavior on opacity {
                                OpacityAnimator {
                                    duration: 250
                                }
                            }

                            RotationAnimator {
                                target: busyIndicator
                                running: busyIndicator.visible && busyIndicator.running
                                from: 0
                                to: 360
                                loops: Animation.Infinite
                                duration: 2900
                            }

                            Repeater {
                                id: repeater
                                model: 8

                                Rectangle {
                                    x: itemB.width / 2 - width / 2
                                    y: itemB.height / 2 - height / 2
                                    implicitWidth: 9
                                    implicitHeight: 9
                                    radius: 5
                                    color: "#EBECEC"
                                    transform: [
                                        Translate {
                                            y: -Math.min(itemB.width, itemB.height) * 0.5 + 5
                                        },
                                        Rotation {
                                            angle: index / repeater.count * 360
                                            origin.x: 5
                                            origin.y: 5
                                        }
                                    ]
                                }
                            }
                        }
                    }
            }

            Rectangle{
                id: headerWork
                x: 0
                y: 0
                width: workView.width
                height: 55
                color: "#2481CE"
                z: 2
                Button{
                    id: addItemButton
                    x: 20
                    anchors.verticalCenter: parent.verticalCenter
                    width: 70
                    height: 20
                    display: AbstractButton.TextOnly

                    Rectangle{
                        id: backButadd
                        x: -5
                        y: -5
                        width: 80
                        height: 30
                        color: "#2196F3"
                        radius: 20
                        Text{
                            anchors.verticalCenter: parent.verticalCenter
                            x: 15
                            text: "Add"
                            font.pointSize: 14
                            color: "#FEFEFE"
                        }

                        Image {
                            id: plusAdd
                            width: 10
                            height: 10
                            source: "web/plus.png"
                            anchors.verticalCenter: parent.verticalCenter
                            anchors {right: backButadd.right; rightMargin: 15}

                        }

                        gradient: Gradient {
//                            GradientStop { position: 0 ; color: addItemButton.pressed ? "#2196F3" : "#2196F3" }
                            GradientStop { position: 0 ; color: addItemButton.pressed ? "#3092E3" : "#2196F3" }
                        }

                    }

                    onClicked: {
                        delegateAcc.getCategorys()
                        addItemeBay.show()
                    }
                }
            }

            Rectangle{
                id: aliView
                visible: false
                anchors.fill: parent
                z: 3
//                anchors { left: parent.left; right: parent.right; top: headerWork.bottom; bottom: workView.bottom }
                Loader{
                    source: "aliViewFile.qml"
                }
            }

            Rectangle{
                id: listingView
//                anchors.fill: parent
                anchors { left: parent.left; right: parent.right; top: headerWork.bottom; bottom: workView.bottom }

                color: "#2B2D3C"
                Item {
                    id: head
                    anchors {top: parent.top; left: parent.left; right: parent.right}
                    height: 25
                    z: 1

                    Rectangle{
                        anchors.fill: parent
                        color: "#2B2D3C"
                        Text{
                            id: photoInHead
                            anchors.left: parent.left
                            anchors.leftMargin: 18
//                            anchors.right: nameInHead.left
                            width: listingView.width/12.55
                            anchors.verticalCenter: parent.verticalCenter
                            color: "#fefefe"
                            text: "Фото"
                            anchors.verticalCenterOffset: 0

                            wrapMode: Text.NoWrap
                            fontSizeMode: Text.FixedSize
                            font.pointSize: 13
                            horizontalAlignment: Text.AlignLeft
                        }

                        Text{
                            id: nameInHead

                            width: listingView.width/4
                            anchors.left: photoInHead.right
                            anchors.verticalCenter: parent.verticalCenter
                            color: "#fefefe"
                            text: "Название"
                            anchors.verticalCenterOffset: 0

                            wrapMode: Text.NoWrap
                            fontSizeMode: Text.FixedSize
                            font.pointSize: 13
                            horizontalAlignment: Text.AlignLeft
                        }
                        Text{
                            id: priceInHead

                            width: listingView.width/12.55
                            anchors.left: nameInHead.right
                            anchors.verticalCenter: parent.verticalCenter
                            color: "#fefefe"
                            text: "Цена"
                            anchors.verticalCenterOffset: 0

                            wrapMode: Text.NoWrap
                            fontSizeMode: Text.FixedSize
                            font.pointSize: 12
                            horizontalAlignment: Text.AlignLeft
                        }

                        Text{
                            id: profitInHead

//                            anchors.leftMargin: 100
                            anchors.left: priceInHead.right
                            width: listingView.width/4
                            height: 19
                            anchors.verticalCenter: parent.verticalCenter
                            color: "#fefefe"
                            text: "Прибыль"
                            anchors.verticalCenterOffset: 0

                            wrapMode: Text.NoWrap
                            fontSizeMode: Text.FixedSize
                            font.pointSize: 13
                            horizontalAlignment: Text.AlignLeft
                        }

                        Text{
                            id: countInHead

                            width: listingView.width/12.55
                            anchors.left: profitInHead.right
                            anchors.verticalCenter: parent.verticalCenter
                            color: "#fefefe"
                            text: "Кол-во"
                            anchors.verticalCenterOffset: 0
                            anchors.rightMargin: 333
                            wrapMode: Text.NoWrap
                            fontSizeMode: Text.FixedSize
                            font.pointSize: 13
                            horizontalAlignment: Text.AlignLeft
                        }
                        Text{
                            id: soldInHead
                            width: listingView.width/4
                            anchors.left: countInHead.right
//                            anchors.right: parent.right
                            anchors.verticalCenter: parent.verticalCenter
                            color: "#fefefe"
                            text: "Продано"
                            anchors.verticalCenterOffset: 0

                            wrapMode: Text.NoWrap
                            fontSizeMode: Text.FixedSize
                            font.pointSize: 12
                            horizontalAlignment: Text.AlignLeft
                        }
                    }

                }
                Component{
                    id: dregDelegate

                    Loader{
                        source: "ListingSheep.qml"
                    }
                }

                ListView{
                    id: listing
                    snapMode: ListView.NoSnap
                    boundsBehavior: Flickable.DragOverBounds
                    anchors { fill: parent; leftMargin: 0; rightMargin: 0; topMargin: 25 }

                    model: listData
                    delegate: dregDelegate

                    spacing: 10
                    cacheBuffer: 50

                    onVerticalOvershootChanged: {
                        console.log(listing.contentY)

                        if (listing.atYEnd){
                         console.log("end list", ccc)
//                           listing.enabled = false
                        ccc++
                        }
                    }


                }



            }
        }

    }
    property int  ccc: 0
    Window {
        id: rgstrView
        width: 600
        height: 400
        maximumHeight: height
        maximumWidth: width
        minimumHeight: height
        minimumWidth: width

        Loader{

            source: "winRegi.qml"
        }

    }

    Window{
        id: ebayAuth
        width: 800
        height: 600
        WebEngineView{
            id: webV
            anchors.fill: parent
            //url: "https://vk.com"
        }
    }

    Window{
        id: badEnay
        width: 800
        height: 600
        Rectangle{
            anchors.fill: parent
            Label{
                text: "давай нормально да войдем в еьай"
            }
        }
    }

    Window{
        id: addItemeBay
        title: "Карточка товара"
//        width: 800
//        height: 600
        width: Screen.desktopAvailableWidth/1.8
        height: Screen.desktopAvailableHeight/1.365
        maximumHeight: height
        maximumWidth: width
        minimumHeight: height
        minimumWidth: width

        Loader{
            source: "addItemeBay.qml"
        }


    }

    Item {
        id: loginView
        visible:  false
        Loader{

            source: "winLogi.qml"
        }

    }

    Window{
        id: messageBox
        width: 550
        height: 150
        title: "Error"
        Text{
            id: textError
            width: 500
            x: 10
            y: 10
            text: "error"
            wrapMode: Text.WrapAnywhere
        }

    }



}
