#include "enose.h"

Enose::Enose(QObject *parent)
    : QObject{parent}
{
    authhandler = new AuthHandler(fetchKey());
    connect(authhandler, &AuthHandler::userSignedIn, this, &Enose::signInSuccess);
    connect(authhandler, &AuthHandler::signInError, this, &Enose::errorSigninIn);
    connect(authhandler, &AuthHandler::dataReady, this, &Enose::parseData);
    qRegisterMetaType<uint16_t>("uint16_t");
    resetPeaks();
}

void Enose::setEmail(QString msg)
{
    email = msg;
}

void Enose::setPassword(QString msg)
{
    password = msg;
}

void Enose::setIngredients(QString msg)
{
    ingredients = msg;
}

void Enose::setTake(int msg)
{
    take = msg;// * 1;
}

void Enose::setSignUp(int value)
{
    signUp = value;
}

void Enose::setGetData(int value)
{
    getData = value;
}



void Enose::signInClicked()
{
    switch (signUp){
    case 0:
        authhandler->signUserIn(email, password);
        break;
    case 1:
        authhandler->signUserUp(email, password);
        break;
    }
}

void Enose::signedIn()
{
    if(getData){
        authhandler->getData();
    }
    emit uiLabel("welcome " + email);
    discover = new QBluetoothDeviceDiscoveryAgent(this);
    connect(discover, SIGNAL(deviceDiscovered(QBluetoothDeviceInfo)), this, SLOT(foundDevice(QBluetoothDeviceInfo)));
    connect(discover, SIGNAL(finished()), this, SLOT(btScanComplete()));
    discover->start(QBluetoothDeviceDiscoveryAgent::LowEnergyMethod);
}

void Enose::errorSigninIn()
{
    emit signInerror("check email & password");
}

void Enose::foundDevice(QBluetoothDeviceInfo device)
{
    if (device.name() == "eNose"){
        QTimer::singleShot(1000, this, &Enose::drinkBeer);
        discover->stop();
        leController = QLowEnergyController::createCentral(device, this);
        connect(leController, &QLowEnergyController::connected, this, &Enose::connected);
        connect(leController, &QLowEnergyController::discoveryFinished, this, &Enose::servicesDiscovered);
        leController->connectToDevice();
    }
}

void Enose::btScanComplete()
{
    emit uiLabel("eNose not found. Retrying...");
    discover->setLowEnergyDiscoveryTimeout(10000);
    discover->start(QBluetoothDeviceDiscoveryAgent::LowEnergyMethod);
}

void Enose::connected()
{
    leController->discoverServices();
}

void Enose::servicesDiscovered()
{
    for (QBluetoothUuid _ : leController->services()){
        uuids.append(_);
    }
    qDebug() << uuids;
    QBluetoothUuid uuid = uuids.first();
    service = leController->createServiceObject(uuid);
    connect(service, &QLowEnergyService::stateChanged, this, &Enose::serviceDetailsDiscovered);
    service->discoverDetails();
}

void Enose::drinkBeer()
{
    emit uiLabel("have a beer while we get things ready");
}

QString Enose::fetchKey()
{
    /*QFile file("C:/Users/basee/OneDrive/Documents/EnoseQml/eNose.txt");
    if(!file.open(QIODevice::ReadOnly | QIODevice::Text)){
        qDebug() << "check file path";
    }
    QTextStream in(&file);
    QString key = in.readLine();*/
    QString key = "";
    QDir *dir = new QDir("QmlCtrl");
    if (!dir->exists()){
        qWarning() << "Key text not found";
    } else {
        for (auto e : dir->entryList()){
            if (e == "eNose.txt") {
                //key = it->absoluteFilePath(e);
                QFile file(dir->absoluteFilePath(e));
                if(!file.open(QIODevice::ReadOnly | QIODevice::Text)){
                    qDebug() << "check file path";
                }
                QTextStream in(&file);
                key = in.readLine();
            }
        }
    }
    return key;
}

void Enose::signInSuccess()
{
    switch(signUp){
    case 0:
        emit userSignedIn();
        signedIn();
        break;
    case 1:
        emit signedUp(email + " created...");
        break;
    }
}

void Enose::serviceDetailsDiscovered()
{
    switch (service->state()) {
    case QLowEnergyService::RemoteServiceDiscovering:
        break;
    case QLowEnergyService::RemoteServiceDiscovered:
        myCharacteristics = service->characteristics();
        readNose = &(myCharacteristics.first());
        writeNose = &(myCharacteristics.last());
        *readNose = service->characteristic(readNose->uuid());
        *writeNose = service->characteristic(writeNose->uuid());
        descriptor = readNose->descriptor(QBluetoothUuid::DescriptorType::ClientCharacteristicConfiguration);
        connect(service, &QLowEnergyService::characteristicChanged, this, &Enose::processSample);
        emit setupDone();
    default:
        break;
    }
}

