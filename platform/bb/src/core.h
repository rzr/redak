/* #ident "$Id: $"
 * @author: rzr@gna.org - rev: $Author: rzr$
 * Copyright: See README file that comes with this distribution
 *****************************************************************************/

#ifndef CoreREDAK_H
#define CoreREDAK_H

#include <QObject>
#include <QDeclarativeItem>
#include <QDeclarativeExtensionPlugin>

class Core
: public QDeclarativeItem
//: public QDeclarativeExtensionPlugin
{
    Q_OBJECT

public:
    Core(QDeclarativeItem *parent = 0);
    Q_INVOKABLE bool save(QString content , QString filemame);
    Q_INVOKABLE QString load(QString filemame);
    Q_INVOKABLE QString process(QString const filename);

    void registerTypes(const char *uri);

signals:
    void saved();
    void loaded(QString content);
    void error(QVariant text);
};

#endif // REDAK_H
