#ifndef REQUESTMANAGER_H
#define REQUESTMANAGER_H

#include <QObject>
#include <QNetworkAccessManager>
#include <QDebug>
#include <QNetworkReply>
#include <QByteArray>
#include <QNetworkRequest>
#include <QTextCodec>
#include <QJsonDocument>
#include <QJsonObject>
#include <QJsonArray>
#include <QFile>

class RequestManager : public QObject
{
    Q_OBJECT

private:
    QNetworkAccessManager *manager;
    QNetworkReply *replyAcc;
    QNetworkReply *replLong;
    QNetworkRequest createRequest(QUrl url);
    QString host;
    void redirAcc(){
        QUrl newUrl = replyAcc->attribute(QNetworkRequest::RedirectionTargetAttribute).toUrl();
        qDebug()<<newUrl;
        newUrl = replyAcc->url().resolved(newUrl);
        QNetworkRequest redir(newUrl);
        replyAcc->manager()->get(redir);
        //qDebug()<<codR<< newUrl;
    }

public:
    explicit RequestManager(QObject *parent = nullptr);
    void auth(QString login, QString password);
    void registr(QString login, QString password, QString email);
    void enter();
    void exit();
    void waitToken();
    void getListingreq();
    void postPhoto();
    void itemFromAli(QString url);
    void addFixPriceeBayReqest(QString title, QString discription, QString listImg, int category, QString price, QString count, QString urlAliItem);

signals:
    void resultAuth(QJsonDocument t);
    void resultEnter(QJsonDocument t);
    void resultRegstr(QJsonDocument t);
    void resultAuthEbay(QJsonDocument t);
    void resultgetListing(QJsonDocument t);
    void resultAddFixPrice(QJsonDocument t);
public slots:
    void replyEnterEBay();
    void replyEnter();
    void replyAuth();
    void replyRgstr();
    void replRead();
    void replExit();
    void replListing();
    void repAddFixPriceeBay();
    void replyItemAli();
    void tete(qint64 a, qint64 b){
        qDebug()<<"upProc";
        qDebug()<<a;
        qDebug()<<b;
    }
};

#endif // REQUESTMANAGER_H
