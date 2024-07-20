#include <QApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include "enose.h"

int main(int argc, char *argv[])
{
    QApplication app(argc, argv);

    //qmlRegisterType<Enose>("QmlCtrl", 1, 0, "Enose");


    QQmlApplicationEngine engine;
    QObject::connect(
        &engine,
        &QQmlApplicationEngine::objectCreationFailed,
        &app,
        []() { QCoreApplication::exit(-1); },
        Qt::QueuedConnection);
    engine.loadFromModule("QmlCtrl", "Main");

    Enose enose;
    QQmlContext *rootContext = engine.rootContext();
    rootContext->setContextProperty("enose", &enose);

    return app.exec();
}
