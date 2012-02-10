import QtQuick 1.1
import com.nokia.meego 1.0
import Core 1.0
import "../common/script.js" as Script
import "../common"
import "./"

Page {
    id: pageView
    property alias editView: edit
    property alias content: edit.text
    tools: commonTools
    property string info: "redak : text editor\n\nURL: http://rzr.online.fr/q/redak\nLicense: GPL-3+\nContact: Phil Coval <rzr@gna.org>\n"
    Flickable {
        id: flick

        width: parent.width
        height: parent.height

        contentWidth: edit.paintedWidth
        contentHeight: edit.paintedHeight
        clip: true

        function ensureVisible(r)
        {
            if (contentX >= r.x)
                contentX = r.x;
            else if (contentX+width <= r.x+r.width)
                contentX = r.x+r.width-width;
            if (contentY >= r.y)
                contentY = r.y;
            else if (contentY+height <= r.y+r.height)
                contentY = r.y+r.height-height;
        }

        TextEdit {
            id: edit
            width: flick.width
            height: flick.height
            focus: true
            cursorVisible: true
            selectByMouse: false
            text: info
            smooth: true
            wrapMode: TextEdit.Wrap
            font.pixelSize: Script.g_font_pixelSize
            onCursorRectangleChanged: flick.ensureVisible(cursorRectangle)
        }
    }
}
