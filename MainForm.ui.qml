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
    property alias connectAutomatically: connectAutomatically.checked;
    property alias filter: filter.text;

    property alias connectButton: connect;

    ListView {
        id: listView
        clip: true
        anchors.topMargin: 34
        anchors.fill: parent
    }

    TextField {
        id: username
        x: 8
        y: 8
        placeholderText: qsTr("User name")
    }

    TextField {
        id: password
        x: 141
        y: 8
        echoMode: 2
        placeholderText: qsTr("Password")
    }

    Button {
        id: connect
        x: 274
        y: 7
        text: qsTr("&Connect")
    }

    CheckBox {
        id: connectAutomatically
        x: 355
        y: 10
        text: qsTr("Connect automatically")
    }

    TextField {
        id: filter
        x: 505
        y: 8
        placeholderText: "Filter"
    }
}
