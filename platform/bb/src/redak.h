/* #ident "$Id: $"
 * @author: rzr@gna.org - rev: $Author: rzr$
 * Copyright: See README file that comes with this distribution
 *****************************************************************************/

#ifndef REDAK_H
#define REDAK_H

#include <QObject>


namespace bb { namespace cascades { class Application; }}

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
    Redak(bb::cascades::Application *app);
    virtual ~Redak() {}
};

#endif /* Redak_HPP_ */