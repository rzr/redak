/* #ident "$Id: $"
 * @author: rzr@gna.org - rev: $Author: rzr$
 * Copyright: See README file that comes with this distribution
 *****************************************************************************/

#ifndef REDAK_H
#define REDAK_H

#include <QObject>

#ifdef Q_OS_BLACKBERRY
namespace bb { namespace cascades { class Application; }}
#endif

/*!
 * @brief Application pane object
 *
 *Use this object to create and init app UI, to create context objects, to register the new meta types etc.
 */
class Redak
: public QObject
{
    Q_OBJECT
public:
#ifdef Q_OS_BLACKBERRY
    Redak(bb::cascades::Application *app);
#endif
    virtual ~Redak() {}
};

#endif /* Redak_HPP_ */
