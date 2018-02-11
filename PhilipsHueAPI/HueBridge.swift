public class HueBridge {
    
    public let ip: String
    public var username: String? {
        didSet {
            self.hueAPI.username = username
        }
    }
    
    var hueAPI: HueClient
    
    public init(ip: String, username: String? = nil, session: URLSessionProtocol = URLSession.shared) {
        self.ip = ip
        self.username = username
        
        self.hueAPI = HueClient(withHostname: ip, username: username, session: session)
    }
    
    public func register(applicationWithName appName: String, deviceName: String, completion: @escaping (_ result: ConnectionResult<String, String>) -> Void) {
        self.hueAPI.register(applicationWithName: appName, deviceName: deviceName, completion: completion)
    }
    
    public func getGroups(completion: @escaping (_ result: ConnectionResult<[HueGroup], String>) -> Void) {
        
        let url = self.hueAPI.apiURL.appendingPathComponent("groups")
        self.hueAPI.getObjects(HueGroup.self, url: url, completion: completion)
    }
    
    public func getLights(completion: @escaping (_ result: ConnectionResult<[HueLight], String>) -> Void) {
        
        let url = self.hueAPI.apiURL.appendingPathComponent("lights")
        self.hueAPI.getObjects(HueLight.self, url: url, completion: completion)
    }
    
    public func updateLight(light: HueLight, completion: @escaping (_ result: ConnectionResult<HueLight, String>) -> Void) {
        
        let url = self.hueAPI.apiURL.appendingPathComponent("lights").appendingPathComponent(light.identifier)
        self.hueAPI.getObject(HueLight.self, id: light.identifier, url: url, completion: completion)
    }
    
    public func getSensors(completion: @escaping (_ result: ConnectionResult<[HueSensor], String>) -> Void) {
        
        let url = self.hueAPI.apiURL.appendingPathComponent("sensors")
        self.hueAPI.getObjects(HueSensor.self, url: url, completion: completion)
    }
    
    public func getSchedules(completion: @escaping (_ result: ConnectionResult<[HueSchedule], String>) -> Void) {
        
        let url = self.hueAPI.apiURL.appendingPathComponent("schedules")
        self.hueAPI.getObjects(HueSchedule.self, url: url, completion: completion)
    }
    
    public func getRules(completion: @escaping (_ result: ConnectionResult<[HueRule], String>) -> Void) {
        
        let url = self.hueAPI.apiURL.appendingPathComponent("rules")
        self.hueAPI.getObjects(HueRule.self, url: url, completion: completion)
    }
}
