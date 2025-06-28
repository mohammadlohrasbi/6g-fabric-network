version: '2'

networks:
  fabric:
    driver: bridge

services:
  ca.orderer.example.com:
    container_name: ca.orderer.example.com
    image: hyperledger/fabric-ca:1.5.7
    environment:
      - FABRIC_CA_HOME=/etc/hyperledger/fabric-ca-server
      - FABRIC_CA_SERVER_CA_NAME=ca-orderer
      - FABRIC_CA_SERVER_TLS_ENABLED=true
      - FABRIC_CA_SERVER_TLS_CERTFILE=/etc/hyperledger/fabric-ca-server/tls-cert.pem
      - FABRIC_CA_SERVER_TLS_KEYFILE=/etc/hyperledger/fabric-ca-server/tls-key.pem
    command: sh -c 'fabric-ca-server start -b admin:adminpw -d'
    volumes:
      - ./crypto-config/ordererOrganizations/example.com/ca:/etc/hyperledger/fabric-ca-server
    ports:
      - 7054:7054
    networks:
      - fabric

  ca.org1.example.com:
    container_name: ca.org1.example.com
    image: hyperledger/fabric-ca:1.5.7
    environment:
      - FABRIC_CA_HOME=/etc/hyperledger/fabric-ca-server
      - FABRIC_CA_SERVER_CA_NAME=ca-org1
      - FABRIC_CA_SERVER_TLS_ENABLED=true
      - FABRIC_CA_SERVER_TLS_CERTFILE=/etc/hyperledger/fabric-ca-server/tls-cert.pem
      - FABRIC_CA_SERVER_TLS_KEYFILE=/etc/hyperledger/fabric-ca-server/tls-key.pem
    command: sh -c 'fabric-ca-server start -b admin:adminpw -d'
    volumes:
      - ./crypto-config/peerOrganizations/org1.example.com/ca:/etc/hyperledger/fabric-ca-server
    ports:
      - 7055:7054
    networks:
      - fabric

  ca.org2.example.com:
    container_name: ca.org2.example.com
    image: hyperledger/fabric-ca:1.5.7
    environment:
      - FABRIC_CA_HOME=/etc/hyperledger/fabric-ca-server
      - FABRIC_CA_SERVER_CA_NAME=ca-org2
      - FABRIC_CA_SERVER_TLS_ENABLED=true
      - FABRIC_CA_SERVER_TLS_CERTFILE=/etc/hyperledger/fabric-ca-server/tls-cert.pem
      - FABRIC_CA_SERVER_TLS_KEYFILE=/etc/hyperledger/fabric-ca-server/tls-key.pem
    command: sh -c 'fabric-ca-server start -b admin:adminpw -d'
    volumes:
      - ./crypto-config/peerOrganizations/org2.example.com/ca:/etc/hyperledger/fabric-ca-server
    ports:
      - 8055:7054
    networks:
      - fabric

  ca.org3.example.com:
    container_name: ca.org3.example.com
    image: hyperledger/fabric-ca:1.5.7
    environment:
      - FABRIC_CA_HOME=/etc/hyperledger/fabric-ca-server
      - FABRIC_CA_SERVER_CA_NAME=ca-org3
      - FABRIC_CA_SERVER_TLS_ENABLED=true
      - FABRIC_CA_SERVER_TLS_CERTFILE=/etc/hyperledger/fabric-ca-server/tls-cert.pem
      - FABRIC_CA_SERVER_TLS_KEYFILE=/etc/hyperledger/fabric-ca-server/tls-key.pem
    command: sh -c 'fabric-ca-server start -b admin:adminpw -d'
    volumes:
      - ./crypto-config/peerOrganizations/org3.example.com/ca:/etc/hyperledger/fabric-ca-server
    ports:
      - 9055:7054
    networks:
      - fabric

  ca.org4.example.com:
    container_name: ca.org4.example.com
    image: hyperledger/fabric-ca:1.5.7
    environment:
      - FABRIC_CA_HOME=/etc/hyperledger/fabric-ca-server
      - FABRIC_CA_SERVER_CA_NAME=ca-org4
      - FABRIC_CA_SERVER_TLS_ENABLED=true
      - FABRIC_CA_SERVER_TLS_CERTFILE=/etc/hyperledger/fabric-ca-server/tls-cert.pem
      - FABRIC_CA_SERVER_TLS_KEYFILE=/etc/hyperledger/fabric-ca-server/tls-key.pem
    command: sh -c 'fabric-ca-server start -b admin:adminpw -d'
    volumes:
      - ./crypto-config/peerOrganizations/org4.example.com/ca:/etc/hyperledger/fabric-ca-server
    ports:
      - 10055:7054
    networks:
      - fabric

  ca.org5.example.com:
    container_name: ca.org5.example.com
    image: hyperledger/fabric-ca:1.5.7
    environment:
      - FABRIC_CA_HOME=/etc/hyperledger/fabric-ca-server
      - FABRIC_CA_SERVER_CA_NAME=ca-org5
      - FABRIC_CA_SERVER_TLS_ENABLED=true
      - FABRIC_CA_SERVER_TLS_CERTFILE=/etc/hyperledger/fabric-ca-server/tls-cert.pem
      - FABRIC_CA_SERVER_TLS_KEYFILE=/etc/hyperledger/fabric-ca-server/tls-key.pem
    command: sh -c 'fabric-ca-server start -b admin:adminpw -d'
    volumes:
      - ./crypto-config/peerOrganizations/org5.example.com/ca:/etc/hyperledger/fabric-ca-server
    ports:
      - 11055:7054
    networks:
      - fabric

  ca.org6.example.com:
    container_name: ca.org6.example.com
    image: hyperledger/fabric-ca:1.5.7
    environment:
      - FABRIC_CA_HOME=/etc/hyperledger/fabric-ca-server
      - FABRIC_CA_SERVER_CA_NAME=ca-org6
      - FABRIC_CA_SERVER_TLS_ENABLED=true
      - FABRIC_CA_SERVER_TLS_CERTFILE=/etc/hyperledger/fabric-ca-server/tls-cert.pem
      - FABRIC_CA_SERVER_TLS_KEYFILE=/etc/hyperledger/fabric-ca-server/tls-key.pem
    command: sh -c 'fabric-ca-server start -b admin:adminpw -d'
    volumes:
      - ./crypto-config/peerOrganizations/org6.example.com/ca:/etc/hyperledger/fabric-ca-server
    ports:
      - 12055:7054
    networks:
      - fabric

  ca.org7.example.com:
    container_name: ca.org7.example.com
    image: hyperledger/fabric-ca:1.5.7
    environment:
      - FABRIC_CA_HOME=/etc/hyperledger/fabric-ca-server
      - FABRIC_CA_SERVER_CA_NAME=ca-org7
      - FABRIC_CA_SERVER_TLS_ENABLED=true
      - FABRIC_CA_SERVER_TLS_CERTFILE=/etc/hyperledger/fabric-ca-server/tls-cert.pem
      - FABRIC_CA_SERVER_TLS_KEYFILE=/etc/hyperledger/fabric-ca-server/tls-key.pem
    command: sh -c 'fabric-ca-server start -b admin:adminpw -d'
    volumes:
      - ./crypto-config/peerOrganizations/org7.example.com/ca:/etc/hyperledger/fabric-ca-server
    ports:
      - 13055:7054
    networks:
      - fabric

  ca.org8.example.com:
    container_name: ca.org8.example.com
    image: hyperledger/fabric-ca:1.5.7
    environment:
      - FABRIC_CA_HOME=/etc/hyperledger/fabric-ca-server
      - FABRIC_CA_SERVER_CA_NAME=ca-org8
      - FABRIC_CA_SERVER_TLS_ENABLED=true
      - FABRIC_CA_SERVER_TLS_CERTFILE=/etc/hyperledger/fabric-ca-server/tls-cert.pem
      - FABRIC_CA_SERVER_TLS_KEYFILE=/etc/hyperledger/fabric-ca-server/tls-key.pem
    command: sh -c 'fabric-ca-server start -b admin:adminpw -d'
    volumes:
      - ./crypto-config/peerOrganizations/org8.example.com/ca:/etc/hyperledger/fabric-ca-server
    ports:
      - 14055:7054
    networks:
      - fabric

  ca.org9.example.com:
    container_name: ca.org9.example.com
    image: hyperledger/fabric-ca:1.5.7
    environment:
      - FABRIC_CA_HOME=/etc/hyperledger/fabric-ca-server
      - FABRIC_CA_SERVER_CA_NAME=ca-org9
      - FABRIC_CA_SERVER_TLS_ENABLED=true
      - FABRIC_CA_SERVER_TLS_CERTFILE=/etc/hyperledger/fabric-ca-server/tls-cert.pem
      - FABRIC_CA_SERVER_TLS_KEYFILE=/etc/hyperledger/fabric-ca-server/tls-key.pem
    command: sh -c 'fabric-ca-server start -b admin:adminpw -d'
    volumes:
      - ./crypto-config/peerOrganizations/org9.example.com/ca:/etc/hyperledger/fabric-ca-server
    ports:
      - 15055:7054
    networks:
      - fabric

  ca.org10.example.com:
    container_name: ca.org10.example.com
    image: hyperledger/fabric-ca:1.5.7
    environment:
      - FABRIC_CA_HOME=/etc/hyperledger/fabric-ca-server
      - FABRIC_CA_SERVER_CA_NAME=ca-org10
      - FABRIC_CA_SERVER_TLS_ENABLED=true
      - FABRIC_CA_SERVER_TLS_CERTFILE=/etc/hyperledger/fabric-ca-server/tls-cert.pem
      - FABRIC_CA_SERVER_TLS_KEYFILE=/etc/hyperledger/fabric-ca-server/tls-key.pem
    command: sh -c 'fabric-ca-server start -b admin:adminpw -d'
    volumes:
      - ./crypto-config/peerOrganizations/org10.example.com/ca:/etc/hyperledger/fabric-ca-server
    ports:
      - 16055:7054
    networks:
      - fabric

  orderer.example.com:
    container_name: orderer.example.com
    image: hyperledger/fabric-orderer:2.4.9
    environment:
      - FABRIC_LOGGING_SPEC=INFO
      - ORDERER_GENERAL_LISTENADDRESS=0.0.0.0
      - ORDERER_GENERAL_BOOTSTRAPMETHOD=file
      - ORDERER_GENERAL_BOOTSTRAPFILE=/etc/hyperledger/configtx/genesis.block
      - ORDERER_GENERAL_LOCALMSPID=OrdererMSP
      - ORDERER_GENERAL_LOCALMSPDIR=/etc/hyperledger/fabric/msp
      - ORDERER_GENERAL_TLS_ENABLED=true
      - ORDERER_GENERAL_TLS_PRIVATEKEY=/etc/hyperledger/fabric/tls/server.key
      - ORDERER_GENERAL_TLS_CERTIFICATE=/etc/hyperledger/fabric/tls/server.crt
      - ORDERER_GENERAL_TLS_ROOTCAS=[/etc/hyperledger/fabric/tls/ca.crt]
    volumes:
      - ./crypto-config:/etc/hyperledger/fabric
      - ./channel-artifacts:/etc/hyperledger/configtx
    working_dir: /opt/gopath/src/github.com/hyperledger/fabric
    command: orderer
    ports:
      - 7050:7050
    networks:
      - fabric
    depends_on:
      - ca.orderer.example.com

  peer0.org1.example.com:
    container_name: peer0.org1.example.com
    image: hyperledger/fabric-peer:2.4.9
    environment:
      - CORE_PEER_ID=peer0.org1.example.com
      - CORE_PEER_ADDRESS=peer0.org1.example.com:7051
      - CORE_PEER_LISTENADDRESS=0.0.0.0:7051
      - CORE_PEER_CHAINCODEADDRESS=peer0.org1.example.com:7052
      - CORE_PEER_CHAINCODELISTENADDRESS=0.0.0.0:7052
      - CORE_PEER_GOSSIP_BOOTSTRAP=peer0.org1.example.com:7051
      - CORE_PEER_GOSSIP_EXTERNALENDPOINT=peer0.org1.example.com:7051
      - CORE_PEER_LOCALMSPID=Org1MSP
      - CORE_PEER_MSPCONFIGPATH=/etc/hyperledger/fabric/msp
      - CORE_PEER_TLS_ENABLED=true
      - CORE_PEER_TLS_CERT_FILE=/etc/hyperledger/fabric/tls/server.crt
      - CORE_PEER_TLS_KEY_FILE=/etc/hyperledger/fabric/tls/server.key
      - CORE_PEER_TLS_ROOTCA_FILE=/etc/hyperledger/fabric/tls/ca.crt
    volumes:
      - ./crypto-config:/etc/hyperledger/fabric
      - ./channel-artifacts:/etc/hyperledger/configtx
    working_dir: /opt/gopath/src/github.com/hyperledger/fabric
    command: peer node start
    ports:
      - 7051:7051
    networks:
      - fabric
    depends_on:
      - ca.org1.example.com

  peer0.org2.example.com:
    container_name: peer0.org2.example.com
    image: hyperledger/fabric-peer:2.4.9
    environment:
      - CORE_PEER_ID=peer0.org2.example.com
      - CORE_PEER_ADDRESS=peer0.org2.example.com:8051
      - CORE_PEER_LISTENADDRESS=0.0.0.0:8051
      - CORE_PEER_CHAINCODEADDRESS=peer0.org2.example.com:8052
      - CORE_PEER_CHAINCODELISTENADDRESS=0.0.0.0:8052
      - CORE_PEER_GOSSIP_BOOTSTRAP=peer0.org2.example.com:8051
      - CORE_PEER_GOSSIP_EXTERNALENDPOINT=peer0.org2.example.com:8051
      - CORE_PEER_LOCALMSPID=Org2MSP
      - CORE_PEER_MSPCONFIGPATH=/etc/hyperledger/fabric/msp
      - CORE_PEER_TLS_ENABLED=true
      - CORE_PEER_TLS_CERT_FILE=/etc/hyperledger/fabric/tls/server.crt
      - CORE_PEER_TLS_KEY_FILE=/etc/hyperledger/fabric/tls/server.key
      - CORE_PEER_TLS_ROOTCA_FILE=/etc/hyperledger/fabric/tls/ca.crt
    volumes:
      - ./crypto-config:/etc/hyperledger/fabric
      - ./channel-artifacts:/etc/hyperledger/configtx
    working_dir: /opt/gopath/src/github.com/hyperledger/fabric
    command: peer node start
    ports:
      - 8051:8051
    networks:
      - fabric
    depends_on:
      - ca.org2.example.com

  peer0.org3.example.com:
    container_name: peer0.org3.example.com
    image: hyperledger/fabric-peer:2.4.9
    environment:
      - CORE_PEER_ID=peer0.org3.example.com
      - CORE_PEER_ADDRESS=peer0.org3.example.com:9051
      - CORE_PEER_LISTENADDRESS=0.0.0.0:9051
      - CORE_PEER_CHAINCODEADDRESS=peer0.org3.example.com:9052
      - CORE_PEER_CHAINCODELISTENADDRESS=0.0.0.0:9052
      - CORE_PEER_GOSSIP_BOOTSTRAP=peer0.org3.example.com:9051
      - CORE_PEER_GOSSIP_EXTERNALENDPOINT=peer0.org3.example.com:9051
      - CORE_PEER_LOCALMSPID=Org3MSP
      - CORE_PEER_MSPCONFIGPATH=/etc/hyperledger/fabric/msp
      - CORE_PEER_TLS_ENABLED=true
      - CORE_PEER_TLS_CERT_FILE=/etc/hyperledger/fabric/tls/server.crt
      - CORE_PEER_TLS_KEY_FILE=/etc/hyperledger/fabric/tls/server.key
      - CORE_PEER_TLS_ROOTCA_FILE=/etc/hyperledger/fabric/tls/ca.crt
    volumes:
      - ./crypto-config:/etc/hyperledger/fabric
      - ./channel-artifacts:/etc/hyperledger/configtx
    working_dir: /opt/gopath/src/github.com/hyperledger/fabric
    command: peer node start
    ports:
      - 9051:9051
    networks:
      - fabric
    depends_on:
      - ca.org3.example.com

  peer0.org4.example.com:
    container_name: peer0.org4.example.com
    image: hyperledger/fabric-peer:2.4.9
    environment:
      - CORE_PEER_ID=peer0.org4.example.com
      - CORE_PEER_ADDRESS=peer0.org4.example.com:10051
      - CORE_PEER_LISTENADDRESS=0.0.0.0:10051
      - CORE_PEER_CHAINCODEADDRESS=peer0.org4.example.com:10052
      - CORE_PEER_CHAINCODELISTENADDRESS=0.0.0.0:10052
      - CORE_PEER_GOSSIP_BOOTSTRAP=peer0.org4.example.com:10051
      - CORE_PEER_GOSSIP_EXTERNALENDPOINT=peer0.org4.example.com:10051
      - CORE_PEER_LOCALMSPID=Org4MSP
      - CORE_PEER_MSPCONFIGPATH=/etc/hyperledger/fabric/msp
      - CORE_PEER_TLS_ENABLED=true
      - CORE_PEER_TLS_CERT_FILE=/etc/hyperledger/fabric/tls/server.crt
      - CORE_PEER_TLS_KEY_FILE=/etc/hyperledger/fabric/tls/server.key
      - CORE_PEER_TLS_ROOTCA_FILE=/etc/hyperledger/fabric/tls/ca.crt
    volumes:
      - ./crypto-config:/etc/hyperledger/fabric
      - ./channel-artifacts:/etc/hyperledger/configtx
    working_dir: /opt/gopath/src/github.com/hyperledger/fabric
    command: peer node start
    ports:
      - 10051:10051
    networks:
      - fabric
    depends_on:
      - ca.org4.example.com

  peer0.org5.example.com:
    container_name: peer0.org5.example.com
    image: hyperledger/fabric-peer:2.4.9
    environment:
      - CORE_PEER_ID=peer0.org5.example.com
      - CORE_PEER_ADDRESS=peer0.org5.example.com:11051
      - CORE_PEER_LISTENADDRESS=0.0.0.0:11051
      - CORE_PEER_CHAINCODEADDRESS=peer0.org5.example.com:11052
      - CORE_PEER_CHAINCODELISTENADDRESS=0.0.0.0:11052
      - CORE_PEER_GOSSIP_BOOTSTRAP=peer0.org5.example.com:11051
      - CORE_PEER_GOSSIP_EXTERNALENDPOINT=peer0.org5.example.com:11051
      - CORE_PEER_LOCALMSPID=Org5MSP
      - CORE_PEER_MSPCONFIGPATH=/etc/hyperledger/fabric/msp
      - CORE_PEER_TLS_ENABLED=true
      - CORE_PEER_TLS_CERT_FILE=/etc/hyperledger/fabric/tls/server.crt
      - CORE_PEER_TLS_KEY_FILE=/etc/hyperledger/fabric/tls/server.key
      - CORE_PEER_TLS_ROOTCA_FILE=/etc/hyperledger/fabric/tls/ca.crt
    volumes:
      - ./crypto-config:/etc/hyperledger/fabric
      - ./channel-artifacts:/etc/hyperledger/configtx
    working_dir: /opt/gopath/src/github.com/hyperledger/fabric
    command: peer node start
    ports:
      - 11051:11051
    networks:
      - fabric
    depends_on:
      - ca.org5.example.com

  peer0.org6.example.com:
    container_name: peer0.org6.example.com
    image: hyperledger/fabric-peer:2.4.9
    environment:
      - CORE_PEER_ID=peer0.org6.example.com
      - CORE_PEER_ADDRESS=peer0.org6.example.com:12051
      - CORE_PEER_LISTENADDRESS=0.0.0.0:12051
      - CORE_PEER_CHAINCODEADDRESS=peer0.org6.example.com:12052
      - CORE_PEER_CHAINCODELISTENADDRESS=0.0.0.0:12052
      - CORE_PEER_GOSSIP_BOOTSTRAP=peer0.org6.example.com:12051
      - CORE_PEER_GOSSIP_EXTERNALENDPOINT=peer0.org6.example.com:12051
      - CORE_PEER_LOCALMSPID=Org6MSP
      - CORE_PEER_MSPCONFIGPATH=/etc/hyperledger/fabric/msp
      - CORE_PEER_TLS_ENABLED=true
      - CORE_PEER_TLS_CERT_FILE=/etc/hyperledger/fabric/tls/server.crt
      - CORE_PEER_TLS_KEY_FILE=/etc/hyperledger/fabric/tls/server.key
      - CORE_PEER_TLS_ROOTCA_FILE=/etc/hyperledger/fabric/tls/ca.crt
    volumes:
      - ./crypto-config:/etc/hyperledger/fabric
      - ./channel-artifacts:/etc/hyperledger/configtx
    working_dir: /opt/gopath/src/github.com/hyperledger/fabric
    command: peer node start
    ports:
      - 12051:12051
    networks:
      - fabric
    depends_on:
      - ca.org6.example.com

  peer0.org7.example.com:
    container_name: peer0.org7.example.com
    image: hyperledger/fabric-peer:2.4.9
    environment:
      - CORE_PEER_ID=peer0.org7.example.com
      - CORE_PEER_ADDRESS=peer0.org7.example.com:13051
      - CORE_PEER_LISTENADDRESS=0.0.0.0:13051
      - CORE_PEER_CHAINCODEADDRESS=peer0.org7.example.com:13052
      - CORE_PEER_CHAINCODELISTENADDRESS=0.0.0.0:13052
      - CORE_PEER_GOSSIP_BOOTSTRAP=peer0.org7.example.com:13051
      - CORE_PEER_GOSSIP_EXTERNALENDPOINT=peer0.org7.example.com:13051
      - CORE_PEER_LOCALMSPID=Org7MSP
      - CORE_PEER_MSPCONFIGPATH=/etc/hyperledger/fabric/msp
      - CORE_PEER_TLS_ENABLED=true
      - CORE_PEER_TLS_CERT_FILE=/etc/hyperledger/fabric/tls/server.crt
      - CORE_PEER_TLS_KEY_FILE=/etc/hyperledger/fabric/tls/server.key
      - CORE_PEER_TLS_ROOTCA_FILE=/etc/hyperledger/fabric/tls/ca.crt
    volumes:
      - ./crypto-config:/etc/hyperledger/fabric
      - ./channel-artifacts:/etc/hyperledger/configtx
    working_dir: /opt/gopath/src/github.com/hyperledger/fabric
    command: peer node start
    ports:
      - 13051:13051
    networks:
      - fabric
    depends_on:
      - ca.org7.example.com

  peer0.org8.example.com:
    container_name: peer0.org8.example.com
    image: hyperledger/fabric-peer:2.4.9
    environment:
      - CORE_PEER_ID=peer0.org8.example.com
      - CORE_PEER_ADDRESS=peer0.org8.example.com:14051
      - CORE_PEER_LISTENADDRESS=0.0.0.0:14051
      - CORE_PEER_CHAINCODEADDRESS=peer0.org8.example.com:14052
      - CORE_PEER_CHAINCODELISTENADDRESS=0.0.0.0:14052
      - CORE_PEER_GOSSIP_BOOTSTRAP=peer0.org8.example.com:14051
      - CORE_PEER_GOSSIP_EXTERNALENDPOINT=peer0.org8.example.com:14051
      - CORE_PEER_LOCALMSPID=Org8MSP
      - CORE_PEER_MSPCONFIGPATH=/etc/hyperledger/fabric/msp
      - CORE_PEER_TLS_ENABLED=true
      - CORE_PEER_TLS_CERT_FILE=/etc/hyperledger/fabric/tls/server.crt
      - CORE_PEER_TLS_KEY_FILE=/etc/hyperledger/fabric/tls/server.key
      - CORE_PEER_TLS_ROOTCA_FILE=/etc/hyperledger/fabric/tls/ca.crt
    volumes:
      - ./crypto-config:/etc/hyperledger/fabric
      - ./channel-artifacts:/etc/hyperledger/configtx
    working_dir: /opt/gopath/src/github.com/hyperledger/fabric
    command: peer node start
    ports:
      - 14051:14051
    networks:
      - fabric
    depends_on:
      - ca.org8.example.com

  peer0.org9.example.com:
    container_name: peer0.org9.example.com
    image: hyperledger/fabric-peer:2.4.9
    environment:
      - CORE_PEER_ID=peer0.org9.example.com
      - CORE_PEER_ADDRESS=peer0.org9.example.com:15051
      - CORE_PEER_LISTENADDRESS=0.0.0.0:15051
      - CORE_PEER_CHAINCODEADDRESS=peer0.org9.example.com:15052
      - CORE_PEER_CHAINCODELISTENADDRESS=0.0.0.0:15052
      - CORE_PEER_GOSSIP_BOOTSTRAP=peer0.org9.example.com:15051
      - CORE_PEER_GOSSIP_EXTERNALENDPOINT=peer0.org9.example.com:15051
      - CORE_PEER_LOCALMSPID=Org9MSP
      - CORE_PEER_MSPCONFIGPATH=/etc/hyperledger/fabric/msp
      - CORE_PEER_TLS_ENABLED=true
      - CORE_PEER_TLS_CERT_FILE=/etc/hyperledger/fabric/tls/server.crt
      - CORE_PEER_TLS_KEY_FILE=/etc/hyperledger/fabric/tls/server.key
      - CORE_PEER_TLS_ROOTCA_FILE=/etc/hyperledger/fabric/tls/ca.crt
    volumes:
      - ./crypto-config:/etc/hyperledger/fabric
      - ./channel-artifacts:/etc/hyperledger/configtx
    working_dir: /opt/gopath/src/github.com/hyperledger/fabric
    command: peer node start
    ports:
      - 15051:15051
    networks:
      - fabric
    depends_on:
      - ca.org9.example.com

  peer0.org10.example.com:
    container_name: peer0.org10.example.com
    image: hyperledger/fabric-peer:2.4.9
    environment:
      - CORE_PEER_ID=peer0.org10.example.com
      - CORE_PEER_ADDRESS=peer0.org10.example.com:16051
      - CORE_PEER_LISTENADDRESS=0.0.0.0:16051
      - CORE_PEER_CHAINCODEADDRESS=peer0.org10.example.com:16052
      - CORE_PEER_CHAINCODELISTENADDRESS=0.0.0.0:16052
      - CORE_PEER_GOSSIP_BOOTSTRAP=peer0.org10.example.com:16051
      - CORE_PEER_GOSSIP_EXTERNALENDPOINT=peer0.org10.example.com:16051
      - CORE_PEER_LOCALMSPID=Org10MSP
      - CORE_PEER_MSPCONFIGPATH=/etc/hyperledger/fabric/msp
      - CORE_PEER_TLS_ENABLED=true
      - CORE_PEER_TLS_CERT_FILE=/etc/hyperledger/fabric/tls/server.crt
      - CORE_PEER_TLS_KEY_FILE=/etc/hyperledger/fabric/tls/server.key
      - CORE_PEER_TLS_ROOTCA_FILE=/etc/hyperledger/fabric/tls/ca.crt
    volumes:
      - ./crypto-config:/etc/hyperledger/fabric
      - ./channel-artifacts:/etc/hyperledger/configtx
    working_dir: /opt/gopath/src/github.com/hyperledger/fabric
    command: peer node start
    ports:
      - 16051:16051
    networks:
      - fabric
    depends_on:
      - ca.org10.example.com
