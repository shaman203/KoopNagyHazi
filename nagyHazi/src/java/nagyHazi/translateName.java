// Internal action code for project nagyHazi

package nagyHazi;

import jason.asSemantics.*;
import jason.asSyntax.*;

public class translateName extends DefaultInternalAction {

    @Override
    public Object execute(TransitionSystem ts, Unifier un, Term[] args) throws Exception {
        // execute the internal action
        //ts.getAg().getLogger().info("executing internal action 'nagyHazi.translateName'");
       
        return un.unifies(new StringTermImpl(args[0].toString()),args[1]);

    }
}
