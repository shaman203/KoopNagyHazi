// Agent env in project nagyHazi

/* Initial beliefs and rules */

edge(X,Y,Z).
/* Initial goals */

!start.

/* Plans */

+!start:true <- .all_names(X);
				tell_agents(X);
				!parseAgents(X).

+!parseAgents([]).

+!parseAgents([A|T])<- 	nagyHazi.translateName(A,AName);
						+agent_name(A,AName);
						!parseAgents(T).
     				
+!parseAgents([_|T])<- 	!parseAgents(T).

+!create_connection(X,Y,D)<-	?agent_name(XHandle,X);
							?agent_name(YHandle,Y);
							+connected(XHandle,YHandle,D);
							+connected(YHandle,XHandle,D);
							.send(XHandle,tell,connected(YHandle,Y,D));
							.send(YHandle,tell,connected(XHandle,X,D));
							.print("Added connection").
							
+!drop_connection(X,Y)<-	?agent_name(XHandle,X);
							?agent_name(YHandle,Y);
							.abolish(connected(XHandle,YHandle,D));
							.abolish(connected(YHandle,XHandle,D));
							.send(XHandle,tell,disconnected(YHandle));
							.send(YHandle,tell,disconnected(XHandle));
							.print("Dropped connection").