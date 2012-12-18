/* #ident "$Id: $"
 * @author: rzr@gna.org - rev: $Author: rzr$
 * Copyright: See README file that comes with this distribution
 *****************************************************************************/
//import Qt.labs.folderlistmodel 1.0
import bb.cascades 1.0
import bb.cascades.pickers 1.0


//import "./common/script.js" as Script

Page {
    content: Container {
        Button {
            text: "FilePicker from QML"
            onClicked: {
                filePicker.open()
            }
        }
    }
    attachedObjects: [
        FilePicker {
            id: filePicker
            type: FileType.Picture
            title: "Select Picture"
            directories: [
                "/"]
                onFileSelected : {
                   // console.log("FileSelected signal received : " + selectedFiles);
                }
            }
    ]
}
