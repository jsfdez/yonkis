import QtQuick 2.5
import QtQuick.Controls 1.4
import QtQuick.Layouts 1.2
import QtQuick.XmlListModel 2.0

Item {
    id: item1
    width: 640
    height: 480

    property alias model: listView.model;
    property alias delegate: listView.delegate;
    property alias username: username.text;
    property alias password: password.text;
    property alias address: address.text;
    property alias connectAutomatically: connectAutomatically.checked;
    property alias filter: filter.text;

    property alias connectButton: connect;

    ListView {
        id: listView
        anchors.rightMargin: 0
        anchors.leftMargin: 0
        anchors.bottomMargin: 0
        clip: true
        anchors.topMargin: 63
        anchors.fill: parent
    }

    TextField {
        id: username
        x: 8
        y: 35
        placeholderText: qsTr("User name")
    }

    TextField {
        id: password
        x: 141
        y: 35
        echoMode: 2
        placeholderText: qsTr("Password")
    }

    Button {
        id: connect
        x: 274
        y: 34
        text: qsTr("&Connect")
    }

    CheckBox {
        id: connectAutomatically
        x: 355
        y: 37
        text: qsTr("Connect automatically")
    }

    TextField {
        id: filter
        x: 505
        y: 35
        placeholderText: "Filter"
    }

    TextField {
        id: address
        x: 8
        y: 8
        width: 624
        height: 20
        placeholderText: qsTr("Address")
    }
}