void Enose::processSample()
{
    readArray = readNose->value();
    QDataStream stream(&readArray, QIODeviceBase::ReadOnly);
    stream.setByteOrder(QDataStream::LittleEndian);

    stream >> sample.time;
    stream >> sample.tgs2600;
    stream >> sample.tgs2602;
    stream >> sample.tgs2603;
    stream >> sample.tgs2610;
    stream >> sample.tgs2611;
    stream >> sample.tgs2620;
    stream >> sample.mq3;
    stream >> sample.mq7;
    stream >> sample.mq135;

    //processing(&sample.tgs2600, &peakValues.tgs2600, &peakTimes.tgs2600);
    QFuture<void> t2600 = QtConcurrent::run( [this]{
        processing(&sample.tgs2600, &peakValues.tgs2600, &peakTimes.tgs2600);
        emit tgs2600Changed(sample.tgs2600);
    });
    TGS2600.append(point);
    //processing(&sample.tgs2602, &peakValues.tgs2602, &peakTimes.tgs2602);
    QFuture<void> t2602 = QtConcurrent::run( [this]{
        processing(&sample.tgs2602, &peakValues.tgs2602, &peakTimes.tgs2602);
        emit tgs2602Changed(sample.tgs2602);
    });
    TGS2602.append(point);
    //processing(&sample.tgs2603, &peakValues.tgs2603, &peakTimes.tgs2603);
    QFuture<void> t2603 = QtConcurrent::run( [this]{
        processing(&sample.tgs2603, &peakValues.tgs2603, &peakTimes.tgs2603);
        emit tgs2603Changed(sample.tgs2603);
    });
    TGS2603.append(point);
    //processing(&sample.tgs2610, &peakValues.tgs2610, &peakTimes.tgs2610);
    QFuture<void> t2610 = QtConcurrent::run( [this]{
        processing(&sample.tgs2610, &peakValues.tgs2610, &peakTimes.tgs2610);
        emit tgs2610Changed(sample.tgs2610);
    });
    TGS2610.append(point);
    //processing(&sample.tgs2611, &peakValues.tgs2611, &peakTimes.tgs2611);
    QFuture<void> t2611 = QtConcurrent::run( [this]{
        processing(&sample.tgs2611, &peakValues.tgs2611, &peakTimes.tgs2611);
        emit tgs2611Changed(sample.tgs2611);
    });
    TGS2611.append(point);
    //processing(&sample.tgs2620, &peakValues.tgs2620, &peakTimes.tgs2620);
    QFuture<void> t2620 = QtConcurrent::run( [this]{
        processing(&sample.tgs2620, &peakValues.tgs2620, &peakTimes.tgs2620);
        emit tgs2620Changed(sample.tgs2620);
    });
    TGS2620.append(point);
    //processing(&sample.mq3, &peakValues.mq3, &peakTimes.mq3);
    QFuture<void> tm3 = QtConcurrent::run( [this]{
        processing(&sample.mq3, &peakValues.mq3, &peakTimes.mq3);
        emit mq3Changed(sample.mq3);
    });
    MQ3.append(point);
    //processing(&sample.mq7, &peakValues.mq7, &peakTimes.mq7);
    QFuture<void> tm7 = QtConcurrent::run( [this]{
        processing(&sample.mq7, &peakValues.mq7, &peakTimes.mq7);
        emit mq7Changed(sample.mq7);
    });

    MQ7.append(point);
    //processing(&sample.mq135, &peakValues.mq135, &peakTimes.mq135);
    QFuture<void> ___ = QtConcurrent::run( [this]{ processing(&sample.mq135, &peakValues.mq135, &peakTimes.mq135);});
    emit mq135Changed(sample.mq135);
    MQ135.append(point);

    if (sample.time == 0) {
        startValues = peakValues;
    }
    if (sample.time == 999) {
        stop();
    }
}

void Enose::processing(uint16_t *sval, uint16_t *pval, uint16_t *ptime)
{
    if(*pval < *sval){
        *pval = *sval;
        *ptime = sample.time;
    }
    point.setX(sample.time);
    point.setY(*sval);

}

void Enose::preStart()
{

}

