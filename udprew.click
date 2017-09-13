AddressInfo(the_interface 10.20.0.32 52:54:00:43:4b:cd);
in_device	:: FromDevice(the_interface);
td1		:: ToDevice(eth0);
s		:: Strip(14);
rew		:: UDPRewriter(pattern - - 10.20.0.24 1234 0 1);
in_device	-> Print(cla0)
	-> s
	-> rew
	-> EC :: EtherEncap(0x0800, 52:54:00:43:4b:cd, 52:54:00:8b:9a:e1)
	-> Queue(1000)
	-> Print(out)
	-> td1;
rew1[1]	-> Queue(500) -> Discard;
