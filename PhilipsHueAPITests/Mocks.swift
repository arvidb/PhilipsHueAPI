import PhilipsHueAPI

class MockURLSession: URLSessionProtocol {
    var nextDataTask = MockURLSessionDataTask()
    private (set) var lastURL: URL?
    
    func dataTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTaskProtocol {
        lastURL = url
        nextDataTask.completionHandler = completionHandler
        return nextDataTask
    }
}

class MockURLSessionDataTask: URLSessionDataTaskProtocol {
    private (set) var resumeWasCalled = false
    
    var data: Data?
    var response: URLResponse?
    var error: Error?
    
    var completionHandler: ((Data?, URLResponse?, Error?) -> Void)?
    
    func resume() {
        resumeWasCalled = true
        
        completionHandler?(data, response, error)
    }
}
