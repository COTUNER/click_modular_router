u	:: FastUDPSource(5,5,1099, 52:54:00:85:30:4b, 10.20.0.21, 1234,
				52:54:00:8b:9a:e1, 10.20.0.24, 1234);
up	:: FromDevice(eth0);
uth	:: ToHost;
utd	:: ToDevice(eth0);
check	:: CheckIPHeader(14);
up -> check -> Print(tohost) -> uth;
u -> Strip(14) -> Print(ip) ->
	-> EtherEncap(0x0800, 52:54:00:85:0:4b, 52:54:00:ef:40:07)
	-> Print(out)
	-> utd;