// Agent router in project nagyHazi

/* Initial beliefs and rules */

/* Initial goals */

!init.


/* Plans */

+connected(Peer,PeerString,Cost) <-	.print("connected to ",Peer," w=",Cost);
									!updateRoutes(PeerString,Peer,Cost).
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

+!iterateConnectedRouters([A|T],Dest,Cost)<- 	.send(A,tell,newRoute(Dest,Cost));
												!iterateConnectedRouters(T,Dest,Cost).
     				
+!iterateConnectedRouters([_|T],Dest,Cost)<- 	!iterateConnectedRouters(T,Dest,Cost).


+newRoute(Dest,Cost)[source(A)]<-	!updateRoutes(Dest,A,Cost);
									.abolish(newRoute(Dest,Cost)).

+disconnected(Peer) <- 	.print("I was disconnected from ",Peer);
						?connected(Peer,PeerString,Cost);
						.abolish(connected(Peer,PeerString,Cost));
						.abolish(disconnected(Peer)). 