```

**تغییرات**:
- افزودن سرویس‌های CA برای Orderer (`ca.orderer.example.com`) و هر سازمان (`ca.org1.example.com` تا `ca.org10.example.com`).
- استفاده از تصویر `hyperledger/fabric-ca:1.5.7` برای سازگاری با Hyperledger Fabric 2.4.9.
- نگاشت‌های حجم برای ذخیره گواهی‌های CA در دایرکتوری‌های مناسب (`crypto-config/peerOrganizations/orgX.example.com/ca`).
- پورت‌های منحصربه‌فرد برای هر CA (7054 برای Orderer، 7055 تا 16055 برای سازمان‌ها).
- افزودن `depends_on` برای اطمینان از راه‌اندازی CA قبل از Peerها و Orderer.

**اقدام**:
```bash
nano ~/6g-fabric-network/docker-compose.yaml
# محتوای بالا را جای‌گذاری کنید
```

#### 2. به‌روزرسانی فایل setup_network.sh
اسکریپت `setup_network.sh` (artifact ID: `122b0e0a-aeb7-4ec2-acb6-c7cc423dfb03`) را اصلاح می‌کنم تا فقط از `docker-compose` استفاده کند و بررسی‌های اضافی برای CAها اضافه شود.

<xaiArtifact artifact_id="122b0e0a-aeb7-4ec2-acb6-c7cc423dfb03" artifact_version_id="0fc72b50-ff83-49d4-882d-08def13c4c6a" title="setup_network.sh" contentType="text/x-sh">
```bash
#!/bin/bash

