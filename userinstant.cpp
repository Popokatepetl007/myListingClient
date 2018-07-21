#include "userinstant.h"
#include <QDebug>
#include <QFile>
#include <QJsonDocument>

UserInstant* UserInstant::instance = 0;

UserInstant* UserInstant::getInstance(){
    if (instance == 0){
        instance = new UserInstant();
    }

    return instance;
}

UserInstant::UserInstant(){
    qDebug()<<"i started";
    m_value = 800;
    QString fromFile;
    QFile *file = new QFile( "../../../setting.json");
    if (file->exists()){

        if (!file->open(QIODevice::ReadOnly | QIODevice::Text)){
            qDebug()<<"can't open file";
        }
        fromFile = file->readAll();
        file->close();

        QJsonDocument sd = QJsonDocument::fromJson(fromFile.toUtf8());
        qWarning() << sd.isNull();
        qDebug()<<sd;
        qDebug()<<sd["appid"].toString();
        appid = sd["appid"].toString();
        payPalmail = sd["paypalemail"].toString();
    } else{
        qDebug()<<"file not exist";
    }

//    appid = "6C4eBc7a";
    //appid = "7";
    eBaytoken = "none";
}
