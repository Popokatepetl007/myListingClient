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
    int offset;
    static UserInstant* getInstance();
};

#endif // USERINSTANT_H