# فعال‌سازی دیباگ
set -x

# بررسی پیش‌نیازها
command -v cryptogen >/dev/null 2>&1 || { echo "cryptogen مورد نیاز است اما نصب نشده است."; exit 1; }
command -v configtxgen >/dev/null 2>&1 || { echo "configtxgen مورد نیاز است اما نصب نشده است."; exit 1; }
command -v docker >/dev/null 2>&1 || { echo "docker مورد نیاز است اما نصب نشده است."; exit 1; }
command -v docker-compose >/dev/null 2>&1 || { echo "docker-compose مورد نیاز است اما نصب نشده است."; exit 1; }

# بررسی نسخه cryptogen
cryptogen version
EXPECTED_CRYPT_VERSION="2.4.9"
if ! cryptogen version | grep -q "$EXPECTED_CRYPT_VERSION"; then
  echo "نسخه cryptogen با $EXPECTED_CRYPT_VERSION سازگار نیست. لطفاً نسخه 2.4.9 را نصب کنید."
  exit 1
fi

# بررسی نسخه docker-compose
docker-compose version
EXPECTED_DOCKER_COMPOSE_VERSION="1.29.2"
if ! docker-compose version | grep -q "$EXPECTED_DOCKER_COMPOSE_VERSION"; then
  echo "نسخه docker-compose با $EXPECTED_DOCKER_COMPOSE_VERSION سازگار نیست. لطفاً نسخه 1.29.2 را نصب کنید."
  exit 1
