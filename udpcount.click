AddressInfo(the_interface 10.20.0.24 52:54:00:8b:9a:e1);

classifier	:: Classifier(12/0800 /* IP packets */,
			      12/0806 20/0001 /* ARP requests */,
			      - /* everything else */);
in_device	:: FromDevice(the_interface);
out		:: Queue(200) -> ToDevice(the_interface);
to_host		:: ToHost;

in_device -> classifier 
	-> Print(cla0)
	-> counter :: Counter
	-> Discard;
classifier[1] -> Print(ARPR) -> ARPResponder(eth1) -> out;
classifier[2] -> Print(elsetohost) -> to_host;
