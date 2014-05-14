// Agent router in project nagyHazi

/* Initial beliefs and rules */

/* Initial goals */

!init.


/* Plans */

+!init<- .my_name(X);
		 +myName(X);
		 nagyHazi.translateName(X,XStr);
		 +myNameString(XStr);
		 .print(X, " is online.").

+connected(Peer,PeerString,Cost) <-	.print("connected to ",Peer," w=",Cost);
									!updateRoutes(PeerString,Peer,Cost).

+!updateRoutes(Destination,Via,Cost)<- 	?route(Destination,AltVia,AltCost);
										.abolish(routeCheckFailed(1));
										!updateIfBetter(Destination,Via,Cost,AltVia,AltCost).

+?route(Dest,Via,Cost)<- +routeCheckFailed(1). //<- 	+route(Dest,Via,Cost). //if we ask for an unknown destination, add it to the belief base


+!updateIfBetter(Dest,Via,Cost,AltVia,AltCost): Cost < AltCost <- 	.abolish(route(Dest,AltVia,AltCost));
																	+route(Dest,Via,Cost).
+!updateIfBetter(Dest,Via,Cost,AltVia,AltCost).


+!syncBeat<- .findall(Peer,connected(Peer,PeerString,Cost),L);
			 !tellPeers(L).
+!tellPeers([]).
+!tellPeers([A|T])<- 	!tellKnownRoutes(A);
						!tellPeers(T).
+!tellPeers([_|T])<- !tellPeers(T).


+!tellKnownRoutes(Peer):myName(X) & X == Peer. 
+!tellKnownRoutes(Peer)<- .findall(X,route(X,Y,Z),L);
						  !iterateDestinations(L,Peer).
						  
+!iterateDestinations([],Peer).

+!iterateDestinations([Dest|T],Peer)<- 	?route(Dest,Via,Cost);										
										.send(Peer,tell,newRoute(Dest,Cost));
										!iterateDestinations(T,Peer).
     				
+!iterateDestinations([_|T],Peer)<- !iterateDestinations(T,Peer).

@lg[atomic]
+newRoute(Dest,Cost)[source(A)]<-	?connected(A,AName,ConnectionCost);
									!updateRoutes(Dest,A,Cost+ConnectionCost);
									.abolish(newRoute(Dest,Cost)).

+?connected(A,AName,ConnectionCost) <- +connectedCheckFailed(1).

+disconnected(Peer) <- 	.print("I was disconnected from ",Peer);
						?connected(Peer,PeerString,Cost);
						.abolish(connected(Peer,PeerString,Cost));
						.abolish(disconnected(Peer));
						.abolish(route(_,Peer,_));
						!notifyConnectedOfDisconnection(PeerString).

+!notifyConnectedOfDisconnection(DiscPeerString): connectedCheckFailed(X) & X == 1 <- abolish(routeCheckFailed(X)).						
+!notifyConnectedOfDisconnection(DiscPeerString)<-.findall(X,connected(X,Y,Z),L);
												  !notifyOfDisconnection(L,DiscPeerString).
						
+!notifyOfDisconnection([],DiscPeerString).

+!notifyOfDisconnection([Peer|T],DiscPeerString):myName(X) & X == Peer.
+!notifyOfDisconnection([Peer|T],DiscPeerString)<- .send(Peer,tell,disconnectNotif(DiscPeerString));
										!notifyOfDisconnection(T,DiscPeerString).
+!notifyOfDisconnection([_|T],Peer)<- !notifyOfDisconnection(T,DiscPeerString).

+disconnectNotif(DiscPeerString)[source(A)]<- 	.abolish(route(DiscPeerString,A,_));
												.abolish(disconnectNotif(DiscPeerString));
												!notifyConnectedOfDisconnection(DiscPeerString).						


+message(From,To,Cost)[source(A)]: myNameString(X) & X == To <- .print("Received message from ",From," Cost=",Cost);
																.abolish(message(From,To,Cost)). 												
+message(From,To,Cost)[source(A)]<- ?route(To,Via,Cost2);
									!send_message(From,To,Via,Cost);
									.abolish(message(From,To,Cost)).
+!send_message(From,To,Via,Cost): routeCheckFailed(X) & X == 1 <- 	.abolish(routeCheckFailed(X));
																	.print("No route to ",To).									
+!send_message(From,To,Via,Cost)<- 	?connected(Via,ViaName, ConnectionCost);
									.send(Via,tell,message(From,To,Cost+ConnectionCost)).
																					