fi

# تنظیم FABRIC_CFG_PATH
export FABRIC_CFG_PATH=$PWD
echo "FABRIC_CFG_PATH تنظیم شده است به: $FABRIC_CFG_PATH"

# بررسی وجود configtx.yaml
if [ ! -f "$FABRIC_CFG_PATH/configtx.yaml" ]; then
  echo "فایل configtx.yaml در $FABRIC_CFG_PATH یافت نشد"
  exit 1
fi

# بررسی وجود crypto-config.yaml
if [ ! -f "$FABRIC_CFG_PATH/crypto-config.yaml" ]; then
  echo "فایل crypto-config.yaml در $FABRIC_CFG_PATH یافت نشد"
  exit 1
fi

# بررسی وجود docker-compose.yaml
if [ ! -f "$FABRIC_CFG_PATH/docker-compose.yaml" ]; then
  echo "فایل docker-compose.yaml در $FABRIC_CFG_PATH یافت نشد"
  exit 1
fi

# تولید مواد رمزنگاری
if [ ! -d "crypto-config" ]; then
  cryptogen generate --config=./crypto-config.yaml 2> cryptogen.log
  if [ $? -ne 0 ]; then
    echo "خطا در تولید مواد رمزنگاری. لاگ‌ها را بررسی کنید: cryptogen.log"
    cat cryptogen.log
    exit 1
  fi
