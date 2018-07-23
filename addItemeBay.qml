import QtQuick 2.9
import QtQuick.Controls 2.2
import QtQuick.Window 2.2
import Qt.labs.calendar 1.0
import QtQuick.Window 2.3
import QtWebEngine 1.0
import QtQuick.Dialogs 1.2


Item {
//    width: 800
//    height: 600
    width: Screen.desktopAvailableWidth/1.8
    height: Screen.desktopAvailableHeight/1.365


    MouseArea{
        id: addMainarea
        anchors.fill: parent

    }

    Connections{
        target: delegateAcc

        onToQMLendAddItem:{
            addMainarea.cursorShape = Qt.SizeHorCursor
        }
    }


    Connections{
        target: addItemeBay
        onClosing:{
            addUrlWin.close()
            catId = 0
            aliTitleField.text = ''
            titleField.text = ""
            discriptionEdit.text = ''
            priceField.text = ''
            aliurl = ""
            labelCat.text = "Категория"
            phList.clear()

        }
    }

    Connections{

        target: main
        onSendToAdd:{
            aliTitleField.text = title
            var result = discript.replace(/<[^>]+>/g,'<br>')
            discriptionEdit.text = result

            console.log("--------discription---------")
            console.log(discriptionEdit.text)
            console.log("----------------------------")

            priceAliField.text = parseFloat(price)
            aliurl= aliUrl

            catId = 0
            urlPhArr = []
            listSh.visible = false
            for (var i = 0; i < picArr.length; i ++){
                var popi = new Object
                popi.URL = picArr[i]
                urlPhArr.push(picArr[i])
                popi.id = i
                phList.append(popi)

            }
            photiGal.update()
        }

    }

    property int catId: 0
    property int lenList: 0
    property var strongLen: []
    property var urlPhArr: []
    property var filePhArr: []
    property string aliurl: ""

    function nameCategory(id){
        for (var i=0; i< listCategoty.length; i++){
            if (listCategoty[i].CategotyID === id){

                return listCategoty[i].CategoryName

            }
        }
    }

    function calcProfit(){
        var valAli = parseFloat(priceAliField.text)
        var valNew = parseFloat(priceField.text)


        var result = (valNew - valAli)/(valAli)
        console.log(result*100)
        if (result >= 0 &&  parseInt(result) < 1000){
            profitText.text = (parseInt(result*100)).toString()+'%'
        }

    }

    function foundParent(id){
        var result = ""
        console.log(id)
        var founId = id
        var a = 1
        while(1===1){
            console.log(a)
            for (var i=0; i< listCategoty.length; i++){

                if (listCategoty[i].CategotyID === Number (founId)){
                    if (listCategoty[i].CategotyID === Number(listCategoty[i].CategoryParentID)){
                        return result + "->" + listCategoty[i].CategoryName

                    }else{
                        result = result + "->" + listCategoty[i].CategoryName
                        console.log(result)
                        founId = listCategoty[i].CategoryParentID
                        break
                    }
                }
            }
        }

    }


    function foundParentT(id){
        var result = ""


        for (var i=0; i< listCategoty.length; i++){

            if (listCategoty[i].CategotyID === Number (id)){
                if (listCategoty[i].CategotyID === Number(listCategoty[i].CategoryParentID)){
                    return listCategoty[i].CategoryName

                }else{
                    //                    return listCategoty[i].CategoryName + "/" + foundParentT(listCategoty[i].CategoryParentID)
                    return foundParentT(listCategoty[i].CategoryParentID) + "->" + listCategoty[i].CategoryName

                }
            }
        }

    }


    function creatChein(id){
        //console.log(id)
        var frd = foundParentT(id)
        //        var arr = frd.split("/")
        //        var result = ""
        //        for (var i = arr.length - 1; i >= 0; i--){
        //            if (result === ""){
        //                result = arr[i]
        //            }else{
        //                result = result + "->" + arr[i]
        //            }
        //        }
        var result = frd
        return result

    }

    function foundInArr(lineArr){

        var result = []

        for (var i = 0; i< lineArr.length; i++){

            for (var j= 0; j < listCategoty.length; j++){

                var namArr = listCategoty[j].CategoryName.split(" ")
                for (var k = 0; k < namArr.length; k++){
                    if (lineArr[i].toLowerCase() === namArr[k].toLowerCase()){
                        //                        console.log(creatChein(listCategoty[j].CategotyID))
                        result.push([creatChein(listCategoty[j].CategotyID), listCategoty[j].CategotyID])
                        break
                    }
                }
            }
        }
        return result

    }

    ListModel{
        id: caterData
    }

    Rectangle{
//        width: 800
//        height: 600
        width: Screen.desktopAvailableWidth/1.8
        height: Screen.desktopAvailableHeight/1.365
        id: addItemView
        color: "#3A3E52"


        TextField {
            id: titleField
            x: 25
            y: 45
//            width: 646
            anchors {right: parent.right; rightMargin: 30; left: parent.left; leftMargin: 30}
            height: 25
            text: qsTr("")
            font.pointSize: 10
            placeholderText: "Title"
            selectByMouse: true
            maximumLength: 80
            MouseArea {
                anchors.fill: parent
                cursorShape: Qt.IBeamCursor
                acceptedButtons: Qt.NoButton
            }
            onTextChanged: {

                if (catId === 0){

                    listSh.visible = true
                    var tArr = text.replace(",", "").split(" ")

                    var arrCat = []
                    caterData.clear()
                    if (tArr.length < lenList && tArr.length>1){

                        arrCat = foundInArr(tArr)
                        strongLen = arrCat
                        arrCat = strongLen

                    }else{

                        if (text[text.length-1]=== " "){

                            arrCat = foundInArr([tArr[tArr.length-2]])
                            for (var k = 0; k< arrCat.length; k++){
                                strongLen.push(arrCat[k])
                            }
                            arrCat = strongLen

                        }else{
                            arrCat = foundInArr([tArr[tArr.length-1]])
                            console.log(tArr[tArr.length-1])
                            for (var kj = 0; kj< strongLen.length; kj++){
                                arrCat.push(strongLen[kj])
                            }
                        }
                    }

                    for (var i = 0; i < arrCat.length; i++){
                        var popi = new Object
                        popi.line = arrCat[i][0]
                        popi.id = arrCat[i][1]
                        caterData.append(popi)
                    }

                    lenList = tArr.length
                    listSh.update()
                }

            }
        }

        TextField {
            id: aliTitleField
            x: 25
            y: 104
            anchors {right: parent.right; rightMargin: 30; left: parent.left; leftMargin: 30}
            height: 25
            text: qsTr("")
            font.pointSize: 10
            placeholderText: "AliTitle"
            selectByMouse: true
        }

        Label {
            id: labelCat
            x: 25
            y: 76
            width: 646
            height: 22
            color: "#faffbd"
            text: "Категория"
            font.pointSize: 11
            styleColor: "#ca6060"

            font.capitalization: Font.SmallCaps
            textFormat: Text.AutoText
            wrapMode: Text.WordWrap
            fontSizeMode: Text.VerticalFit
        }

        Component{
            id: tablDelegate
            Rectangle{
                height: 40
                width: 646
                color: "#585C6F"
                Label{
                    id: comLab
                    x: 10
                    y: 10
                    anchors.fill: parent
                    height: 40
                    text: model.line
                    wrapMode: Text.WordWrap
                    fontSizeMode: Text.VerticalFit

                    MouseArea{
                        id: mouseArea
                        anchors.fill: parent
                        onClicked: {
                            console.log(model.id)
                            catId = model.id
                            labelCat.text = model.line
                            listSh.visible = false
                        }
                    }
                }
            }

        }

        ListView{
            id: listSh
            height: 265
            visible: false
            highlightRangeMode: ListView.StrictlyEnforceRange
            z: 3
            anchors.bottomMargin: 360
            snapMode: ListView.NoSnap
            boundsBehavior: Flickable.StopAtBounds
            anchors { fill: parent; leftMargin: 25; rightMargin: 129; topMargin: 76 }


            model: caterData
            delegate: tablDelegate
            spacing: 4
            cacheBuffer: 50

            onFlickingVerticallyChanged: {

            }

        }

        Component{
            id: photoDelegat
            Image{
                height: 70
                width:  90
                source: model.URL
                fillMode: Image.PreserveAspectFit
                MouseArea{
                    anchors.fill: parent
                    onClicked: {

                        console.log(model.URL)
                    }
                }
            }
        }



        GridView{
            id: photiGal
            x: 389
            y: 308
            height: 202

            boundsBehavior: Flickable.DragOverBounds
            contentWidth: 0
            highlightRangeMode: GridView.NoHighlightRange
            keyNavigationWraps: true
            flow: GridView.FlowLeftToRight
            cellWidth: 100
            cellHeight: 90
            width: 396
            delegate: photoDelegat
            model: phList

            Button {
                id: button
                x: 11
                y: -45
                width: 108
                height: 23
                text: qsTr("URL")
                onClicked: {
                    addUrlWin.show()

                }
            }

            Button {
                id: button1
                x: 153
                y: -45
                width: 108
                height: 23
                text: qsTr("File")
                onClicked: {
                    fileDialog.open()
                }

            }

        }

        Button {
            id: sendData1
//                x: 487
            //y: 549
            anchors.bottom: sendData.bottom
            anchors.right: sendData.left
            anchors.rightMargin: 30
            width: 112
            height: 29
            text: qsTr("Отмена")
            onClicked: {
                addItemeBay.close()
            }
        }

        Button {
            id: sendData
            x: 639
            y: 549
            width: 112
            height: 29
            text: qsTr("Готово")
            onClicked: {
                //(QString title, QString discription, QString listImg, int category, double price, int count, QString urlAliItem)
//                var re = new RegExp('/', 'g');
//                var dis = discriptionEdit.text.replace(re, '@')
//                var ree = new RegExp('<', 'g')
//                dis = dis.replace(ree, '666')

//                var repa = new RegExp('>', 'g')
//                dis = dis.replace(repa, '777')

//                var repapa = new RegExp('{', 'g')
//                dis = dis.replace(repapa, '999')

//                var repapatt = new RegExp('}', 'g')
//                dis = dis.replace(repapatt, '555')
                var dis = discriptionEdit.text
                var repapattdd = new RegExp(';', 'g')
                dis = dis.replace(repapattdd, '444')
              addMainarea.cursorShape = Qt.WaitCursor

               var re = new RegExp(',', 'g');
                delegateAcc.sendDataAddItemFixPriceeBay(titleField.text, dis, urlPhArr.toString().replace(re, "@"), catId, priceField.text, countField1.text, aliurl  )
            }

        }

        FileDialog{
            id: fileDialog
            folder: shortcuts.home
            nameFilters: ["Image files (*.jpeg, *.JPG, *.jpg)"]
            onAccepted: {
                console.log("\n\n", fileDialog.fileUrl)
                filePhArr.push(urF.text)
                var popi = new Object
                popi.URL = fileDialog.fileUrl.toString()
                popi.id = filePhArr.length -1
                phList.append(popi)
                photiGal.update()
                addUrlWin.close()

                //-----



                //----


            }
        }

        ListModel {
            id: phList
        }


        Window{
            id:addUrlWin
            height: 120
            width: 350
            color: "#3A3E52"
            Text{
                x:10
                y:15
                width: 100
                height: 20
                text: "URL:"
                color: "#c0b6e8"
            }

            TextField{
                id: urF
                x: 10
                y: 40
                height: 30
                width: 320
            }

            Button{
                id: butAdd
                anchors.right: urF.right
//                anchors.bottom: discriptionEdit.bottom
                height: 30
                width:80
                text: "Добавить"
                onClicked: {
                    if (urF.text != ""){
                        urlPhArr.push(urF.text)
                        var popi = new Object
                        popi.URL = urF.text
                        popi.id = urlPhArr.length -1
                        phList.append(popi)
                        photiGal.update()
                        addUrlWin.close()

                    }

                }
            }



        }

        TextField {
            id: priceField
            x: 25
            y: 182
            width: 63
            height: 25
            text: qsTr("")
            font.pointSize: 10
            placeholderText: "Цена"
            selectByMouse: true
            onTextChanged: {
                calcProfit()
            }
        }

        TextField {
            id: countField1
            x: 223
            y: 183
            width: 63
            height: 25
            text: qsTr("")
            font.pointSize: 10
            placeholderText: "Кол-во"
            selectByMouse: true
        }


        Rectangle{

            x: 31
            y: 262

            width: 327
            height: addItemView.height/2.1
            color: "white"

        ScrollView{

            x: 0
            y: 0

            width: 327
            height: addItemView.height/2.1


        TextArea {
            id: discriptionEdit
            x: 0
            y: 0
            width: 327
            height: addItemView.height/2.1
            text: ""
            renderType: Text.QtRendering

            wrapMode: Text.WrapAnywhere

            horizontalAlignment: Text.AlignLeft
            selectionColor: "#2d75e1"
            cursorVisible: true
            textFormat: Text.PlainText
            z: 3


            font.pixelSize: 10



        }



        }
}


        Label {
            id: label
            x: 25
            y: 20
            width: 57
            height: 16
            color: "#fefefe"
            text: qsTr("Название")
            font.pointSize: 16
        }

        TextField {
            id: priceAliField
            x: 105
            y: 182
            width: 63
            height: 25
            text: qsTr("")
            placeholderText: "Цена Ali"
            font.pointSize: 10
            selectByMouse: true
            onTextChanged: {
                calcProfit()
            }
        }

        Label {
            id: label1
            x: 25
            y: 156
            width: 57
            height: 16
            color: "#fefefe"
            text: qsTr("Цена")
            font.pointSize: 16
        }

        Label {
            id: label2
            x: 223
            y: 156
            width: 57
            height: 16
            color: "#fefefe"
            text: qsTr("Кол-во")
            font.pointSize: 16
        }

        Label {
            id: label3
            x: 340
            y: 156
            width: 57
            height: 16
            color: "#fefefe"
            text: qsTr("Прибыль")
            font.pointSize: 16
        }

        Text {
            id: profitText
            x: 340
            y: 183
            width: 63
            height: 25
            color: "#4caf50"
            text: qsTr("0%")
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter
            font.pixelSize: 16

            Rectangle{
                anchors.fill: parent
                color: "white"
                z: -1
            }
        }



        Label {
            id: label4
            x: 31
            y: 237
            width: 57
            height: 16
            color: "#fefefe"
            text: qsTr("Описание")
            font.pointSize: 16
        }

        Label {
            id: label5
            x: 401
            y: 237
            width: 57
            height: 16
            color: "#fefefe"
            text: qsTr("Фото")
            font.pointSize: 16
        }




    }



}