void Enose::start()
{
    qDebug() << __func__;
    TGS2600.clear(); TGS2602.clear(); TGS2603.clear(); TGS2610.clear();
    TGS2611.clear(); TGS2620.clear(); MQ3.clear(); MQ7.clear(); MQ135.clear();
    service->writeDescriptor(descriptor, QByteArray::fromHex("0100"));
    service->writeCharacteristic(*writeNose, QByteArray::fromStdString("Run"));
    //QTimer::singleShot(10000, this, &Enose::stop);
}

void Enose::stop()
{
    qDebug() << __func__;
    service->writeCharacteristic(*writeNose, QByteArray::fromStdString("Stop"));
    service->writeDescriptor(descriptor, QByteArray::fromHex("0000"));
    emit stopped();
}

void Enose::reset()
{
    qDebug() << __func__;
    //service->writeDescriptor(descriptor, QByteArray::fromHex("0000"));
    stop();
}

void Enose::updateDB(QString brand)
{
    QVariantMap beer;
    QDateTime timestamp = QDateTime::currentDateTime();
    beer["Beer"] = brand + timestamp.toString("yy-MM-dd hh:mm:ss");
    beer["Take"] = take;
    beer["Ingredients"] = ingredients;
    beer["tgs2600_peak_value"] = peakValues.tgs2600;
    beer["tgs2600_abs_value"] = peakValues.tgs2600 - startValues.tgs2600;
    beer["tgs2600_time"] = peakTimes.tgs2600;
    beer["tgs2602_peak_value"] = peakValues.tgs2602;
    beer["tgs2602_abs_value"] = peakValues.tgs2602 - startValues.tgs2602;
    beer["tgs2602_time"] = peakTimes.tgs2602;
    beer["tgs2603_peak_value"] = peakValues.tgs2603;
    beer["tgs2603_abs_value"] = peakValues.tgs2603 - startValues.tgs2603;
    beer["tgs2603_time"] = peakTimes.tgs2603;
    beer["tgs2610_paek_value"] = peakValues.tgs2610;
    beer["tgs2610_abs_value"] = peakValues.tgs2610 - startValues.tgs2610;
    beer["tgs2610_time"] = peakTimes.tgs2610;
    beer["tgs2611_peak_value"] = peakValues.tgs2611;
    beer["tgs2611_value"] = peakValues.tgs2611 - startValues.tgs2611;
    beer["tgs2611_time"] = peakTimes.tgs2611;
    beer["tgs2620_peak_value"] = peakValues.tgs2620;
    beer["tgs2620_abs_value"] = peakValues.tgs2620 - startValues.tgs2620;
    beer["tgs2620_time"] = peakTimes.tgs2620;
    beer["mq3_peak_value"] = peakValues.mq3;
    beer["mq3_abs_value"] = peakValues.mq3 - startValues.mq3;
    beer["mq3_time"] = peakTimes.mq3;
    beer["mq7_peak_value"] = peakValues.mq7;
    beer["mq7_abs_value"] = peakValues.mq7 - startValues.mq7;
    beer["mq7_time"] = peakTimes.mq7;
    beer["mq135_peak_value"] = peakValues.mq135;
    beer["mq135_abs_value"] = peakValues.mq135 - startValues.mq135;
    beer["mq135_time"] = peakTimes.mq135;
    authhandler->add_to_db(beer);
    reset();

    QFuture<void> future = QtConcurrent::run( [this, beer]{ saveReadingsLocally(beer);});
    //saveReadingsLocally(beer);
    emit readingsMsg("posted to db");
}

void Enose::saveReadingsLocally(QVariantMap beer)
{
    QFile dump("C:\\Users\\basee\\OneDrive\\Documents\\QmlCtrl\\fileDump.txt");
    if(dump.open(QIODevice::WriteOnly | QIODevice::Append | QIODevice::Text)) {
        QByteArray newData = QJsonDocument::fromVariant(beer).toJson();
        dump.write(newData);
        dump.close();
    }
}

void Enose::resetPeaks()
{
    peakValues.tgs2600 = peakValues.tgs2602 = peakValues.tgs2603 = peakValues.mq135 = 0;
    peakValues.tgs2610 = peakValues.tgs2611 = peakValues.tgs2620 = peakValues.mq3 = peakValues.mq7 = 0;
}

void Enose::parseData(QJsonDocument data)
{
    QFile file("C:\\Users\\basee\\OneDrive\\Documents\\QmlCtrl\\data.json");
    if(!file.open(QIODevice::WriteOnly))
        qWarning() << "Unable to create file";
    file.write(data.toJson());
    file.close();
}
