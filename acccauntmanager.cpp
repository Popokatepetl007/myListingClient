#include "acccauntmanager.h"
#include "requestmanager.h"
#include <QObject>
#include <QDebug>
#include <QFile>
#include <QDir>
#include <QVariant>
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

void AcccauntManager::exitAcc()
{
    h->exit(UserInstant::getInstance()->appid);
    UserInstant::getInstance()->payPalmail = "none";
    UserInstant::getInstance()->appid ="none";
    saveAppId();

}

void AcccauntManager::setPayPalmail(QString mail){
    UserInstant::getInstance()->payPalmail = mail;
    saveAppId();
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
    h->addFixPriceeBayReqest(title, discription, listImg, category, price, count, urlAliItem);
    QObject::connect(h, SIGNAL(resultAddFixPrice(QJsonDocument)), this, SLOT(resultAddingFixPriceeBay(QJsonDocument)));
}

void AcccauntManager::resultAddingFixPriceeBay(QJsonDocument document)
{
    if (document["error"].toString() != "none"){
        qDebug()<< document["error"];
       emit toQMLErrorMessage(document["error"].toString());

    }
    qDebug()<<document["result"];
    if (document["result"].toString() == "successfully"){
        qDebug()<<document["itemId"].toString();
        qDebug()<<document["aliurl"].toString();
    }

    emit toQMLendAddItem();
    qDebug()<<document["itemId"];
}

void AcccauntManager::resultLogin(QJsonDocument document){
    qDebug()<<document["result"];
    qDebug()<<document["eBayAuthURL"];
    UserInstant::getInstance()->appid= document["appid"].toString();
    saveAppId();
    qDebug()<<"resultLogin";
    if (document["eBayAuthURL"].toString() != "none"){
        h->waitToken();
        QObject::connect(h, SIGNAL(resultAuthEbay(QJsonDocument)), this, SLOT(resultEbayAuth(QJsonDocument)));
    }

    emit toQMLLogin(document["result"].toString(), document["eBayAuthURL"].toString());

}

void AcccauntManager::writeJsFile(QString nameFil, QVariantMap map)
{
    qDebug()<<"--satart saving JS";
    qDebug()<<map;
    QString fromFile;
    QFile *file = new QFile( nameFil);
    if (file->exists()){

        if (!file->open(QIODevice::ReadOnly | QIODevice::Text)){
            qDebug()<<"can't open file";
        }
        fromFile = file->readAll();
        file->close();

        QJsonDocument sd = QJsonDocument::fromJson(fromFile.toUtf8());
        qWarning() << sd.isNull();

        QJsonObject object = QJsonObject::fromVariantMap(map);
        QJsonDocument document;
        document.setObject(object);

        qDebug()<< document;
        QFile jsonFile(nameFil);
        jsonFile.open(QIODevice::WriteOnly);
        jsonFile.write(document.toJson());
        jsonFile.close();

    } else{
        qDebug()<<"file not exist";
    }
}

void AcccauntManager::saveAppId()
{

    QVariantMap newJs;
    qDebug()<<UserInstant::getInstance()->appid;
    qDebug()<<"----";
//    qDebug()<< sd;
    newJs.insert("appid", UserInstant::getInstance()->appid);
    newJs.insert("paypalemail", UserInstant::getInstance()->payPalmail);
    writeJsFile("setting.json", newJs);

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
    qDebug()<<document;
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
        saveAppId();
        emit toQMLshowMainView();
    }
    else{
        emit toQMLneedLogin();
    }
}

void AcccauntManager::getCategorys(){
    QString fromFile;


    QDir dir(QDir::current());
        dir.setFilter(QDir::Files | QDir::Hidden | QDir::NoSymLinks);
        dir.setSorting(QDir::Size | QDir::Reversed);
    dir.cdUp();
    dir.cdUp();
    dir.cdUp();
        QFileInfoList list = dir.entryInfoList();
        qDebug() << "     Bytes Filename";
        for (int i = 0; i < list.size(); ++i) {
            QFileInfo fileInfo = list.at(i);
            qDebug() << qPrintable(QString("%1 %2").arg(fileInfo.size(), 10)
                                                    .arg(fileInfo.fileName()));

        }

    qDebug()<< dir.currentPath();
    QFile *file = new QFile( "categorys.json");
    if (file->exists()){
//        file->setFileName("categorys.json");
        if (!file->open(QIODevice::ReadOnly | QIODevice::Text)){
            qDebug()<<"can't open file";
        }
        fromFile = file->readAll();
        file->close();

        QJsonDocument sd = QJsonDocument::fromJson(fromFile.toUtf8());
        qWarning() << sd.isNull();
        qDebug()<<"category try";
        qDebug()<<sd["items"][0]["CategotyID"].toInt();
        emit toQMLsendCategor(sd.toVariant());
    } else{
        qDebug()<<"file not exist";
    }



}
