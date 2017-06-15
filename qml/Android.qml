import QtQuick 2.6
import QtQuick.Controls 2.1
import QtQuick.Layouts 1.3
import Qt.labs.settings 1.0

ColumnLayout {
    id: main
    anchors.rightMargin: 0
    anchors.bottomMargin: 0
    anchors.leftMargin: 0
    anchors.topMargin: 0
    anchors.fill: parent
    state: "game"

    property int winPos: -1
    property int selPos: -1
    property int best: 0
    property int score: 0

    RowLayout {
        id: rowLayout
        width: 100
        height: 100
        Layout.fillWidth: false
        Layout.alignment: Qt.AlignRight | Qt.AlignVCenter

        Label {
            id: scoreLabel
            color: "green"
            text: "score " + main.score
            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
        }

        Label {
            id: bestLabel
            color: "green"
            text: "best " + main.best
            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
        }
    }

    Image {
        id: image
        antialiasing: true
        sourceSize.width: main.width
        fillMode: Image.PreserveAspectFit
        Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
        Layout.fillHeight: true
        Layout.fillWidth: false
    }

    Button {
        id: buttonA
        Layout.fillWidth: true
        Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
        onClicked: {
            main.selPos = 0;
            main.state = main.winPos == 0 ? "win" : "lose";
        }
    }

    Button {
        id: buttonB
        Layout.fillWidth: true
        Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
        onClicked: {
            main.selPos = 1;
            main.state = main.winPos == 1 ? "win" : "lose";
        }
    }

    Button {
        id: buttonC
        Layout.fillWidth: true
        Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
        onClicked: {
            main.selPos = 2;
            main.state = main.winPos == 2 ? "win" : "lose";
        }
    }

    Button {
        id: buttonD
        Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
        Layout.fillWidth: true
        onClicked: {
            main.selPos = 3;
            main.state = main.winPos == 3 ? "win" : "lose";
        }
    }

    Timer {
        id: timer
        running: false
    }

    onStateChanged:
    {
        switch ( this.state )
        {
        case "game":
            var rpos     = function( v ){ return Math.floor(Math.random() * v.length); }
            var values   = []
            this.winPos = rpos([0, 1, 2, 3])
            for (var i = 0; i < 4;)
            {
                var r = rpos( this.images )
                if (values.indexOf(r) < 0)
                {
                    values[i] = r
                    this.buttons[i].text    = this.images[r]
                        .replace( /:\/[a-z]+\/([0-9a-zA-Z_-]+)\.png/, '$1' )
                        .replace( /_/, " " )
                    i++
                }
            }
            image.source = Qt.resolvedUrl( "qrc" + this.images[values[this.winPos]] )
            break;
        case "win":
            if (this.score > this.best)
                this.best = this.score
            break;
        default:
            ;
        }
    }

    readonly property var images: initImagesValue
    readonly property var buttons: [buttonA, buttonB, buttonC, buttonD]

    Settings {
        id: settings
        property alias best: main.best
    }

    states: [
        State {
            name: "game"
            PropertyChanges {
                target: timer
                running: false
            }
            PropertyChanges { target: buttonA; enabled: true; }
            PropertyChanges { target: buttonB; enabled: true; }
            PropertyChanges { target: buttonC; enabled: true; }
            PropertyChanges { target: buttonD; enabled: true; }
        },
        State {
            name: "win"
            PropertyChanges {
                target: timer
                running: true
                interval: 1000
                onTriggered: main.state = "game"
            }
            PropertyChanges {
                target: main.buttons[main.winPos].background
                color: "green"
            }
            PropertyChanges {
                target: main
                score: main.score + 1
                restoreEntryValues: false
                explicit: true
            }
            PropertyChanges {
                target: main
                best: if ( main.best < main.score ) main.score
                restoreEntryValues: false
                explicit: true
            }
            PropertyChanges { target: buttonA; enabled: false; }
            PropertyChanges { target: buttonB; enabled: false; }
            PropertyChanges { target: buttonC; enabled: false; }
            PropertyChanges { target: buttonD; enabled: false; }
        },
        State {
            name: "lose"
            PropertyChanges {
                target: timer
                running: true
                interval: 3000
                onTriggered: main.state = "game"
            }
            PropertyChanges {
                target: main.buttons[main.selPos].background
                color: "red"
            }
            PropertyChanges {
                target: main.buttons[main.winPos].background
                color: "green"
            }
            PropertyChanges { target: main; score: 0; restoreEntryValues: false; }
            PropertyChanges { target: scoreLabel; color: "red"; }
            PropertyChanges { target: buttonA; enabled: false; }
            PropertyChanges { target: buttonB; enabled: false; }
            PropertyChanges { target: buttonC; enabled: false; }
            PropertyChanges { target: buttonD; enabled: false; }
        }
    ]
}
