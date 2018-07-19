#ifndef MAINWORK_H
#define MAINWORK_H

#include <QObject>
#include <QGuiApplication>
#include <QQmlApplicationEngine>

class MainWork : public QObject
{
    Q_OBJECT
public:
    explicit MainWork(QObject *parent = nullptr);
    void start(QQmlApplicationEngine *engine);

signals:

public slots:
};

#endif // MAINWORK_H
