#ifndef USERINSTANT_H
#define USERINSTANT_H

#include <QString>

class UserInstant
{
private:
    static UserInstant* instance;
    UserInstant();
public:
    QString appid;
    QString eBaytoken;
    QString payPalmail;
    int m_value;
    static UserInstant* getInstance();
};

#endif // USERINSTANT_H
