#include <QApplication>
#include <QNetworkReply>
#include <QAuthenticator>
#include <QQmlApplicationEngine>
#include <QNetworkAccessManager>

int main(int argc, char *argv[])
{
	QApplication app(argc, argv);

	QQmlApplicationEngine engine;

	const auto callback = []()
	{
		qDebug() << "Authentication Required";
	};

	QObject::connect(engine.networkAccessManager(),
		&QNetworkAccessManager::authenticationRequired, callback);

	engine.load(QUrl(QStringLiteral("qrc:/main.qml")));

	return app.exec();
}