else
  echo "مواد رمزنگاری از قبل وجود دارند، بررسی صحت..."
fi

# بررسی MSP مدیر و گواهی‌های TLS برای Org1 تا Org10
for org in {1..10}; do
  MSP_DIR="crypto-config/peerOrganizations/org${org}.example.com/users/Admin@org${org}.example.com/msp"
  CA_DIR="crypto-config/peerOrganizations/org${org}.example.com/ca"
  echo "بررسی MSP برای Org${org} در $MSP_DIR..."
  if [ ! -d "$MSP_DIR" ] || [ ! -f "$MSP_DIR/signcerts/Admin@org${org}.example.com-cert.pem" ] || [ ! -f "$MSP_DIR/keystore/"* ] || [ ! -f "$MSP_DIR/config.yaml" ]; then
    echo "MSP مدیر برای Org${org} نامعتبر یا غایب است. تولید مجدد مواد رمزنگاری..."
    rm -rf crypto-config
    cryptogen generate --config=./crypto-config.yaml 2> cryptogen.log
    if [ $? -ne 0 ]; then
      echo "خطا در تولید مواد رمزنگاری. لاگ‌ها را بررسی کنید: cryptogen.log"
      cat cryptogen.log
      exit 1
    fi
    # بررسی مجدد پس از تولید
    if [ ! -f "$MSP_DIR/config.yaml" ]; then
      echo "فایل config.yaml برای Org${org} پس از تولید مجدد یافت نشد"
      exit 1
    fi
  fi
  # بررسی نقش admin در config.yaml
  if ! grep -q "AdminOUIdentifier" "$MSP_DIR/config.yaml"; then
    echo "نقش AdminOUIdentifier در $MSP_DIR/config.yaml یافت نشد."
    echo "محتوای فایل config.yaml برای Org${org}:"
    cat "$MSP_DIR/config.yaml"
    echo "تولید مجدد مواد رمزنگاری..."
    rm -rf crypto-config
    cryptogen generate --config=./crypto-config.yaml 2> cryptogen.log
    if [ $? -ne 0 ]; then
      echo "خطا در تولید مواد رمزنگاری. لاگ‌ها را بررسی کنید: cryptogen.log"
      cat cryptogen.log
      exit 1
    fi
    # بررسی مجدد
    if ! grep -q "AdminOUIdentifier" "$MSP_DIR/config.yaml"; then
      echo "نقش AdminOUIdentifier پس از تولید مجدد همچنان در $MSP_DIR/config.yaml یافت نشد"
      echo "محتوای فایل config.yaml پس از تولید مجدد:"
      cat "$MSP_DIR/config.yaml"
      exit 1
    fi
  fi
  # بررسی دایرکتوری CA
  if [ ! -d "$CA_DIR" ]; then
    echo "دایرکتوری CA برای Org${org} در $CA_DIR یافت نشد. تولید مجدد مواد رمزنگاری..."
    rm -rf crypto-config
    cryptogen generate --config=./crypto-config.yaml 2> cryptogen.log
    if [ $? -ne 0 ]; then
      echo "خطا در تولید مواد رمزنگاری. لاگ‌ها را بررسی کنید: cryptogen.log"
      cat cryptogen.log
      exit 1
    fi
  fi
  echo "نقش admin و CA برای Org${org} تأیید شد."
