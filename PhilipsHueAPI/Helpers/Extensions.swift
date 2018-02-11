extension Array {
    func unique<T:Hashable>(key: ((Element) -> (T)))  -> [Element] {
        
        let uniqueDict = self.reduce(into: [:]) {
            $0[key($1)] = $1
        }
        return Array(uniqueDict.values)
    }
}

extension KeyedDecodingContainer {
    func decode<T>(_ key: K, default: T) throws -> T where T: Codable {
        return try self.decodeIfPresent(T.self, forKey: key) ?? `default`
    }
    
    func decode<T>(_ key: K) throws -> T where T: Codable {
        return try self.decode(T.self, forKey: key)
    }
}

extension Array where Element == String {
    func join(with other: [HuePeripheral]) -> Array<HuePeripheral> {
        
        let result = self.map({ (id) -> HuePeripheral? in
            other.first(where: { (o) -> Bool in
                return o.identifier == id
            })
        })
        return result.flatMap { $0 }
    }
}

//extension Array {
//    func join<T: Hashable>(key: ((Element) -> (T)), other: [T]) -> Array<Element> {
//
//        let result = other.map { (t) -> Element? in
//            self.first(where: { (obj) -> Bool in
//                return key(obj) == t
//            })
//        }
//
//        return result.flatMap { $0 }
//    }
//}

