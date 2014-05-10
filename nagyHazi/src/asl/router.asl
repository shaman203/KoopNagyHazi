// Agent router in project nagyHazi

/* Initial beliefs and rules */

/* Initial goals */



/* Plans */

+connected(Peer,PeerString,Cost) <-	.print("connected to ",Peer," w=",Cost);
									!updateRoutes(PeerString,Peer,Cost).

+!updateRoutes(Destination,Via,Cost)<- 	?route(Destination,AltVia,AltCost);
										!updateIfBetter(Destination,Via,Cost,AltVia,AltCost).

+?route(Dest,Via,Cost). //<- 	+route(Dest,Via,Cost). //if we ask for an unknown destination, add it to the belief base

+!updateIfBetter(Dest,Via,Cost,AltVia,AltCost): Cost < AltCost <- 	.abolish(route(Dest,AltVia,AltCost));
																	.print("Better route was found ",Cost," ",AltCost );
																	+route(Dest,Via,Cost).
+!updateIfBetter(Dest,Via,Cost,AltVia,AltCost).

+disconnected(Peer) <- 	.print("I was disconnected from ",Peer);
						?connected(Peer,PeerString,Cost);
						.abolish(connected(Peer,Peer,Cost));
						.abolish(disconnected(Peer)). 