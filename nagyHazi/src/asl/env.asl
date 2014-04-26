// Agent env in project nagyHazi

/* Initial beliefs and rules */

edge(X,Y,Z).
/* Initial goals */

!start.

/* Plans */

+!start:true <- .all_names(X);
				.print(X);
				tell_agents(X).