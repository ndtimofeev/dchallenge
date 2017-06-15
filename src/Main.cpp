// std
#include <memory>

// Core
#include <QAbstractTransition>
#include <QDir>
#include <QDebug>
#include <QTime>
#include <QTimer>
#include <QSignalTransition>
#include <QState>
#include <QStateMachine>

// Widgets
#include <QApplication>
#include <QMainWindow>

// ui
#include "ui_DChallenge.h"

int main( int argc, char** argv )
{
    QApplication app( argc, argv );

    // Initialize
        qsrand( (uint)QTime::currentTime().msec() );

        QDir dir( "files" );
        QList<QFileInfo> variants = dir.entryInfoList( { "*.png" }, QDir::Files | QDir::Readable );

        if ( variants.size() < 4 )
            return 1;

        QStateMachine sm;
        QState* gameState = new QState();
        QState* winState  = new QState();
        QState* loseState = new QState();

        sm.addState( gameState );
        sm.addState( winState );
        sm.addState( loseState );
        sm.setInitialState( gameState );
        sm.setGlobalRestorePolicy( QState::RestoreProperties );
        sm.start();

        QMainWindow mw;
        Ui_MainWindow ui;
        ui.setupUi( &mw );

        int winPos        = -1;
        int selPos        = -1;
        int maxSuccessNum = 0;
        int successNum    = 0;

        QTimer timer;
        timer.setInterval( 3000 );
        timer.setSingleShot( true );

        winState->addTransition( &timer, &QTimer::timeout, gameState );
        loseState->addTransition( &timer, &QTimer::timeout, gameState );

        QList<QPushButton*> buttons = { ui.pushButton_a, ui.pushButton_b, ui.pushButton_c, ui.pushButton_d };

        for ( auto i : { 0, 1, 2, 3 } )
        {
            auto button = buttons.at( i );
            gameState->assignProperty( button, "enabled", true );
            QObject::connect( button, &QAbstractButton::clicked,
                [&selPos, i]()
                {
                    selPos = i;
                }
            );
        }

        mw.show();

        QObject::connect( loseState, &QState::entered,
            [&]()
            {
                mw.statusBar()->showMessage( "Nope!" );
                buttons.at( selPos )->setPalette( Qt::red );
                buttons.at( winPos )->setPalette( Qt::green );
                successNum = 0;
                ui.suc_num->display( successNum );
                timer.start();
            }
        );

        QObject::connect( winState, &QState::entered,
            [&]()
            {
                mw.statusBar()->showMessage( "Yep!" );
                buttons.at( winPos )->setPalette( Qt::green );
                successNum += 1;
                if ( maxSuccessNum < successNum )
                    maxSuccessNum = successNum;
                ui.suc_num->display( successNum );
                ui.max_suc_num->display( maxSuccessNum );
                timer.start();
            }
        );

        QObject::connect( gameState, &QState::entered,
            [&]()
            {
                mw.statusBar()->clearMessage();

                QVector<int> vec;
                QVector<QSignalTransition*> trans;

                while ( vec.size() != 4 )
                {
                    int val = qrand() % variants.size();
                    if ( ! vec.contains( val ) )
                        vec << val;
                }

                winPos = qrand() % vec.size();
                int win = vec.at( winPos );

                ui.label->setPixmap( variants.at( win ).absoluteFilePath() );

                for ( auto i : { 0, 1, 2, 3 } )
                {
                    auto button = buttons.at( i );
                    button->setText( variants.at( vec.at( i ) ).baseName() );
                    button->setPalette( QPalette() );
                    trans << gameState->addTransition(
                        button,
                        &QAbstractButton::clicked,
                        vec.at( i ) == win ? winState : loseState );
                }

                auto conn = std::make_shared<QMetaObject::Connection>();
                *conn = QObject::connect( gameState, &QState::exited,
                    [=]()
                    {
                        for ( auto tr : trans )
                            gameState->removeTransition( tr );

                        QObject::disconnect( *conn );

                    }
                );
            }
        );

    return app.exec();
}
