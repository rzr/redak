// Custom_dialog.qml
import bb.cascades 1.0
import bb.system 1.0

Container {
    id: replaceDialog
    signal findRequested
    signal replaceRequested
    property alias findText: findWidget.text
    property alias replaceText: replaceWidget.text
    background: Color.create(0.0, 0.0, 0.0, 0.7)
    horizontalAlignment: HorizontalAlignment.Center
    verticalAlignment: VerticalAlignment.Top
    layout: StackLayout {
    }
    //preferredWidth: 768
    //preferredHeight: 1280 //TODO
    
    opacity: 1.0
    scaleX: 1.0
    scaleY: 1.0
    visible: false
    
    function open() { replaceDialog.visible = true; }
    function close() { replaceDialog.visible = false; }
    function toggle() { replaceDialog.visible = !replaceDialog.visible; }
     
    Label {
        text: "Text Search"
        textStyle.color: Color.White
        topPadding: 5
        horizontalAlignment: HorizontalAlignment.Center
    }
    TextField {
        id: findWidget
        text: "TODO"
    }
    TextField {
        id: replaceWidget
        text: "DONE"
    }
    Container {
        layout: StackLayout {
            orientation: LayoutOrientation.LeftToRight
        }
        Button {
            id: actionFind
            text: "Find"
            onClicked: {
                replaceDialog.findRequested();
                //replaceDialog.close();
            }
            opacity: 1.0
            scaleX: 1.0
            scaleY: 1.0
        }
        Button {
            id: actionReplace
            text: "Replace"
            onClicked: {
                replaceDialog.replaceRequested();
                //replaceDialog.close();
            }
        }
        Button {
            id: actionCancel
            text: "Cancel"
            onClicked: {
                replaceDialog.close();
            }
        }
    }
}
