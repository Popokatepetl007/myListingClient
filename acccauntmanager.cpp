#include "acccauntmanager.h"
#include "requestmanager.h"
#include <QObject>
#include <QDebug>
#include <QFile>
#include "userinstant.h"
#include <QMessageBox>



AcccauntManager::AcccauntManager(QObject *parent) : QObject(parent)
{
    h = new RequestManager;

}

void AcccauntManager::login(QString login, QString password){

    h->auth(login, password);
    QObject::connect(h, SIGNAL(resultAuth(QJsonDocument)), this, SLOT(resultLogin(QJsonDocument)));


}


void AcccauntManager::getItemAli(QString url)
{
    h->itemFromAli(url);
}

void AcccauntManager::registr(QString login, QString password, QString email){

    h->registr(login, password, email);
    QObject::connect(h, SIGNAL(resultRegstr(QJsonDocument)), this, SLOT(resultREgistr(QJsonDocument)));

}


void AcccauntManager::getListing()
{
    h->getListingreq();
    QObject::connect(h, SIGNAL(resultgetListing(QJsonDocument)), this, SLOT(resultGetListing(QJsonDocument)));
}


void AcccauntManager::sendDataAddItemFixPriceeBay(QString title, QString discription, QString listImg, int category, QString price, QString count, QString urlAliItem)
{
    h->addFixPriceeBayReqest(title, discription, listImg, category, price, count);
    QObject::connect(h, SIGNAL(resultAddFixPrice(QJsonDocument)), this, SLOT(resultAddingFixPriceeBay(QJsonDocument)));
}

void AcccauntManager::resultAddingFixPriceeBay(QJsonDocument document)
{
    if (document["error"].toString() != "none"){
        qDebug()<< document["error"];
       emit toQMLErrorMessage(document["error"].toString());
    }
    qDebug()<<document["result"];
    qDebug()<<document["itemId"];
}

void AcccauntManager::resultLogin(QJsonDocument document){
    qDebug()<<document["result"];
    qDebug()<<document["eBayAuthURL"];
    UserInstant::getInstance()->appid= document["appid"].toString();
    if (document["eBayAuthURL"].toString() != "none"){
        h->waitToken();
        QObject::connect(h, SIGNAL(resultAuthEbay(QJsonDocument)), this, SLOT(resultEbayAuth(QJsonDocument)));
    }

    emit toQMLLogin(document["result"].toString(), document["eBayAuthURL"].toString());

}

void AcccauntManager::resultEbayAuth(QJsonDocument document)
{
    if (document["result"].toString() == "successfully"){
        UserInstant::getInstance()->eBaytoken = document["token"].toString();
    }else{
        emit toQMLBadEbay();
    }
}

void AcccauntManager::resultREgistr(QJsonDocument document){
    emit toQmlRegistr(document["result"].toString());
}

void AcccauntManager::resultGetListing(QJsonDocument document)
{
    qDebug()<<"result GetListing";
    //qDebug()<<document;
    if (document["result"].toString() == ""){

    }
    if (document["result"]== "successfully"){
        qDebug()<<document["activ"][0]<<"otv";

        emit toQMLsendListing(document.toVariant());
    }
    }


void AcccauntManager::resultEnther(QJsonDocument document)
{
    if (document["result"] == "successfully"){
        emit toQMLshowMainView();
    }
    else{
        emit toQMLneedLogin();
    }
}

void AcccauntManager::getCategorys(){
    QString fromFile;


    QFile *file = new QFile("/Users/administrator/build-myLIsting-Desktop_Qt_5_11_1_clang_64bit-Release/categorys.json");
    if (file->exists()){
//        file->setFileName("categorys.json");
        if (!file->open(QIODevice::ReadOnly | QIODevice::Text)){
            qDebug()<<"can't open file";
        }
        fromFile = file->readAll();
        file->close();

        QJsonDocument sd = QJsonDocument::fromJson(fromFile.toUtf8());
        qWarning() << sd.isNull();
        qDebug()<<sd["items"][0]["CategotyID"].toInt();
        emit toQMLsendCategor(sd.toVariant());
    } else{
        qDebug()<<"file not exist";
    }



}
