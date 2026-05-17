import QtQuick
import Quickshell
import Quickshell.Widgets

MouseArea {
    id: root
    implicitWidth: row.width + 12
    implicitHeight: 30
    hoverEnabled: true
    cursorShape: Qt.PointingHandCursor

    // Placeholder properties - hook these up to your notification system
    property int unreadCount: 3 
    property bool active: unreadCount > 0

    onClicked: {
        // Trigger your notification panel visibility here
        // Example: notificationPanel.visible = !notificationPanel.visible
        console.log("Toggle notification panel")
    }

    Row {
        id: row
        anchors.centerIn: parent
        spacing: 6

        // The Bell Icon (Using a standard Unicode character or icon font)
        Text {
            text: root.active ? "󰂚" : "󰂛" // Or use an icon font like FontAwesome
            font.pixelSize: 16
            color: root.containsMouse ? "#ffffff" : "#aaaaaa"
            // behavior on color { ColorAnimation { duration: 150 } }
        }

        // Unread Badge (Only shows if count > 0)
        Rectangle {
            visible: root.active
            width: countText.implicitWidth + 8
            height: 18
            radius: 9
            color: "#ff5555" // Noticeable red
            anchors.verticalCenter: parent.verticalCenter

            Text {
                id: countText
                text: root.unreadCount
                color: "white"
                font.pixelSize: 11
                font.bold: true
                anchors.centerIn: parent
            }
        }
    }
}
