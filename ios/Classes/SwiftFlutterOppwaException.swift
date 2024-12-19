import Foundation

class SwiftFlutterOppwaException: Error {
    var errorCode: String
    var message: String?
    init(errorCode: String, message: String?) {
        self.errorCode   = errorCode
        self.message = message
    }
}
