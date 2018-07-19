#include "mainwork.h"
#include <QQmlApplicationEngine>
#include <QGuiApplication>
#include <QQmlContext>
#include <QFile>
#include <QDir>
#include "requestmanager.h"
#include "userinstant.h"
#include "acccauntmanager.h"

MainWork::MainWork(QObject *parent) : QObject(parent)
{


}

void MainWork::start(QQmlApplicationEngine *engine)
{

    AcccauntManager *account= new AcccauntManager;

    QQmlContext *context = engine->rootContext();

    context->setContextProperty("delegateAcc", account);
    engine->load(QUrl(QStringLiteral("qrc:/main.qml")));
    if (engine->rootObjects().isEmpty()){

    }

//    account->getItemAli("https://ru.aliexpress.com/item/Best-Selling-10-Pieces-Pack-juniper-bonsai-tree-potted-flowers-office-bonsai-purify-the-air-absorb/32470856363.html?spm=2114.search0104.3.46.7e292a744NmIuv&ws_ab_test=searchweb0_0,searchweb201602_2_10152_10151_10065_10068_10344_10342_10325_10546_10343_10340_10548_10341_5723217_10696_10084_10083_10618_10307_10059_100031_10103_10624_10623_10622_10621_10620,searchweb201603_12,ppcSwitch_7&algo_expid=0b2fb135-face-4c75-92d9-4fbfafb2cca7-6&algo_pvid=0b2fb135-face-4c75-92d9-4fbfafb2cca7&transAbTest=ae803_1&priceBeautifyAB=0");
//    account->postPtotoAcc();
    account->needLog();



}
