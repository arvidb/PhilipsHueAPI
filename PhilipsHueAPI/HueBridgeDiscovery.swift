import Socket

public class HueBridgeDiscovery {
    
    public init() {
    }
    
    public func discoverBridges(withTimeout duration: TimeInterval = 5, completion:@escaping (_ result: ConnectionResult<[HueBridge], String>) -> Void) {
    
        let message = "M-SEARCH * HTTP/1.1\r\n" +
                    "HOST:239.255.255.250:1900\r\n" +
                    "ST:upnp:rootdevice\r\n" +
                    "MX:\(duration)\r\n" +
                    "MAN:\"ssdp:discover\"\r\n"
        
        var socket: Socket? = nil
        do {
            socket = try Socket.create(type: .datagram, proto: .udp)
            guard let socket = socket else {
                completion(.failure("Failed to create socket"))
                return
            }
            
            try socket.listen(on: 0)
            try socket.setReadTimeout(value: 2)
            
            let queue = DispatchQueue.global()
            var discovering = true
            
            queue.async() {
                
                do {
                    var foundBridges = [HueBridge]()
                    repeat {
                        var data = Data()
                        let (bytesRead, address) = try socket.readDatagram(into: &data)

                        if bytesRead > 0 {
                            if let response = String(data: data, encoding: .utf8) {
                                if response.range(of: "IpBridge") != nil {
                                    let (remoteHost, _) = Socket.hostnameAndPort(from: address!)!
                                    foundBridges.append(HueBridge(ip: remoteHost))
                                }
                            }
                        }
                    } while discovering
                    
                    socket.close()
                    completion(.success(foundBridges.unique{ $0.ip }))
                    
                } catch let error {
                    socket.close()
                    completion(.failure(error.localizedDescription))
                }
            }
            
            queue.asyncAfter(deadline: .now() + duration) {
                discovering = false
            }
    
            try socket.write(from: message, to: Socket.createAddress(for: "239.255.255.250", on: 1900)!)
        
        } catch let error {
            socket?.close()
            completion(.failure(error.localizedDescription))
        }
    }
}
