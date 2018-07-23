#include "requestmanager.h"
#include <QNetworkAccessManager>
#include <QDebug>
#include <QNetworkReply>
#include <QByteArray>
#include <QNetworkRequest>
#include <QTextCodec>
#include <QJsonDocument>
#include <QJsonObject>
#include <QJsonArray>

#include <QNetworkConfiguration>
#include <QHttpMultiPart>
#include "userinstant.h"

RequestManager::RequestManager(QObject *parent) : QObject(parent)
{
    qDebug()<<"start req";
    manager = new QNetworkAccessManager(this);
    //host = "http://192.168.1.133:8070";
//    host = "http://127.0.0.1:8070";
    host = "http://80.89.132.2:31295";
}




QNetworkRequest RequestManager::createRequest(QUrl url)
{

    QNetworkRequest request;
    request.setUrl(url);
    request.setRawHeader("user-Agent", "MyListing 1.0 dev");
    request.setRawHeader("userCountryCode", "US");
    request.setRawHeader("userCountryName", "USA");
//    request.setHeader(QNetworkRequest::use,"en_EN" );
//    request.setHeader(QNetworkRequest::,"en_EN" );
    //request.setHeader(QNetworkRequest::ContentTypeHeader, "text/type");

    return request;
}

void RequestManager::itemFromAli(QString url){
    replyAcc = manager->get(createRequest(QUrl(url)));

    QObject::connect(replyAcc,SIGNAL(finished()), this, SLOT(replyItemAli()));
    QObject::connect(replyAcc, SIGNAL(readyRead()), this, SLOT(replRead()));
}


void RequestManager::auth(QString login, QString password)
{
    QByteArray param = QString("login=%1&password=%2").arg(login, password).toUtf8();
    replyAcc = manager->post(createRequest(QUrl(host+"/auth/")), param);
    QObject::connect(replyAcc,SIGNAL(finished()), this, SLOT(replyAuth()));
    QObject::connect(replyAcc, SIGNAL(readyRead()), this, SLOT(replRead()));
}

void RequestManager::registr(QString login, QString password, QString email){
    QByteArray param = QString("login=%1&password=%2&email=%3").arg(login, password, email).toUtf8();
    replyAcc = manager->post(createRequest(QUrl(host+"/rgstr/")), param);
    qDebug()<<"waitfin0";
    QObject::connect(replyAcc,SIGNAL(finished()), this, SLOT(replyRgstr()));
    QObject::connect(replyAcc, SIGNAL(readyRead()), this, SLOT(replRead()));
}

void RequestManager::enter()
{

    QByteArray param = QString("appid=%1").arg(UserInstant::getInstance()->appid).toUtf8();
    replyAcc = manager->post(createRequest(QUrl(host+"/auth/")), param);
    QObject::connect(replyAcc,SIGNAL(finished()), this, SLOT(replyEnter()));
    QObject::connect(replyAcc, SIGNAL(readyRead()), this, SLOT(replRead()));
}

void RequestManager::exit(QString appid)
{
    QByteArray param = QString("appid=%1&exit=yes").arg(appid).toUtf8();
    replyAcc = manager->post(createRequest(QUrl(host+"/auth/")), param);
//    QObject::connect(replyAcc,SIGNAL(finished()), this, SLOT(replyEnter()));
    QObject::connect(replyAcc, SIGNAL(readyRead()), this, SLOT(replRead()));
}

void RequestManager::postPhoto(){

}

void RequestManager::waitToken()
{
    qDebug()<<"start wait eBay";
    QByteArray param = QString("appid=%1").arg(UserInstant::getInstance()->appid).toUtf8();
    replyAcc = manager->post(createRequest(QUrl(host+"/ebay/auth")), param);
    QObject::connect(replyAcc,SIGNAL(finished()), this, SLOT(replyEnterEBay()));
    QObject::connect(replyAcc, SIGNAL(readyRead()), this, SLOT(replRead()));
}

void RequestManager::getListingreq()
{
    qDebug()<<"start getListing";
    QByteArray param = QString("appid=%1&offset=%2").arg(UserInstant::getInstance()->appid, QString(UserInstant::getInstance()->offset)).toUtf8();
    replyAcc = manager->post(createRequest(QUrl(host+"/ebay/getlisting")), param);
    QObject::connect(replyAcc, SIGNAL(uploadProgress(qint64,qint64)),this, SLOT(tete(qint64,qint64)));
    QObject::connect(replyAcc,SIGNAL(finished()), this, SLOT(replListing()));
    QObject::connect(replyAcc, SIGNAL(readyRead()), this, SLOT(replRead()));
}

void RequestManager::addFixPriceeBayReqest(QString title, QString discription, QString listImg, int category, QString price, QString count, QString urlAliItem)
{
    qDebug()<<"strt add fix price item";
    //appid,title, category, price, count, discription, listURLPhoto

    QByteArray param = QString("appid=%1&title=%2&category=%3&price=%4&count=%5&discription=%6&listURLPhoto=%7&paypalemail=%8&aliurl=%9").arg(UserInstant::getInstance()->appid, title, QString::number(category), price, count, discription, listImg, UserInstant::getInstance()->payPalmail, "urlAliItem").toUtf8();
    qDebug()<<param;
    replyAcc = manager->post(createRequest(QUrl(host+"/ebay/addIremFixPrice")), param);
    QObject::connect(replyAcc,SIGNAL(finished()), this, SLOT(repAddFixPriceeBay()));
    QObject::connect(replyAcc, SIGNAL(readyRead()), this, SLOT(replRead()));
}

void RequestManager::replRead(){
    replyAcc->deleteLater();
}

