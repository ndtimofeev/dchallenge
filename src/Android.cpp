// Core
#include <QDebug>
#include <QDir>

// Gui
#include <QGuiApplication>

// QML
#include <QQmlApplicationEngine>
#include <QQmlComponent>
#include <QQmlContext>
#include <QQmlEngine>
#include <QQmlProperty>

// Quick
#include <QQuickItem>
#include <QQuickView>

int main(int argc, char *argv[])
{
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
    QGuiApplication app(argc, argv);
    app.setObjectName("KBForest");
    app.setApplicationName("Drugs Challenge");

    QDir dir( ":/files" );
    QList<QFileInfo> variants = dir.entryInfoList( { "*.png" }, QDir::Files | QDir::Readable );
    QStringList slist;

    for ( auto f : variants )
        slist << f.absoluteFilePath();

    QQuickView view;
    view.rootContext()->setContextProperty( "initImagesValue", slist );
    view.setSource( QUrl( "qrc:/qml/Android.qml" ) );
    view.show();

    return app.exec();
}
