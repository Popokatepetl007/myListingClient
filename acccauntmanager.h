#ifndef ACCCAUNTMANAGER_H
#define ACCCAUNTMANAGER_H

#include <QObject>
#include <QJsonDocument>
#include "requestmanager.h"
#include "userinstant.h"
#include <QObject>
#include <QFile>
#include <QIODevice>
#include <QNetworkAccessManager>
#include <QNetworkConfiguration>
#include <QNetworkReply>
#include <QNetworkRequest>
#include <QHttpMultiPart>

class AcccauntManager : public QObject
{
    Q_OBJECT

private:
    RequestManager *h;

public:
    explicit AcccauntManager(QObject *parent = nullptr);



    void needLog(){

        if (UserInstant::getInstance()->appid == "none"){
            emit toQMLneedLogin();
        }else{
            h->enter();
            QObject::connect(h, SIGNAL(resultEnter(QJsonDocument)), this, SLOT(resultEnther(QJsonDocument)));
        }
    }

    void postPtotoAcc(){


        qDebug()<<"sendPh";

        QUrl url("http://127.0.0.1:8070/ebay/addIremFixPrice/");

        QNetworkAccessManager *manager = new QNetworkAccessManager(this);
        QNetworkRequest request(url);

        QFile *file = new QFile("/Users/administrator/build-myLIsting-Desktop_Qt_5_11_1_clang_64bit-Release/exmpl.jpg");


        QHttpMultiPart *multiPart = new QHttpMultiPart(QHttpMultiPart::FormDataType);

            QHttpPart textPart;
            textPart.setHeader(QNetworkRequest::ContentDispositionHeader, QVariant("form-data; name=\"photo\""));
            textPart.setBody("Pantallazo-10.jpg");

            QHttpPart textPart1;
            textPart1.setHeader(QNetworkRequest::ContentDispositionHeader, QVariant("form-data; name=\"AWSAccessKeyId\""));
            textPart1.setBody("myAccessKeyId");

            QHttpPart textPart2;
            textPart2.setHeader(QNetworkRequest::ContentDispositionHeader, QVariant("form-data; name=\"Policy\""));
            textPart2.setBody("myPolicy");

            QHttpPart textPart3;
            textPart3.setHeader(QNetworkRequest::ContentDispositionHeader, QVariant("form-data; name=\"Signature\""));
            textPart3.setBody("mySignature");

            QHttpPart imagePart;
            imagePart.setHeader(QNetworkRequest::ContentTypeHeader, QVariant("image/jpeg"));
            imagePart.setHeader(QNetworkRequest::ContentDispositionHeader, QVariant("multipart/form-data; name=\"files\"; filename=\"exmpl.lpeg\""));
            imagePart.setRawHeader("Content-Transfer-Encoding","binary");
//            QFile *file = new QFile(QDir::homePath() + "Pantallazo-10.jpg");
            if (file->open(QIODevice::ReadOnly)){

                imagePart.setBodyDevice(file);
    //            file->setParent(multiPart); // we cannot delete the file now, so delete it with the multiPart

                multiPart->append(textPart);
    //            multiPart->append(textPart1);
    //            multiPart->append(textPart2);
    //            multiPart->append(textPart3);
                multiPart->append(imagePart);


        manager->post(request, multiPart);
            }

        file->close();
    }


    void writeJsFile(QString nameFil, QVariantMap map);

signals:
    void toQMLLogin(QString result, QString eBayUrl);
    void toQmlRegistr(QString result);
    void toQmlExit();
    void toQmlGoodLogin();
    void toQMLneedLogin();
    void toQMLBadEbay();
    void toQMLshowMainView();
    void toQMLsendListing(QVariant data);
    void toQMLsendCategor(QVariant data);
    void toQMLErrorMessage(QString err);
    void toQMLendAddItem();
public slots:
    void saveAppId();
    void login(QString login, QString password);
    void registr(QString login, QString password, QString email);
    void resultLogin(QJsonDocument document);
    void resultREgistr(QJsonDocument document);
    void resultEbayAuth(QJsonDocument document);
    void getListing();
    void sendDataAddItemFixPriceeBay(QString title, QString discription, QString listImg, int category, QString price, QString count,  QString urlAliItem);
    void resultGetListing(QJsonDocument document);
    void resultEnther(QJsonDocument document);
    void resultAddingFixPriceeBay(QJsonDocument document);
    void getCategorys();
    void getItemAli(QString url);
};

#endif // ACCCAUNTMANAGER_H
