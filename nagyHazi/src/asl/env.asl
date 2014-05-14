// Agent env in project nagyHazi

/* Initial beliefs and rules */


/* Initial goals */

!start.
!beat.
/* Plans */

+!beat<-.wait(1000);
		//.print("broadcasting syncbeat");
		.broadcast(achieve,syncBeat); 
		!beat.

+!start:true <- .all_names(X);
				tell_agents(X);
				!parseAgents(X).

+!parseAgents([]).

+!parseAgents([A|T])<- 	nagyHazi.translateName(A,AName);
						+agent_name(A,AName);
						nagyHazi.isRouter(A,B);
						!initRouter(A,B,AName);
						!parseAgents(T).
+!initRouter(A,B,AName): B == 1 <- .send(A,tell,connected(A,AName,0)).     				
+!initRouter(A,B,AName).
     				
+!parseAgents([_|T])<- 	!parseAgents(T).

+!create_connection(X,Y,D)<-?agent_name(XHandle,X);
							?agent_name(YHandle,Y);
							+connected(XHandle,YHandle,D);
							+connected(YHandle,XHandle,D);
							.send(XHandle,tell,connected(YHandle,Y,D));
							.send(YHandle,tell,connected(XHandle,X,D)).
							
+!drop_connection(X,Y)<-	?agent_name(XHandle,X);
							?agent_name(YHandle,Y);
							.abolish(connected(XHandle,YHandle,D));
							.abolish(connected(YHandle,XHandle,D));
							.send(XHandle,tell,disconnected(YHandle));
							.send(YHandle,tell,disconnected(XHandle)).
							
+!send_message(X,Y)<-	?agent_name(XHandle,X);
						.send(XHandle,achieve,send_message(Y)).
						
												