// Agent env in project nagyHazi

/* Initial beliefs and rules */

edge(X,Y,Z).
/* Initial goals */

!start.

/* Plans */

+!start:true <- .all_names(X);
				tell_agents(X);
				!translateNames(X).

+!translateNames([]).

+!translateNames([A|T])<- 	nagyHazi.translateName(A,AName);
							+agent_name(A,AName);
							!list(T).
     				
+!translateNames([_|T])<- 	!list(T).

+create_connection(X,Y,D)<-	?agent_name(XHandle,X);
							?agent_name(YHandle,Y);
							+connected(XHandle,YHandle,D);
							+connected(YHandle,XHandle,D);
							.send(XHandle,tell,connected(YHandle,D));
							.send(YHandle,tell,connected(XHandle,D)).
							
+drop_connection(X,Y,D)<-	?agent_name(XHandle,X);
							?agent_name(YHandle,Y);
							-connected(XHandle,YHandle,D);
							-connected(YHandle,XHandle,D);
							.send(XHandle,tell,disconnected(YHandle,D));
							.send(YHandle,tell,disconnected(XHandle,D)).