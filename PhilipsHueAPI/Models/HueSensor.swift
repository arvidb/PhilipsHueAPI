public enum HueSensorType: String, Codable {
    case Unknown, Daylight, Geofence
    case ZGPSwitch, ZLLSwitch, ZLLPresence, ZLLTemperature, ZLLLightLevel
    case ClipSwitch = "Clip Switch", CLIPOpenClose, CLIPPresence, CLIPTemperature, CLIPHumidity, CLIPGenericFlag, CLIPGenericStatus
}

public struct HueSensor : Codable, HuePeripheral {
    
    public var identifier: String = ""
    
    public let type: HueSensorType
    public let name: String
    public let modelid: String
    
    enum CodingKeys: String, CodingKey {
        case type
        case name
        case modelid
    }
    
    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        type = try values.decodeIfPresent(HueSensorType.self, forKey: .type) ?? .Unknown
        name = try values.decode(String.self, forKey: .name)
        modelid = try values.decode(String.self, forKey: .modelid)
    }
}
