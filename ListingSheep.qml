import QtQuick 2.9
import QtQuick.Controls 2.2
import QtQuick.Window 2.2
import Qt.labs.calendar 1.0
import QtQuick.Window 2.3
import QtWebEngine 1.0

Item {
    id: listIthem
    height: 70
    width: listingView.width

    Rectangle{
                            id: content
                            y: 0
                            height: 60
                            color: "#3A3E52"

                            width: 500

                            //clip: false
                            anchors { left: parent.left; right: parent.right; margins: 20 }

                            Rectangle{
                                x:0
                                y:0
                                height: content.height
                                width: 3
                                color: "#4CAF50"
                            }

                            Image {
                                id: imageLi
                                anchors {left: parent.left; leftMargin: 15; top: parent.top ;topMargin: 10 }
                                width: height
                                fillMode: Image.PreserveAspectFit
                                anchors.verticalCenter: parent.verticalCenter

                                source: model.frontIMG
                            }

                            Label {
                                id: name
                                anchors.verticalCenter: parent.verticalCenter
                                width: listIthem.width/5
                                color: "#fefefe"
                                anchors { left: imageLi.right; margins: listIthem.width/18 }
                                text: model.title
                                padding: 0
                                font.capitalization: Font.Capitalize
                                wrapMode: Text.WordWrap
                                verticalAlignment: Text.AlignVCenter
                                fontSizeMode: Text.VerticalFit
                                textFormat: Text.PlainText
                            }

                            Text {
                                id: price
                                color: "#fefefe"
                                anchors.verticalCenter: parent.verticalCenter
                                anchors { left: name.right; margins: listIthem.width/18 }
                                text: "$"+model.valuePrice
                            }

                            Text {
                                id: quan
                                color: "#fefefe"
                                anchors.verticalCenter: parent.verticalCenter
                                anchors { left: price.right; margins: 300 }
                                text: model.Quantity
                            }

                            Text {
                                id: quanAv
                                color: "#fefefe"
                                anchors.verticalCenter: parent.verticalCenter
                                anchors { left: quan.right; margins: listIthem.width/18 }
                                text: model.QuantityAvailable
                            }

                            Text {
                                id: quanWc
                                color: "#fefefe"
                                anchors.verticalCenter: parent.verticalCenter
                                anchors { left: quanAv.right; margins: listIthem.width/18 }
                                text: model.WatchCount
                            }
                        }

}
