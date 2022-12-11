import Foundation

// HTTPRequest struct only contains one property: storage. So it only requires one reference count of the internal storage instance to be incremented on copy. Storage is a reference type
struct HTTPRequest {
    fileprivate class Storage {
        var path: String
        var headers: [String: String]
        init(path: String, headers: [String: String]) {
            self.path = path
            self.headers = headers
        }
    }

    private var storage: Storage // reference type

    init(path: String, headers: [String: String]) {
        storage = Storage(path: path, headers: headers)
    }
}

extension HTTPRequest.Storage {
    func copy() -> HTTPRequest.Storage {
        print("Making a copy...") // For debugging
        return HTTPRequest.Storage(path: path, headers: headers)
    }
}

// To expose the path and headers property of the internal storage instance:

extension HTTPRequest {
    // wraping the logic of checking whether storage is uniquely referenced before mutating it
    private var storageForWriting: HTTPRequest.Storage {
        mutating get {
            if !isKnownUniquelyReferenced(&storage) {
                self.storage = storage.copy()
            }
            return storage
        }
    }

    var path: String {
        get { return storage.path }
        set { storageForWriting.path = newValue }
    }

    var headers: [String: String] {
        get { return storage.headers }
        set { storageForWriting.headers = newValue }
    }
}

// HTTPRequest struct is now entirely backed by a class instance, but it still exhibits value semantics as if all its properties were properties on the struct itself

final public class FernandoCopyOnWrite {
    public static func main() {
        var req1 = HTTPRequest(path: "/home", headers: [:])
        var req2 = req1
        
        req2.path = "/users" // Copy will be made because a change occurs
        assert(req1.path == "/home") // passes
        
        let req3 = req1
        req1.path = "/test"
        
        assert(req2.path == "/users")
        assert(req3.path == "/home")
        
        var req4 = HTTPRequest(path: "/home", headers: [:])
        var copy = req4
        for x in 0..<5 { // Making a copy should be called only once (when we mutate req3 for the first time)
            req4.headers["X-RequestId"] = "\(x)"
        }
    }
}
