#ifndef AUTHHANDLER_H
#define AUTHHANDLER_H

#include <QObject>
#include <QQmlEngine>
#include <QNetworkAccessManager>
#include <QNetworkReply>
#include <QJsonDocument>
#include <QDebug>
#include <QVariantMap>
#include <QNetworkRequest>
#include <QJsonObject>

class AuthHandler : public QObject
{
    Q_OBJECT
    QML_ELEMENT
public:
    explicit AuthHandler(QString key, QObject *parent = nullptr);
    ~AuthHandler();
    void signUserUp(const QString & emailAddress, const QString & password);
    void signUserIn(const QString & emailAddress, const QString & password);
    void add_to_db(QVariantMap readings);

public slots:
    void networkReplyReadyRead();
    void getData();

private:
    void performPOST(const QString & url, const QJsonDocument & payload);
    void parseResponse(const QByteArray & reponse);
    QNetworkAccessManager *m_networkAccessManager;
    QNetworkReply *m_networkReply;
    QString m_idToken;
    QString m_apiKey;
    QJsonDocument dbEntries;

signals:
    void userSignedIn();
    void signInError();
    void dataReady(QJsonDocument);
};

#endif // AUTHHANDLER_H
