public struct HueLightState: Codable {
    public let on: Bool
    public let bri: Int
    public let ct: Int
    public let alert: String
    public let colormode: String
    public let mode: String
    public let reachable: Bool
    
    enum CodingKeys: String, CodingKey {
        case on, bri, ct, alert, colormode, mode, reachable
    }
    
    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        on = try values.decode(.on, default: false)
        bri = try values.decode(.bri, default: 0)
        ct = try values.decode(.ct, default: 0)
        alert = try values.decode(.alert, default: "")
        colormode = try values.decode(.colormode, default: "")
        mode = try values.decode(.mode, default: "")
        reachable = try values.decode(.reachable, default: false)
    }
}
    
public struct HueLight : Codable, HuePeripheral {
    
    public var identifier: String = ""
    
    public var state: HueLightState?
    public let type: String
    public let name: String
    public let modelid: String
    public let swversion: String
    
    enum CodingKeys: String, CodingKey {
        case state, type, name, modelid, swversion
    }
    
    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        type = try values.decode(.type, default:"")
        name = try values.decode(.name, default:"")
        modelid = try values.decode(.modelid, default:"")
        swversion = try values.decode(.swversion, default:"")
        state = try values.decode(.state, default:nil)
    }
}
