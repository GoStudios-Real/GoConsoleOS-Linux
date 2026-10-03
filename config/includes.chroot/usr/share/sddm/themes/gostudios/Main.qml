import QtQuick 2.15
import QtQuick.Controls 2.15

Rectangle {
    id: root
    width: 1920
    height: 1080
    color: "#0D0D14"

    Image {
        anchors.fill: parent
        source: "/usr/share/goconsole/wallpapers/goconsole-blue.png"
        fillMode: Image.PreserveAspectCrop
        opacity: 0.4
    }
    Rectangle { anchors.fill: parent; color: "#0D0D14"; opacity: 0.7 }

    Column {
        anchors.centerIn: parent
        spacing: 30
        Text {
            text: "GoConsoleOS"
            font.pixelSize: 72; font.bold: true
            color: "#0066FF"
            anchors.horizontalCenter: parent.horizontalCenter
        }
        Text {
            text: "GoStudios Corporation"
            font.pixelSize: 24; color: "#7A80A0"
            anchors.horizontalCenter: parent.horizontalCenter
        }
        Item { width: 1; height: 40 }
        Rectangle {
            width: 400; height: 56; color: "#1E2D42"
            border.color: "#2A3555"; border.width: 2; radius: 12
            anchors.horizontalCenter: parent.horizontalCenter
            TextInput {
                id: userField; anchors.fill: parent; anchors.margins: 4
                font.pixelSize: 18; color: "#F0F0FF"
                text: userModel.lastUser
                verticalAlignment: TextInput.AlignVCenter
            }
        }
        Rectangle {
            width: 400; height: 56; color: "#1E2D42"
            border.color: "#0066FF"; border.width: 2; radius: 12
            anchors.horizontalCenter: parent.horizontalCenter
            TextInput {
                id: passField; anchors.fill: parent; anchors.margins: 4
                font.pixelSize: 18; color: "#F0F0FF"
                echoMode: TextInput.Password
                verticalAlignment: TextInput.AlignVCenter
                Keys.onReturnPressed: sddm.login(userField.text, passField.text, 0)
            }
        }
        Rectangle {
            id: loginBtn; width: 400; height: 56; radius: 12
            color: ma.containsMouse ? "#3385FF" : "#0066FF"
            anchors.horizontalCenter: parent.horizontalCenter
            Text { anchors.centerIn: parent; text: "SIGN IN"; font.pixelSize: 20; font.bold: true; color: "white" }
            MouseArea {
                id: ma; anchors.fill: parent; hoverEnabled: true
                cursorShape: Qt.PointingHandCursor
                onClicked: sddm.login(userField.text, passField.text, 0)
            }
        }
    }
    Text {
        text: "USB-Powered Gaming Console"
        color: "#4A4A6A"; font.pixelSize: 14
        anchors { bottom: parent.bottom; bottomMargin: 30; left: parent.left; leftMargin: 40 }
    }
}