void RequestManager::replyEnterEBay()
{
    QTextCodec *df = QTextCodec::codecForName("Windows-1251");
    QTextDecoder *decoder = new QTextDecoder(df);
    int codR = replyAcc->attribute(QNetworkRequest::HttpStatusCodeAttribute).toInt();
    if (codR >= 200 && codR < 300){

        QByteArray data= replyAcc->readAll();
        QJsonDocument document = QJsonDocument::fromJson(data);
        emit resultAuthEbay(document);

    } else if (codR >= 300 && codR < 400){

        redirAcc();

    } else{

        qDebug()<<"error\n\n"<<replyAcc->errorString()<<codR;
    }
}

void RequestManager::replyAuth()
{
    QTextCodec *df = QTextCodec::codecForName("Windows-1251");
    QTextDecoder *decoder = new QTextDecoder(df);
    int codR = replyAcc->attribute(QNetworkRequest::HttpStatusCodeAttribute).toInt();
    if (codR >= 200 && codR < 300){

        QByteArray data= replyAcc->readAll();
        QJsonDocument document = QJsonDocument::fromJson(data);
        emit resultAuth(document);

    } else if (codR >= 300 && codR < 400){

        redirAcc();

    } else{

        qDebug()<<"error\n\n"<<replyAcc->errorString()<<codR;
    }

}

void RequestManager::replyItemAli()
{
    QTextCodec *df = QTextCodec::codecForName("utf-8");
    QTextDecoder *decoder = new QTextDecoder(df);
    int codR = replyAcc->attribute(QNetworkRequest::HttpStatusCodeAttribute).toInt();
    qDebug()<<codR;
    qDebug()<<replyAcc->readAll();
    if (codR >= 200 && codR < 300){

          qDebug()<<replyAcc->readAll();
//        QByteArray data= replyAcc->readAll();
//        QJsonDocument document = QJsonDocument::fromJson(data);
//        emit resultAuth(document);

    } else if (codR >= 300 && codR < 400){

        redirAcc();

    } else{

        qDebug()<<"error\n\n"<<replyAcc->errorString()<<codR;
    }
}

void RequestManager::replyEnter()
{

    QTextCodec *df = QTextCodec::codecForName("Windows-1251");
    QTextDecoder *decoder = new QTextDecoder(df);
    int codR = replyAcc->attribute(QNetworkRequest::HttpStatusCodeAttribute).toInt();
    if (codR >= 200 && codR < 300){

        QByteArray data= replyAcc->readAll();
        QJsonDocument document = QJsonDocument::fromJson(data);
        qDebug()<<document["result"].toString();
        emit resultEnter(document);

    } else if (codR >= 300 && codR < 400){

        redirAcc();

    } else{

        qDebug()<<"error\n\n"<<replyAcc->errorString()<<codR;
    }
}

void RequestManager::replyRgstr(){
    QTextCodec *df = QTextCodec::codecForName("Windows-1251");
    QTextDecoder *decoder = new QTextDecoder(df);
    int codR = replyAcc->attribute(QNetworkRequest::HttpStatusCodeAttribute).toInt();
    if (codR >= 200 && codR < 300){

        QByteArray data= replyAcc->readAll();
        QJsonDocument document = QJsonDocument::fromJson(data);
        qDebug()<<document["result"].toString();
        emit resultRegstr(document);

    } else if (codR >= 300 && codR < 400){

        redirAcc();

    } else{

        qDebug()<<"error\n\n"<<replyAcc->errorString()<<codR;
    }
}

void RequestManager::replExit()
{
    QTextCodec *df = QTextCodec::codecForName("Windows-1251");
    QTextDecoder *decoder = new QTextDecoder(df);
    int codR = replyAcc->attribute(QNetworkRequest::HttpStatusCodeAttribute).toInt();
    if (codR >= 200 && codR < 300){

        QByteArray data= replyAcc->readAll();
        QJsonDocument document = QJsonDocument::fromJson(data);

    } else if (codR >= 300 && codR < 400){

        redirAcc();

    } else{

        qDebug()<<"error\n\n"<<replyAcc->errorString()<<codR;
    }

}

void RequestManager::replListing()
{
    QTextCodec *df = QTextCodec::codecForName("Windows-1251");
    QTextDecoder *decoder = new QTextDecoder(df);
    int codR = replyAcc->attribute(QNetworkRequest::HttpStatusCodeAttribute).toInt();
    qDebug()<<"startReply";
    if (codR >= 200 && codR < 300){

        QByteArray data= replyAcc->readAll();
        QJsonDocument document = QJsonDocument::fromJson(data);
        qDebug()<<document["result"].toString()<<"result listing";
        emit resultgetListing(document);

    } else if (codR >= 300 && codR < 400){

        redirAcc();

    } else{

        qDebug()<<"error\n\n"<<replyAcc->errorString()<<codR;
    }
}

void RequestManager::repAddFixPriceeBay()
{
    QTextCodec *df = QTextCodec::codecForName("Windows-1251");
    QTextDecoder *decoder = new QTextDecoder(df);
    int codR = replyAcc->attribute(QNetworkRequest::HttpStatusCodeAttribute).toInt();
    if (codR >= 200 && codR < 300){

        QByteArray data= replyAcc->readAll();
        QJsonDocument document = QJsonDocument::fromJson(data);
        qDebug()<<document["result"].toString()<<"result listing";
        emit resultAddFixPrice(document);

    } else if (codR >= 300 && codR < 400){

        redirAcc();

    } else{

        qDebug()<<"error\n\n"<<replyAcc->errorString()<<codR;
    }
}
