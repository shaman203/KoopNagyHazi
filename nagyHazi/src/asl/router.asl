// Agent router in project nagyHazi

/* Initial beliefs and rules */

/* Initial goals */

!init.


/* Plans */

+!init<- .my_name(X);
		 +myName(X);
		 .print(X, " is online.").

/* +connected(Peer,PeerString,Cost):myName(X) & X == Peer <-	.print("loopback added");
									!updateRoutes(PeerString,Peer,Cost);
									.abolish(connected(Peer,PeerString,Cost)).*/
									
+connected(Peer,PeerString,Cost) <-	.print("connected to ",Peer," w=",Cost);
									!updateRoutes(PeerString,Peer,Cost);
									!tellKnownRoutes(Peer).
@lg[atomic]
+!updateRoutes(Destination,Via,Cost)<- 	?route(Destination,AltVia,AltCost);
										!updateIfBetter(Destination,Via,Cost,AltVia,AltCost).

+?route(Dest,Via,Cost). //<- 	+route(Dest,Via,Cost). //if we ask for an unknown destination, add it to the belief base


+!updateIfBetter(Dest,Via,Cost,AltVia,AltCost): Cost < AltCost <- 	.abolish(route(Dest,AltVia,AltCost));
																	+route(Dest,Via,Cost);
																	!routeUpdate(Dest,Cost).
+!updateIfBetter(Dest,Via,Cost,AltVia,AltCost).

+!routeUpdate(Dest,Cost)<- 	.findall(X,connected(X,Y,Z),L);
							!iterateConnectedRouters(L,Dest,Cost).
							
+!iterateConnectedRouters([],Dest,Cost).

+!iterateConnectedRouters([A|T],Dest,Cost):myName(X) & X == A <- !iterateConnectedRouters(T,Dest,Cost).
+!iterateConnectedRouters([A|T],Dest,Cost)<- 	.send(A,tell,newRoute(Dest,Cost));
												!iterateConnectedRouters(T,Dest,Cost).
     				
+!iterateConnectedRouters([_|T],Dest,Cost)<- 	!iterateConnectedRouters(T,Dest,Cost).


+!tellKnownRoutes(Peer):myName(X) & X == Peer. 
+!tellKnownRoutes(Peer)<- .findall(X,route(X,Y,Z),L);
						  !iterateDestinations(L,Peer).
						  
+!iterateDestinations([],Peer).

+!iterateDestinations([Dest|T],Peer)<- 	?route(Dest,Via,Cost);
										.send(Peer,tell,newRoute(Dest,Cost));
										!iterateDestinations(T,Peer).
     				
+!iterateDestinations([_|T],Peer)<- !iterateDestinations(T,Peer).

+newRoute(Dest,Cost)[source(A)]<-	?connected(A,AName,ConnectionCost);
									!updateRoutes(Dest,A,Cost+ConnectionCost);
									.abolish(newRoute(Dest,Cost)).

+?connected(A,AName,ConnectionCost) <- .print("Error! ",A," is not connected to me!").

+disconnected(Peer) <- 	.print("I was disconnected from ",Peer);
						?connected(Peer,PeerString,Cost);
						.abolish(connected(Peer,PeerString,Cost));
						.abolish(disconnected(Peer)). 