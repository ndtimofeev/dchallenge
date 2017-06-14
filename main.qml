import QtQuick 2.7
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.3

ApplicationWindow {
    visible: true
    title: qsTr("Drugs Challenge")

    ColumnLayout {
        id: columnLayout
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
                id: score
                text: "score " + columnLayout.score
                Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
            }

            Label {
                id: best
                text: "best " + columnLayout.best
                Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
            }
        }

        Image {
            id: image
            antialiasing: true
            sourceSize.width: columnLayout.width
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
                columnLayout.selPos = 0;
                columnLayout.state = columnLayout.winPos == 0 ? "win" : "lose";
            }
        }

        Button {
            id: buttonB
            Layout.fillWidth: true
            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
            onClicked: {
                columnLayout.selPos = 1;
                columnLayout.state = columnLayout.winPos == 1 ? "win" : "lose";
            }
        }

        Button {
            id: buttonC
            Layout.fillWidth: true
            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
            onClicked: {
                columnLayout.selPos = 2;
                columnLayout.state = columnLayout.winPos == 2 ? "win" : "lose";
            }
        }

        Button {
            id: buttonD
            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
            Layout.fillWidth: true
            onClicked: {
                columnLayout.selPos = 3;
                columnLayout.state = columnLayout.winPos == 3 ? "win" : "lose";
            }
        }


        Timer {
            id: timer
            running: false
            interval: 1500
            onTriggered: { columnLayout.state = "game" }
        }

        onStateChanged:
        {
            switch ( this.state )
            {
            case "game":
                var variants =
                        [ "files/25b-nboh.png"
                         , "files/25b-nbome.png"
                         , "files/25c-nboh.png"
                         , "files/25c-nbome.png"
                         , "files/25i-nboh.png"
                         , "files/25i-nbome.png"
                         , "files/25n-nbome.png"
                         , "files/2c-b.png"
                         , "files/2c-c.png"
                         , "files/2c-i.png"
                         , "files/2c-n.png"
                         , "files/2c-t-2.png"
                         , "files/2c-t-7.png"
                         , "files/adrenaline.png"
                         , "files/aminazine.png"
                         , "files/amphetamine.png"
                         , "files/aspirin.png"
                         , "files/bufotenin.png"
                         , "files/caffeine.png"
                         , "files/cocaine.png"
                         , "files/DMT.png"
                         , "files/DOB.png"
                         , "files/DOI.png"
                         , "files/DOM.png"
                         , "files/dopamine.png"
                         , "files/DXM.png"
                         , "files/ephedrin.png"
                         , "files/ergotamine.png"
                         , "files/heroine.png"
                         , "files/ketamine.png"
                         , "files/LSD.png"
                         , "files/Lysergic_acid.png"
                         , "files/MDA.png"
                         , "files/MDMA.png"
                         , "files/melatonin.png"
                         , "files/mephedrone.png"
                         , "files/mescaline.png"
                         , "files/methamphetamine.png"
                         , "files/methoxetamine.png"
                         , "files/morphine.png"
                         , "files/noradrenaline.png"
                         , "files/o-acetylpsilocin.png"
                         , "files/psilocin.png"
                         , "files/psilocybn.png"
                         , "files/r-bromo-dragonfly.png"
                         , "files/Salvinorin_A.png"
                         , "files/serotonin.png"
                         , "files/sildenafil.png"
                         , "files/tetrahydrocannabinol.png"
                         , "files/TMA-2.png"
                         , "files/TMA-6.png"
                         , "files/TMA.png"
                         , "files/tryptamine.png"
                         , "files/veronal.png" ]

                var rpos     = function( v ){ return Math.floor(Math.random() * v.length); }
                var re       = /[a-z]+\/([0-9a-zA-Z_-]+)\.png/
                var values   = []
                var color    = "gray"

                for (var i = 0; i < 4; i++)
                {
                    if ( i != this.winPos && i != this.selPos )
                    {
                        color = buttons[i].background.color
                        break
                    }
                }

                this.winPos = rpos([0, 1, 2, 3])

                for (var i = 0; i < 4;)
                {
                    var r = rpos( variants )
                    if (values.indexOf(r) < 0)
                    {
                        values[i] = r
                        this.buttons[i].enabled = true
                        this.buttons[i].text = variants[r].replace( re, '$1' ).replace( /_/, " " )
                        this.buttons[i].background.color = color
                        //                        this.buttons[i].onClicked.connect( i == this.winPos ? toWin : toLose )
                        i++
                    }
                }
                image.source = Qt.resolvedUrl( variants[values[this.winPos]] )

                break;
            case "win":
                this.score += 1
                if (this.score > this.best)
                    this.best = this.score

                this.buttons[this.winPos].background.color = "green"
                for (var i = 0; i < 4; i++)
                    this.buttons[i].enabled = false
                break;
            case "lose":
                this.score = 0
                this.buttons[this.winPos].background.color = "green";
                this.buttons[this.selPos].background.color = "red";
                for (var i = 0; i < 4; i++)
                    this.buttons[i].enabled = false
                break;
            default:
                console.log( this.state )
                console.log( winPos )
                console.log( selPos )
            }
        }

        property var buttons: [buttonA, buttonB, buttonC, buttonD]

        states: [
            State {
                name: "game"
                PropertyChanges {
                    target: timer
                    running: false
                }
            },
            State {
                name: "win"
                PropertyChanges {
                    target: timer
                    running: true
                }
            },
            State {
                name: "lose"
                PropertyChanges {
                    target: timer
                    running: true
                }
            }
        ]
    }
}
