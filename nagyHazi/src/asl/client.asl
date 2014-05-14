// Agent client in project nagyHazi

/* Initial beliefs and rules */

/* Initial goals */

!init.

/* Plans */

+!init<- .my_name(X);
		 +myName(X);
		 nagyHazi.translateName(X,XStr);
		 +myNameString(XStr);
		 .print(X, " is online.").

+!syncBeat.

+!send_message(To)<- 	?connected(Router,RouterName,Cost);
						?myNameString(From);
						.send(Router,tell,message(From,To,Cost)).

+?connected<- .print("Can't send message, no connected routers!").

+message(From,To,Cost)[source(A)]: myNameString(X) & X == To <- .print("Received message from ",From," Cost=",Cost);
																.abolish(message(From,To,Cost)). 	