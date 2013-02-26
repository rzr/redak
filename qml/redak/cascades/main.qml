/* #ident "$Id: $"
 * @author: rzr@gna.org - rev: $Author: rzr$
 * Copyright: See README file that comes with this distribution
 *****************************************************************************/
import bb.cascades 1.0
import bb.cascades.pickers 1.0
import bb.system 1.0
import "./script.js" as Script
import "."
import Core 1.1

NavigationPane {
    id: appWindow
    property int mode_load: 0 //Picker==0
    property int mode_save: 1 //Saver==1
    property int mode: 0
    property string filePath: "note.txt"
    Page {
        id: editPage
        //titleBar: TitleBar {title: "Redak Text Editor"}
        content: Container {
            preferredWidth: 768
            preferredHeight: 1280 //TODO
            ReplaceDialog {
                id: replaceDialog
                function find(src) {
                    var p = textArea.position; //WORKAROUND
                    var e = 0;
                    var s = replaceDialog.findText;
                    var editor = textArea.editor;
                    //p = editor.cursorPosition();
                    //p = editor.selectionEnd; //TODO BUG
                    if (p < 0) p = 0;
                    if (null != editPage.text) {
                        p = editPage.text.indexOf(src, p);
                        if (p >= 0) {
                            e = p + s.length;
                            editor.setSelection(p, e);
                        } else {
                            p = e = 0;
                            editor.setSelection(p, e);
                        }
                        textArea.position = e;
                    }
                    inputField.defaultText = src; //TODO: WORKAROUND
                }
                function replace(src, dst) { //TODO: replace/find
                    var p = textArea.position; //WORKAROUND
                    var e = 0;
                    var s = replaceDialog.findText;
                    var editor = textArea.editor;
                    p = editor.selectionStart; //TODO BUG
                    if (p < 0) p = 0;
                    if (null != editPage.text) {
                        p = editPage.text.indexOf(src, p);
                        if (p >= 0) {
                            e = p + s.length;
                            editor.setSelection(p, e);
                        } else {
                            p = e = 0;
                            editor.setSelection(p, e);
                        }
                        if (editor.selectionStart != editor.selectionEnd) {
                            editor.insertPlainText(dst);
                            e = p + dst.length;
                            editor.setSelection(p, e);
                        }
                        textArea.position = e;
                    }
                    inputField.defaultText = src; //TODO: WORKAROUND
                }
                onReplaceRequested: {
                    replace(replaceDialog.findText, replaceDialog.replaceText);
                }
                onFindRequested: {
                    find(replaceDialog.findText);
                }
            }
            TextArea {
                id: textArea
                visible: true
                property int position: 0
                editable: true
                text: (! Script.g_debug ) ? Script.g_info : toDebugString() // TODO
                preferredWidth: parent.preferredWidth - 10
                preferredHeight: parent.preferredHeight - 10
                horizontalAlignment: HorizontalAlignment.Center
                inputMode: TextAreaInputMode.Text
                onTextChanging: {
                    parent.isChanged = true;
                    appWindow.mode = 1;
                }
                opacity: 1.0
                scaleX: 1.0
                scaleY: 1.0
            } //TextArea
        } //Container

        //editor.onSelectionEndChanged:  position = editor.selectionEnd; //TODO: BUG?
        property alias text: textArea.text
        property alias editable: textArea.editable
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
                        text: qsTr("back")
                        onClicked: aboutDialog.close()
                    }
                }
            },
            FilePicker {
                id: filePicker
                type: FileType.Other //| FileType.Document
                title: qsTr("Select file")
                directories: [
                    "/"
                ]
                onFileSelected: {
                    filePath = selectedFiles[0];
                    Script.handlePath(filePath);
                }
            },
            SystemDialog {
                id: quitDialog
                title: qsTr("Quit?")
                body: qsTr("Please confirm, your changes will be lost")
                onFinished: {
                    console.log("quitDialog: " + result);
                    if (SystemUiResult.ConfirmButtonSelection == result) {
                        Application.quit();
                    }
                }
            },
            SystemDialog {
                id: ioDialog
                title: qsTr("IO Operation ?")
                body: qsTr("Please confirm, your changes will be lost")
                onFinished: {
                    if (SystemUiResult.ConfirmButtonSelection == result) {
                        filePicker.open();
                    }
                }
            },
            SystemDialog {
                id: newDialog
                title: qsTr("New Operation ?")
                body: qsTr("Please confirm, your changes will be lost")
                onFinished: {
                    if (SystemUiResult.ConfirmButtonSelection == result) {
                        editPage.text = "";
                        appWindow.filePath == "";
                    }
                }
            },
            SystemPrompt {
                id: findDialog
                title: qsTr("Find string ?")
                body: qsTr("will select the text, check to not replace it")
                modality: SystemUiModality.Application
                inputField.inputMode: SystemUiInputMode.Default
                inputField.defaultText: qsTr("TODO")
                //includeRememberMe: true //WORKAROUND
                //rememberMeChecked: true
                onFinished: {
                    if (result == SystemUiResult.ConfirmButtonSelection) {
                        var p = textArea.position; //WORKAROUND
                        var e = 0;
                        var s = findDialog.inputFieldTextEntry();
                        var editor = textArea.editor;
                        //p = editor.cursorPosition();
                        //p = editor.selectionEnd(); //TODO BUG
                        if (p < 0) p = 0;
                        if (null != editPage.text) {
                            p = editPage.text.indexOf(s, p);
                            if (p >= 0) {
                                e = p + s.length;
                                editor.setSelection(p, e);
                            } else {
                                p = e = 0;
                                editor.setSelection(p, e);
                            }
                            textArea.position = e;
                        }
                        inputField.defaultText = s; //TODO: WORKAROUND
                    }
                }
            }
        ] // attachedObjects
        actions: [
            ActionItem {
                title: qsTr("Quit")
                ActionBar.placement: ActionBarPlacement.OnBar
                imageSource: "asset:///quit.png"
                onTriggered: quitDialog.show()
            },
            ActionItem {
                title: (textArea.editable ) ? qsTr("View") : qsTr("Edit")
                ActionBar.placement: ActionBarPlacement.OnBar
                imageSource: "asset:///view.png"
                onTriggered: textArea.editable = ! textArea.editable
            },
            ActionItem {
                title: qsTr("Find")
                ActionBar.placement: ActionBarPlacement.OnBar
                imageSource: "asset:///find.png"
                onTriggered: replaceDialog.toggle()
            },
            //            ActionItem {
            //                title: qsTr("Find")
            //                ActionBar.placement: ActionBarPlacement.OnBar
            //                imageSource: "asset:///find.png"
            //                onTriggered: findDialog.show()
            //            },
            ActionItem {
                title: qsTr("Load")
                ActionBar.placement: ActionBarPlacement.OnBar
                imageSource: "asset:///load.png"
                onTriggered: {
                    appWindow.mode = 0; //TODO
                    filePicker.mode = appWindow.mode;
                    if (editPage.isChanged) {
                        ioDialog.show();
                    } else {
                        filePicker.open();
                    }
                }
            },
            ActionItem {
                title: qsTr("Save")
                ActionBar.placement: ActionBarPlacement.OnBar
                imageSource: "asset:///save.png"
                onTriggered: {
                    appWindow.mode = 1;
                    if ("" != appWindow.filePath) {
                        Script.handlePath(appWindow.filePath);
                    } else {
                        appWindow.mode = 1; //TODO
                        filePicker.mode = appWindow.mode; //TOOD
                        filePicker.open();
                    }
                }
            },
            ActionItem {
                title: qsTr("Save As")
                ActionBar.placement: ActionBarPlacement.OnBar
                imageSource: "asset:///save-as.png"
                onTriggered: {
                    appWindow.mode = 1; //TODO
                    filePicker.mode = appWindow.mode; //TOOD
                    filePicker.open();
                }
            },
            ActionItem {
                title: qsTr("New")
                ActionBar.placement: ActionBarPlacement.OnBar
                imageSource: "asset:///new.png"
                onTriggered: {
                    appWindow.mode = 0; //TODO
                    filePicker.mode = appWindow.mode;
                    if (editPage.isChanged) {
                        newDialog.show();
                    } else {
                        editPage.text = "";
                        appWindow.filePath = "";
                    }
                }
            },
            ActionItem {
                title: qsTr("About")
                ActionBar.placement: ActionBarPlacement.OnBar
                imageSource: "asset:///about.png"
                onTriggered: {
                    //aboutDialog.open(); //TODO: cleanup
                    editPage.setText(Script.g_info);
                }
            }
        ] //Page::actions
    } // Page
}//Window
