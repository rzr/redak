/* #ident "$Id: $"
 * @author: rzr@gna.org - rev: $Author: rzr$
 * Copyright: See README file that comes with this distribution
 *****************************************************************************/
import bb.cascades 1.0
import bb.cascades.pickers 1.0
import "./script.js" as Script
import Core 1.1

NavigationPane {
    id: appWindow
    property int mode_load: 0 //Picker==0
    property int mode_save: 1 //Saver==1
    property int mode: 0
    property string filePath: "default.txt"
    Page {
        id: editPage
        content: TextArea {
            id: textArea
            text: Script.g_info //toDebugString()
            preferredWidth: parent.preferredWidth - 10
            preferredHeight: parent.preferredHeight - 10
            onTextChanging: {
                parent.isChanged = true;
                appWindow.mode = 1;
            }
            inputMode: TextAreaInputMode.Text
        }
        onCreationCompleted: {
            setText(Script.g_info);
        }
        property alias text: textArea.text
        property alias isEdit: textArea.editable
        property bool isChanged: false
        function setText(text) {
            editPage.text = text;
            isChanged = false;
            appWindow.mode = 0;
        }
        attachedObjects: [
            Core {
                id: core
            },
            Dialog {
                id: aboutDialog
                content: Container {
                    background: Color.create(0.0, 0.0, 0.0, 0.5)
                    horizontalAlignment: HorizontalAlignment.Center
                    verticalAlignment: VerticalAlignment.Center
                    WebView {
                        horizontalAlignment: HorizontalAlignment.Center
                        verticalAlignment: VerticalAlignment.Center
                        html: "<pre>" + Script.g_info + "</pre>"
                    }
                    Button {
                        horizontalAlignment: HorizontalAlignment.Center
                        verticalAlignment: VerticalAlignment.Bottom
                        text: "back"
                        onClicked: aboutDialog.close()
                    }
                }
            },
            FilePicker {
                id: filePicker
                type: FileType.Document | FileType.Other
                title: "Select file"
                directories: [
                    "/"
                ]
                onFileSelected: {
                    Script.handlePath(selectedFiles[0]);
                }
            }
        ]
        actions: [
            ActionItem {
                title: "Quit"
                ActionBar.placement: ActionBarPlacement.OnBar
                onTriggered: {
                    Application.quit();
                }
            },
            ActionItem {
                title: "R/W"
                onTriggered: isEdit = ! isEdit
                ActionBar.placement: ActionBarPlacement.OnBar
            },
            ActionItem {
                title: "Load"
                ActionBar.placement: ActionBarPlacement.OnBar
                onTriggered: {
                    appWindow.mode = 0; //TODO
                    filePicker.mode = appWindow.mode;
                    filePicker.open();
                }
            },
            ActionItem {
                title: "Save"
                ActionBar.placement: ActionBarPlacement.OnBar
                onTriggered: {
                    appWindow.mode = 1;
                    Script.handlePath(appWindow.filePath);
                    appWindow.mode = 0;
                }
            },
            ActionItem {
                title: "Save As"
                ActionBar.placement: ActionBarPlacement.OnBar
                onTriggered: {
                    appWindow.mode = 1; //TODO
                    filePicker.mode = appWindow.mode; //TOOD
                    filePicker.open();
                }
            },
            ActionItem {
                title: "About"
                ActionBar.placement: ActionBarPlacement.OnBar
                onTriggered: {
                    //aboutDialog.open(); //TODO: cleanup
                    editPage.setText(Script.g_info);
                }
            }            
        ]
    }
}
