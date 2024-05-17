/*******************************************************************************
**
** Copyright (C) 2022 com.gitlab.danyok
**
** This file is part of the Youtube pwa для ОС Аврора project.
**
** Redistribution and use in source and binary forms,
** with or without modification, are permitted provided
** that the following conditions are met:
**
** * Redistributions of source code must retain the above copyright notice,
**   this list of conditions and the following disclaimer.
** * Redistributions in binary form must reproduce the above copyright notice,
**   this list of conditions and the following disclaimer
**   in the documentation and/or other materials provided with the distribution.
** * Neither the name of the copyright holder nor the names of its contributors
**   may be used to endorse or promote products derived from this software
**   without specific prior written permission.
**
** THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
** AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO,
** THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS
** FOR A PARTICULAR PURPOSE ARE DISCLAIMED.
** IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
** FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY,
** OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
** PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
** LOSS OF USE, DATA, OR PROFITS;
** OR BUSINESS INTERRUPTION)
** HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
** WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
** (INCLUDING NEGLIGENCE OR OTHERWISE)
** ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE,
** EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
**
*******************************************************************************/

import QtQuick 2.0
import Sailfish.Silica 1.0
import Sailfish.WebView 1.0
import Nemo.KeepAlive 1.2
import Amber.Mpris 1.0

Page {
    objectName: "mainPage"
    id:mainpage1
    allowedOrientations: Orientation.All

    DisplayBlanking {
        id: alwaysDisplay
        preventBlanking : true
    }

    Rectangle {
        id: upRect
        width: parent.width
        height: parent.height * 0.02
        anchors.top: parent.top
        color: "black"
        MouseArea {
            anchors.fill: upRect
            onClicked: {
                webView1.goForward();
            }
        }
    }

    Rectangle {
        id: rect1
        width: parent.width
        height: parent.height * 0.96
        anchors.top: upRect.bottom

        WebView {
            id: webView1
             anchors.fill: rect1
             url: "https://192.168.56.1:8443"
             httpUserAgent : "Mozilla/5.0 (Android 8.1.0; Mobile; rv:78.0) Gecko/78.0 Firefox/78.0"
             viewportHeight: parent.height
        }

    }

    Rectangle {
        id: downRect
        width: parent.width
        anchors.top: rect1.bottom
        anchors.bottom: parent.bottom
        color: "black"
        MouseArea {
            anchors.fill: downRect
            onClicked: {
                if(webView1.url == "https://192.168.56.1:8443") {
                } else {
                    webView1.goBack();
                }
            }
        }
    }

    MprisPlayer {
        id: mprisPlayer

        serviceName: "ytpwa"
        identity: "ytpwa"

        canControl: true

        canGoNext: false
        canGoPrevious: false
        canPause: true
        canPlay: true
        canSeek: false

        property bool player: true

        playbackStatus: player ? Mpris.Playing : Mpris.Paused

        onPlayPauseRequested: {
            if (player) {
                console.log("pause")
                webView1.runJavaScript("document.getElementsByTagName('video')[0].pause()")
                player = false
            } else {
                console.log("play")
                webView1.runJavaScript("document.getElementsByTagName('video')[0].play()")
                player = true
            }
        }
    }


    Connections {
            target: Qt.application
            onActiveChanged : {
                if( Qt.application.active ) {
                    alwaysDisplay.preventBlanking = true
                }
                else {
                    alwaysDisplay.preventBlanking = false
                    webView1.active = true
                    webView1.runJavaScript("return document.title", function(result) { mprisPlayer.metaData.title = result; });
                }
            }
      }

}
