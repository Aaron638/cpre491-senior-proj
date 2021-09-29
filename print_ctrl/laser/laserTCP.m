function laserTCP() 

    laserCMD = 0x1B01010D2A;

    numCMDs;
    id;
    response = 0b00000000;

    portnum = 58176;

    ipaddress
    t = tcpclient("ipaddress", portnum);

    configureCallback(t, "byte", 10, )


end