u	:: FastUDPSource(5,5,1099, 52:54:00:85:30:4b, 10.20.0.21, 1234,
				52:54:00:43:4b:cd, 10.20.0.32, 1234);
up	:: FromDevice(eth0);
uth	:: ToHost;
utd	:: ToDevice(eth0);
check	:: CheckIPHeader(14);
up -> check -> Print(tohost) -> uth;
u -> Strip(14) -> Print(ip) ->
	-> Unstrip(14)
	-> Print(out)
	-> utd;