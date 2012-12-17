/* #ident "$Id: $"
 * @author: rzr@gna.org - rev: $Author: rzr$
 * Copyright: See README file that comes with this distribution
 *****************************************************************************/
import bb.cascades 1.0

Page {
    id: editPage
    // property alias content: textArea.text
    // property alias isEdit : textArea.enabled
    TextArea {
      id: textArea
      preferredWidth: parent.preferredWidth - 10
      preferredHeight: parent.preferredHeight - 10
    }
}
