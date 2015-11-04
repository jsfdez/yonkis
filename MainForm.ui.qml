import QtQuick 2.5
import QtQuick.Controls 1.4
import QtQuick.Layouts 1.2
import QtQuick.XmlListModel 2.0

Item {
    id: item1
    width: 640
    height: 480

    property alias model: model

    ListView {
        id: listView
        anchors.fill: parent
        delegate: Item {
            x: 5
            width: 80
            height: 40
            Row {
                Text {
                    text: displayName
                    anchors.verticalCenter: parent.verticalCenter
                }
                spacing: 10
            }
        }
        model: XmlListModel {
            id: model
            source: "http://localhost:8080/api/xml?tree=jobs[*]"
            query: "/hudson/job"

            XmlRole { name: "displayName"; query: "displayName/string()" }
        }
    }
}