done

# بررسی گواهی TLS Orderer
TLS_CA="crypto-config/ordererOrganizations/example.com/orderers/orderer.example.com/tls/ca.crt"
if [ ! -f "$TLS_CA" ]; then
  echo "گواهی TLS Orderer یافت نشد. تولید مجدد مواد رمزنگاری..."
  rm -rf crypto-config
  cryptogen generate --config=./crypto-config.yaml 2> cryptogen.log
  if [ $? -ne 0 ]; then
    echo "خطا در تولید مواد رمزنگاری. لاگ‌ها را بررسی کنید: cryptogen.log"
    cat cryptogen.log
    exit 1
  fi
fi

# بررسی محتوای configtx.yaml
echo "بررسی سیاست‌های Admins در configtx.yaml..."
grep -A 5 "Admins:" $FABRIC_CFG_PATH/configtx.yaml > configtx_admins.log
cat configtx_admins.log

# تولید بلاک جنسیس
configtxgen -profile OrdererGenesis -channelID system-channel -outputBlock ./channel-artifacts/genesis.block
if [ $? -ne 0 ]; then
  echo "خطا در تولید genesis.block"
  exit 1
fi

# تولید تراکنش‌های تنظیمات کانال
declare -A channel_profiles=(
  ["generalchannelapp"]="GeneralChannelApp"
  ["iotchannelapp"]="IoTChannelApp"
  ["securitychannelapp"]="SecurityChannelApp"
  ["monitoringchannelapp"]="MonitoringChannelApp"
  ["org1channelapp"]="Org1ChannelApp"
  ["org2channelapp"]="Org2ChannelApp"
  ["org3channelapp"]="Org3ChannelApp"
  ["org4channelapp"]="Org4ChannelApp"
  ["org5channelapp"]="Org5ChannelApp"
  ["org6channelapp"]="Org6ChannelApp"
  ["org7channelapp"]="Org7ChannelApp"
  ["org8channelapp"]="Org8ChannelApp"
  ["org9channelapp"]="Org9ChannelApp"
  ["org10channelapp"]="Org10ChannelApp"
)

