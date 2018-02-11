import XCTest
import PhilipsHueAPI

class PhilipsHueAPITests: XCTestCase {
    
    let mockSession = MockURLSession()
    var bridge: HueBridge!
    
    override func setUp() {
        super.setUp()
        
        bridge = HueBridge(ip: "localhost", username: "test", session: mockSession)
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    
    func testHueAPIShouldReturnFailureOnEmptyData() {

        let dataTask = MockURLSessionDataTask()
        mockSession.nextDataTask = dataTask
        
        let responseExpectation = self.expectation(description: "Response")
        bridge.getLights { (result) in
            
            switch(result) {
            case .success( _):
                assert(false)
            case .failure(let error):
                assert(error == "No data returned")
            }
            
            responseExpectation.fulfill()
        }
        
        assert(dataTask.resumeWasCalled)
        assert(mockSession.lastURL == URL(string: "http://localhost/api/test/lights")!)
        
        self.wait(for: [responseExpectation], timeout: 1)
    }
    
    func testGetLightsShouldReturnAvailableLights() {
        
        let dataTask = MockURLSessionDataTask()
        dataTask.data = """
            {
                "1": {
                    "state": {
                        "on": true,
                        "bri": 144,
                        "hue": 13088,
                        "sat": 212,
                        "xy": [0.5128,0.4147],
                        "ct": 467,
                        "alert": "none",
                        "effect": "none",
                        "colormode": "xy",
                        "reachable": true
                    },
                    "type": "Extended color light",
                    "name": "Hue Lamp 1",
                    "modelid": "LCT001",
                    "swversion": "66009461"
                },
                "2": {
                    "state": {
                        "on": false,
                        "bri": 0,
                        "hue": 0,
                        "sat": 0,
                        "xy": [0,0],
                        "ct": 0,
                        "alert": "none",
                        "effect": "none",
                        "colormode": "hs",
                        "reachable": true
                    },
                    "type": "Extended color light",
                    "name": "Hue Lamp 2",
                    "modelid": "LCT001",
                    "swversion": "66009461"
                }
            }
        """.data(using: String.Encoding.utf8)
        
        mockSession.nextDataTask = dataTask
        
        let responseExpectation = self.expectation(description: "Response")
        bridge.getLights { (result) in
            
            switch(result) {
            case .success(let success):
                assert(success.count == 2)
            case .failure( _):
                assert(false)
            }
            
            responseExpectation.fulfill()
        }
        
        assert(dataTask.resumeWasCalled)
        assert(mockSession.lastURL == URL(string: "http://localhost/api/test/lights")!)
        
        self.wait(for: [responseExpectation], timeout: 1)
    }
}
