/* #ident "$Id: $"
 * @author: rzr@gna.org - rev: $Author: rzr$
 * Copyright: See README file that comes with this distribution
 *****************************************************************************/

var g_font_pixelSize = 26;

var g_verbose = false;

/// http://doc.qt.nokia.com/qt-components-symbian/qml-style.html
var g_color_normal = "#00AAAAAA";
var g_color_bg_normal = "#00000000";
var g_color_bg_pressed = "steelblue";
var g_color_border = "gray";

var g_version = "0.6.4" ;

var g_info = "redak : text editor\n\nURL: http://rzr.online.fr/q/redak\nLicense: GPL-3+\nContact: Phil Coval <rzr@gna.org>\nVersion: " + g_version + "\n";


function log(text)
{
    if ( g_verbose ) {
        console.log(text);
    }
}


function image(filename)
{
    //    "image://theme/icon-m-common-drilldown-arrow"
    //                                + (theme.inverted ? "-inverse" : "")
    var res = filename; //
    //res += ( platformInverted )  ? "-inverse" : "";
    return res;
}


/// obsolete
function loadUrl(filename)
{
    parent.visible = true;
    textView.text = "loading: " + filename;
    var url = null;
    url =  Qt.resolvedUrl( filename );
    var loader = new XMLHttpRequest();
    loader.open( "GET", url );
    loader.onreadystatechange = function() {
                if (XMLHttpRequest.DONE == loader.readyState ) {
                    textView.text = loader.responseText;
                } }
    loader.send();
}


function handleFolderChanged(path)
{
    log("handleFolderChanged: "+path);
    appWindow.folderPath=path;
}


function handlePath(filepath)
{
    var res = true;
    var filename = "unknown.txt"
    var content = appWindow.filepath;
    if ( null != filepath ) { filename = filepath; }

    log("log: Script.handlePath: io: mode="+ appWindow.mode + " path=" +  filename );

    if ( 1 == appWindow.mode ) {
        content = editPage.content;
        res &= redak.save( content, filename );
        appWindow.filePath = filename;

    } else {
        //platformCloseSoftwareInputPanel(); //TODO
        content = redak.load( filename );
        editPage.setContents(content); //todo
        appWindow.filePath = filename;
    }

    //editPage.listView.focus = true;
    if ( res ) { pageStack.pop(); }
    return res;
}