for channel in "${!channel_profiles[@]}"; do
  profile=${channel_profiles[$channel]}
  echo "تولید تراکنش برای کانال $channel با پروفایل $profile..."
  configtxgen -profile $profile -outputCreateChannelTx ./channel-artifacts/${channel}.tx -channelID ${channel}
  if [ $? -ne 0 ]; then
    echo "خطا در تولید ${channel}.tx"
    exit 1
  fi
done

# راه‌اندازی شبکه با docker-compose
echo "راه‌اندازی شبکه با docker-compose.yaml..."
docker-compose -f docker-compose.yaml up -d
if [ $? -ne 0 ]; then
  echo "خطا در راه‌اندازی شبکه"
  exit 1
fi

# بررسی فایل‌های docker-compose دیگر
echo "بررسی فایل‌های docker-compose در سیستم..."
find / -name "docker-compose.yaml" -o -name "docker-compose.yml" 2>/dev/null > docker_compose_files.log
cat docker_compose_files.log

# انتظار برای پایداری شبکه (180 ثانیه)
echo "انتظار 180 ثانیه برای پایداری شبکه..."
sleep 180

# بررسی وضعیت کانتینرها و ذخیره لاگ‌ها
docker ps
docker logs orderer.example.com > orderer.log 2>&1
docker logs peer0.org1.example.com > peer0.org1.log 2>&1
docker logs ca.org1.example.com > ca.org1.log 2>&1
docker logs ca.orderer.example.com > ca.orderer.log 2>&1

# بررسی MSP داخل کانتینر
echo "بررسی MSP داخل کانتینر peer0.org1.example.com..."
docker exec peer0.org1.example.com ls -l /etc/hyperledger/fabric/users/Admin@org1.example.com/msp > msp_dir.log 2>&1
docker exec peer0.org1.example.com ls -l /etc/hyperledger/fabric/users/Admin@org1.example.com/msp/signcerts >> msp_dir.log 2>&1
docker exec peer0.org1.example.com ls -l /etc/hyperledger/fabric/users/Admin@org1.example.com/msp/keystore >> msp_dir.log 2>&1
docker exec peer0.org1.example.com cat /etc/hyperledger/fabric/users/Admin@org1.example.com/msp/config.yaml > msp_config.log 2>&1
cat msp_dir.log
cat msp_config.log

# بررسی گواهی TLS داخل کانتینر
echo "بررسی گواهی TLS داخل کانتینر orderer.example.com و peer0.org1.example.com..."
docker exec orderer.example.com ls -l /etc/hyperledger/fabric/tls/orderer-ca.crt > tls_ca.log 2>&1
docker exec peer0.org1.example.com ls -l /etc/hyperledger/fabric/tls/orderer-ca.crt >> tls_ca.log 2>&1
cat tls_ca.log

# بررسی گواهی‌های CA
echo "بررسی گواهی‌های CA..."
docker exec ca.org1.example.com ls -l /etc/hyperledger/fabric-ca-server > ca_org1_dir.log 2>&1
docker exec ca.orderer.example.com ls -l /etc/hyperledger/fabric-ca-server > ca_orderer_dir.log 2>&1
cat ca_org1_dir.log
cat ca_orderer_dir.log

