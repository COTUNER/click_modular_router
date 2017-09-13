rt :: RadixIPsecLookup(10.20.0.21/28 10.20.0.31 1 234  \<ABCDEFFF001DEFD2354550FE40CD708E> 
\<112233EE556677888877665544332211> 300 64,
			10.20.0.32/32 0,
			10.20.0.30/32 2,
			10.20.0.31/32 3,
		     	10.20.0.24/32 4, );

FromDevice(eth0) -> DropBroadcasts
		-> Print(0,50)
		-> c0 :: Classifier(12/0800,-)
		-> Strip(14)
		-> CheckIPHeader(INTERFACES 10.20.0.30/24 10.20.0.32/24)
		-> [0]rt;
FromDevice(eth1) -> DropBroadcasts
		-> Print(1,50)
		-> c0 :: Classifier(12/0800,-)
		-> Strip(14)
		-> CheckIPHeader(INTERFACES 10.20.0.30/24 10.20.0.32/24)
		-> [0]rt;

rt[2] 	-> EtherEncap(0x0800, 1:1:1:1:1:1, 2:2:2:2:2:2) -> tol :: ToHost();
rt[1] 	-> Print(ipin)
	-> espen :: IPsecESPEncap()
        -> cauth :: IPsecAuthHMACSHA1(0)
        -> encr :: IPsecAES(1)
        -> ipencap :: IPsecEncap(50)
	-> Print(ipinE)
        -> [0]rt;
rt[3] 	-> DropBroadcasts
      	-> dt1 :: DecIPTTL
	-> in :: EtherEncap(0x0800, 52:54:00:43:4b:cd, 52:54:00:82:e1:fc)
	-> Print(ipEout)
	-> Queue(1500)
      	-> ToDevice(eth1);
rt[0]  	-> Print(espin)
	-> StripIPHeader()
      	-> decr :: IPsecAES(0)
      	-> vauth :: IPsecAuthHMACSHA1(1)
      	-> espuncap :: IPsecESPUnencap()
      	-> CheckIPHeader()
	-> Print(espinX)
      	-> [0]rt;
rt[4]	-> DropBroadcasts
      	-> dt2 :: DecIPTTL
	-> out :: EtherEncap(0x0800, 52:54:00:cb:44:f3, 52:54:00:8b:9a:e1)
	-> Print(espXout)
	-> Queue(1500)
	-> ToDevice(eth0);

c0[1]	-> Discard;
c1[1]	-> Discard;
 	
