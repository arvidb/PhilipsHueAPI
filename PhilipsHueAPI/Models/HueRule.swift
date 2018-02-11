public struct HueRule : Codable, HuePeripheral {
    
    public var identifier: String = ""
    
    public let name: String
    let lasttriggered: String
    let creationtime: String
    let timestriggered: Int
    let owner: String
    let status: String
    
    enum CodingKeys: String, CodingKey {
        case name, lasttriggered, creationtime, timestriggered, owner, status
    }
    
    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        name = try values.decode(.name, default: "")
        lasttriggered = try values.decode(.lasttriggered, default: "")
        creationtime = try values.decode(.creationtime, default: "")
        timestriggered = try values.decode(.timestriggered, default: 0)
        owner = try values.decode(.owner, default: "")
        status = try values.decode(.status, default: "")
    }
}

