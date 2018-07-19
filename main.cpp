#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include "requestmanager.h"
#include "mainwork.h"
#include "userinstant.h"
#include <qtwebengineglobal.h>
#include <QFile>
#include <QIODevice>
#include <QJsonDocument>
#include <QDir>



int main(int argc, char *argv[])
{
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);

    QGuiApplication app(argc, argv);
    QtWebEngine::initialize();

    QQmlApplicationEngine *engine = new QQmlApplicationEngine;

    MainWork main;
    UserInstant::getInstance()->m_value=999;
    main.start(engine);





    return app.exec();

}
