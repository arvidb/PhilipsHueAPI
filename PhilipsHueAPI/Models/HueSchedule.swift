public struct HueSchedule : Codable, HuePeripheral {
    
    public var identifier: String = ""
    
    public let name: String
    let description: String
    let time: String
    let created: String
    let status: String
    let autodelete: Bool
    let starttime: String
    
    enum CodingKeys: String, CodingKey {
        case name, description, time, created, status, autodelete, starttime
    }
    
    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        name = try values.decode(.name, default: "")
        description = try values.decode(.description, default: "")
        time = try values.decode(.time, default: "")
        created = try values.decode(.created, default: "")
        status = try values.decode(.status, default: "")
        autodelete = try values.decode(.autodelete, default: false)
        starttime = try values.decode(.starttime, default: "")
    }
}
