// Internal action code for project nagyHazi

package nagyHazi;

import jason.asSemantics.*;
import jason.asSyntax.*;

public class isRouter extends DefaultInternalAction {

    @Override
    public Object execute(TransitionSystem ts, Unifier un, Term[] args) throws Exception {
        // execute the internal action
    	if(args[0].toString().startsWith("router"))
    		return un.unifies(ASSyntax.createNumber(1),args[1]);
    	else
    		return un.unifies(ASSyntax.createNumber(0),args[1]);
    }
}
