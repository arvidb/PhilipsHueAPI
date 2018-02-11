public enum HueGroupClass : String, Codable {
    case LivinigRoom = "Living room", Kitchen, Dining, Bedroom, KidsBedroom = "Kids bedroom"
    case Bathroom, Nursery, Recreation, Office, Gym, Hallway, Toilet, FrontDoor = "Front door", Garage
    case Terrace, Garden, Driveway, Carport, Other
}
    
public struct HueGroup : Codable, HuePeripheral {
    
    public var identifier: String = ""
    
    let type: String
    public let name: String
    let lights: [String]
    
    let `class`: HueGroupClass?
    
    enum CodingKeys: String, CodingKey {
        case type, name, lights, `class`
    }
    
    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        type = try values.decode(.type, default: "")
        name = try values.decode(.type, default: "")
        lights = try values.decode(.lights, default: [String]())
        
        `class` = try values.decode(.class, default: nil)
    }
}
