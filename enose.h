#ifndef ENOSE_H
#define ENOSE_H

#include <QObject>
#include <QQmlEngine>
#include <QDebug>
#include <QBluetoothDeviceDiscoveryAgent>
#include <QLowEnergyController>
#include <QLowEnergyService>
#include <QLowEnergyCharacteristic>
#include <QStandardItem>
#include <QStandardItemModel>
#include <QTimer>
#include <QFile>
#include <QTextStream>
#include <QDir>
#include <QByteArray>
#include <QSplineSeries>
#include <QPointF>
#include <QDateTime>
#include <QSaveFile>
#include <QFuture>
#include <QtConcurrent>
#include "authhandler.h"

typedef struct {
    uint16_t time;
    uint16_t tgs2600;
    uint16_t tgs2602;
    uint16_t tgs2603;
    uint16_t tgs2610;
    uint16_t tgs2611;
    uint16_t tgs2620;
    uint16_t mq3;
    uint16_t mq7;
    uint16_t mq135;
}sensorReadings;

class Enose : public QObject
{
    Q_OBJECT
    QML_ELEMENT
    //Q_PROPERTY(QVariantMap mTGS2600 MEMBER tgs2600 READ getValTGS2600 NOTIFY tgs2600Changed)
    // too slow!!! can i take only the last value???

public:
    explicit Enose(QObject *parent = nullptr);
    Enose(const Enose &) = delete;
    Enose(Enose &&) = delete;
    Enose &operator=(const Enose &) = delete;
    Enose &operator=(Enose &&) = delete;
    QList<QPointF> TGS2600;
    QList<QPointF> TGS2602;
    QList<QPointF> TGS2603;
    QList<QPointF> TGS2610;
    QList<QPointF> TGS2611;
    QList<QPointF> TGS2620;
    QList<QPointF> MQ3;
    QList<QPointF> MQ7;
    QList<QPointF> MQ135;

public slots:
    void setEmail(QString msg);
    void setPassword(QString msg);
    void setIngredients(QString msg);
    void setTake(int msg);
    void setSignUp(int value);
    void setGetData(int value);
    void signInClicked();
    void signedIn();
    void errorSigninIn();
    void foundDevice(QBluetoothDeviceInfo dev);
    void btScanComplete();
    void connected();
    void servicesDiscovered();
    void signInSuccess();
    void serviceDetailsDiscovered();
    void processSample();
    void processing(uint16_t *sval, uint16_t *pval, uint16_t *ptime);
    void preStart();
    void start();
    void stop();
    void reset();
    void updateDB(QString brand);
    void saveReadingsLocally(QVariantMap beer);
    void resetPeaks();
    void parseData(QJsonDocument data);

private slots:
    void drinkBeer();

private:
    AuthHandler *authhandler;
    uint8_t signUp {0};
    uint8_t getData {0};
    QString email;
    QString password;
    QString ingredients;
    int take;
    QBluetoothDeviceDiscoveryAgent *discover;
    QLowEnergyController *leController;
    QLowEnergyService *service;
    QLowEnergyCharacteristic *readNose;
    QLowEnergyCharacteristic *writeNose;
    QLowEnergyDescriptor descriptor;
    QByteArray readArray;
    QPointF point;
    QString fetchKey();
    QList<QBluetoothUuid> uuids;
    QList<QLowEnergyCharacteristic> myCharacteristics;
    QList<QStandardItem*> entry;
    sensorReadings sample;
    sensorReadings peakValues;
    sensorReadings peakTimes;
    sensorReadings startValues;

    QFuture<void> t2600;

signals:
    void uiLabel(QString msg);
    void signedUp(QString msg);
    void signInerror(QString msg);
    void userSignedIn();
    void setupDone();
    void stopped();
    void tgs2600Changed(uint16_t num);
    void tgs2602Changed(uint16_t num);
    void tgs2603Changed(uint16_t num);
    void tgs2610Changed(uint16_t num);
    void tgs2611Changed(uint16_t num);
    void tgs2620Changed(uint16_t num);
    void mq3Changed(uint16_t num);
    void mq7Changed(uint16_t num);
    void mq135Changed(uint16_t num);
    void readingsMsg(QString msg);
};

#endif // ENOSE_H
