rt :: RadixIPsecLookup(10.20.0.24/32 10.20.0.32 1 234 \<ABCDEFFF001DEFD2354550FE40CD708E> \<112233EE556677888877665544332211> 300 64,
			10.20.0.31/32 0,
			10.20.0.29/32 2,
			10.20.0.32/32 3,
			10.20.0.21/32 4,  );
//rew0		:: IPRewriter(pattern - - 10.20.0.24 1234 0 1);
//rew1		:: IPRewriter(pattern - - 10.20.0.24 1234 0 1);
FromDevice(eth0) -> DropBroadcasts
		-> Print(0,70)
		-> c0 :: Classifier(12/0800,-)
		-> Strip(14)
//		-> rew0
		-> CheckIPHeader(INTERFACES 10.20.0.31/24 10.20.0.29/24)
		-> [0]rt;
FromDevice(eth1) -> DropBroadcasts
		-> Print(1,70)
		-> c1 :: Classifier(12/0800,-)
		-> Strip(14)
//		-> rew1
		-> CheckIPHeader(INTERFACES 10.20.0.31/24 10.20.0.29/24)
		-> [0]rt;
rt[2]	-> EtherEncap(0x0800, 1:1:1:1:1:1, 2:2:2:2:2:2) -> tol :: ToHost();
rt[1]	-> Print(ipin)
	-> espen :: IPsecESPEncap()
	-> cauth :: IPsecAuthHMACSHA1 (0)
	-> encr :: IPsecAES(1)
	-> ipencap :: IPsecEncap(50)
	-> Print(ipinE)
	-> [0]rt;
rt[3]	-> DropBroadcasts
	-> dt1 :: DecIPTTL
	-> in :: EtherEncap(0x0800, 52:54:00:82:e1:fc, 52:54:00:43:4b:cd)
	-> Print(ipEout)
	-> Queue(1500)
	-> ToDevice(eth1);
rt[0]	-> Print(espin)
	-> StripIPHeader()
	-> decr :: IPsecAES(0)
	-> vauth :: IPsecAuthHMACSHA1(1)
	-> espuncap :: IPsecESPUnencap()
	-> CheckIPHeader()
	-> Print(espinX)
	-> [0]rt;
rt[4]	-> DropBroadcasts
	-> dt2 :: DecIPTTL
	-> out :: EtherEncap(0x0800, 52:54:00:ef:40:07, 52:54:00:85:30:4b)
	-> Print(espXout)
	-> Queue(1500)
	-> ToDevice(eth0)	

//rew0[1]	-> Queue(150) -> Discard;
//rew1[1]	-> Queue(150) -> Discard;
c0[1]	-> Discard;
c1[1]	-> Discard;
