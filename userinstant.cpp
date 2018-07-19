#include "userinstant.h"
#include <QDebug>

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
    appid = "6C4eBc7a";
    //appid = "7";
    eBaytoken = "none";
}
