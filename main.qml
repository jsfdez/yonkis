import QtQuick 2.5
import QtQuick.LocalStorage 2.0
import QtQuick.Controls 1.4
import QtQuick.Dialogs 1.2
import QtQuick.XmlListModel 2.0
import QtQuick.Extras 1.4

ApplicationWindow {
    visible: true
    width: 640
    height: 480
    title: qsTr("Yonkis")

    function httpPost(theUrl, Params)
    {
        var xmlHttp = null;
        xmlHttp = new XMLHttpRequest();
        alert(Params);
        xmlHttp.open("GET", theUrl, false);
        xmlHttp.setRequestHeader('User-Agent', 'Mozilla/5.0 (Windows NT 6.1; WOW64; rv:31.0) Gecko/20130401 Firefox/31.0');
        xmlHttp.setRequestHeader('Accept', 'text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8');
        xmlHttp.setRequestHeader('Accept-Language', 'en-US,en;q=0.5');
        xmlHttp.setRequestHeader('Authorization', 'Basic ' + Qt.btoa(form.username + ':' + form.password));
        xmlHttp.setRequestHeader('Content-type', 'application/x-www-form-urlencoded; charset=UTF-8');
        xmlHttp.send( Params );
        return xmlHttp.responseText;
    }

    function getDatabase() {
         return LocalStorage.openDatabaseSync("yonkis", "0.1", "Yonkis database", 100);
    }

    function set(setting, value) {
       var db = getDatabase();
       var res = "";
       db.transaction(function(tx) {
            tx.executeSql('CREATE TABLE IF NOT EXISTS settings(setting TEXT UNIQUE, value TEXT)');
            var rs = tx.executeSql('INSERT OR REPLACE INTO settings VALUES (?,?);', [setting,value]);
                  if (rs.rowsAffected > 0) {
                    res = "OK";
                  } else {
                    res = "Error";
                  }
            }
      );
      return res;
    }

    function get(setting, default_value) {
       var db = getDatabase();
       var res="";
       try {
           db.transaction(function(tx) {
             var rs = tx.executeSql('SELECT value FROM settings WHERE setting=?;', [setting]);
             if (rs.rows.length > 0) {
                  res = rs.rows.item(0).value;
             } else {
                 res = default_value;
             }
          })
       } catch (err) {
           //console.log("Database " + err);
           res = default_value;
       };
      return res
    }

    Component.onCompleted: {
        var username = get('username', '');
        var password = get('password', '');
        var connectAutomatically = get('connectAutomatically', false);
        var filter = get('filter', '');
        form.username = username;
        form.password = password;
        form.connectAutomatically = connectAutomatically;
        form.filter = filter;
        if(connectAutomatically)
            timer.start();
    }

    Component.onDestruction: {
        var username = form.username;
        var password = form.password;
        var connectAutomatically = form.connectAutomatically;
        var filter = form.filter;
        set('username', username);
        set('password', password);
        set('connectAutomatically', connectAutomatically);
        set('filter', filter);
    }

    Timer {
        id: timer;
        interval: 1000;
        repeat: true;
        running: false;
        onTriggered: {
            var params = JSON.stringify({parameter: [{name: "exchange_revision", value: "test"}]});
            var result = httpPost("https://jellyfish.bar.gameloft.org/api/xml?tree=jobs[*]", "json="+params)
            model.xml = result;
        }
    }

    menuBar: MenuBar {
        Menu {
            title: qsTr("File")
            MenuItem {
                text: qsTr("&Open")
                onTriggered: console.log("Open action triggered");
            }
            MenuItem {
                text: qsTr("Exit")
                onTriggered: Qt.quit();
            }
        }
    }

    MainForm {
        id: form
        anchors.fill: parent

        username: settings.username;
        password: settings.password;
        connectButton.onClicked: timer.start();

        model: XmlListModel {
            id: model
            query: "/hudson/job"

            XmlRole { name: "displayName"; query: "displayName/string()" }
            XmlRole { name: "colorString"; query: "color/string()" }
        }

        delegate: Item {
            id: item;

            x: 5
            width: 80
            height: {
                var name = displayName.toLowerCase();
                var filter = form.filter.toLowerCase();
                if(filter.length)
                {
                    var index = name.indexOf(filter);
                    return index > -1 ? 40 : 0;
                }
                return 40;
            }
            visible: height > 0;

            property color color: {
                if(colorString == 'blue_anime')
                {
                    return "green";
                }
                else if (colorString == 'notbuilt')
                {
                    return "black";
                }
                else if (colorString == 'disabled')
                {
                    return "gray";
                }
                else return colorString;
            }

            Row {
                Rectangle {
                    height: parent.height;
                    width: height;
                    color: item.color;
                }
                Text {
                    color: item.color;
                    text: displayName;
                    anchors.verticalCenter: parent.verticalCenter
                }
                spacing: 10
            }
        }
    }

    MessageDialog {
        id: messageDialog
        title: qsTr("May I have your attention, please?")

        function show(caption) {
            messageDialog.text = caption;
            messageDialog.open();
        }
    }
}