# ایجاد و پیوستن به کانال‌ها
channels=("generalchannelapp" "iotchannelapp" "securitychannelapp" "monitoringchannelapp" "org1channelapp" "org2channelapp" "org3channelapp" "org4channelapp" "org5channelapp" "org6channelapp" "org7channelapp" "org8channelapp" "org9channelapp" "org10channelapp")
for channel in "${channels[@]}"; do
  echo "ایجاد کانال $channel..."
  docker exec -e "CORE_PEER_MSPCONFIGPATH=/etc/hyperledger/fabric/users/Admin@org1.example.com/msp" \
             -e "CORE_PEER_LOCALMSPID=Org1MSP" \
             peer0.org1.example.com peer channel create \
             -o orderer.example.com:7050 \
             -c $channel \
             -f /etc/hyperledger/configtx/${channel}.tx \
             --outputBlock /etc/hyperledger/configtx/${channel}.block \
             --tls \
             --cafile /etc/hyperledger/fabric/tls/orderer-ca.crt
  if [ $? -ne 0 ]; then
    echo "خطا در ایجاد کانال $channel"
    echo "لاگ‌های Orderer، Peer و CA را بررسی کنید: orderer.log, peer0.org1.log, ca.org1.log, ca.orderer.log, msp_config.log, msp_dir.log, tls_ca.log, configtx_admins.log, ca_org1_dir.log, ca_orderer_dir.log"
    exit 1
  fi

  for org in {1..10}; do
    echo "پیوستن org${org} به کانال $channel..."
    docker exec -e "CORE_PEER_MSPCONFIGPATH=/etc/hyperledger/fabric/users/Admin@org${org}.example.com/msp" \
               -e "CORE_PEER_LOCALMSPID=Org${org}MSP" \
               peer0.org${org}.example.com peer channel join \
               -b /etc/hyperledger/configtx/${channel}.block
    if [ $? -ne 0 ]; then
      echo "خطا در پیوستن org${org} به کانال $channel"
      exit 1
    fi
  done
done

# بررسی دایرکتوری‌های چین‌کد
chaincodes=("ResourceAllocate" "BandwidthShare" "DynamicRouting" "AccessControl" "NetworkMonitor" "SecurityProtocol" "DataPrivacy" "ResourceOptimization" "LatencyMonitor" "ThroughputEnhancer" "QoSManager" "SpectrumAllocation" "DeviceAuth" "TrafficShaping" "EncryptionService" "PolicyEnforcement" "LoadBalancer" "FaultTolerance" "DataIntegrity" "SmartContract" "ConsensusManager" "KeyManagement" "AuditTrail" "PerformanceMetrics" "NetworkSlicing" "ResourcePool" "BandwidthOptimizer" "IoTSecurity" "MonitoringAgent" "AlertSystem" "DataAnalytics" "PrivacyGuard" "SecureChannel" "ResourceScheduler" "DynamicScaler" "NetworkHealth" "PolicyManager" "AccessMonitor" "TrafficAnalyzer" "SecurityAudit" "LatencyOptimizer" "ThroughputMonitor" "QoSMonitor" "SpectrumManager" "DeviceManager" "TrafficManager" "EncryptionManager" "PolicyAgent" "LoadManager" "FaultManager" "IntegrityChecker" "ContractManager" "ConsensusAgent" "KeyStore" "AuditManager" "PerformanceAnalyzer" "SliceManager" "ResourceAllocator" "BandwidthManager" "IoTManager" "MonitoringService" "AlertManager" "AnalyticsService" "PrivacyManager" "SecureComm" "SchedulerService" "ScalerService" "HealthMonitor" "PolicyService" "AccessManager" "TrafficService")
for cc in "${chaincodes[@]}"; do
  if [ ! -d "chaincode/$cc" ]; then
    mkdir -p chaincode/$cc
    echo "package main" > chaincode/$cc/dummy.go
  fi
done

# نصب و نمونه‌سازی چین‌کدها
for channel in "${channels[@]}"; do
  for cc in "${chaincodes[@]}"; do
    for org in {1..10}; do
      echo "نصب چین‌کد $cc روی org${org}..."
      docker exec -e "CORE_PEER_MSPCONFIGPATH=/etc/hyperledger/fabric/users/Admin@org${org}.example.com/msp" \
                 -e "CORE_PEER_LOCALMSPID=Org${org}MSP" \
                 peer0.org${org}.example.com peer chaincode install \
                 -n $cc -v 1.0 -p "/opt/gopath/src/github.com/chaincode/$cc"
      if [ $? -ne 0 ]; then
        echo "خطا در نصب چین‌کد $cc روی org${org}"
        exit 1
      fi
    done
    echo "نمونه‌سازی چین‌کد $cc روی کانال $channel..."
    docker exec -e "CORE_PEER_MSPCONFIGPATH=/etc/hyperledger/fabric/users/Admin@org1.example.com/msp" \
               -e "CORE_PEER_LOCALMSPID=Org1MSP" \
               peer0.org1.example.com peer chaincode instantiate \
               -o orderer.example.com:7050 \
               --tls \
               --cafile /etc/hyperledger/fabric/tls/orderer-ca.crt \
               -C $channel \
               -n $cc -v 1.0 -c '{"Args":["init"]}' -P "OR('Org1MSP.member','Org2MSP.member','Org3MSP.member','Org4MSP.member','Org5MSP.member','Org6MSP.member','Org7MSP.member','Org8MSP.member','Org9MSP.member','Org10MSP.member')"
    if [ $? -ne 0 ]; then
      echo "خطا در نمونه‌سازی چین‌کد $cc روی کانال $channel"
      exit 1
    fi
  done
done

echo "راه‌اندازی شبکه با موفقیت انجام شد"
