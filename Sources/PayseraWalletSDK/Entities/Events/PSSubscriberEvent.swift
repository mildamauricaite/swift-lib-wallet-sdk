import Foundation
import ObjectMapper

public class PSSubscriberEvent: Mappable {
    public var event: String?
    public var object: String?
    public var parameters: [String : Any]?
    
    public init() {}
    
    public init(event: String, object: String, parameters: [String : Any]?) {
        self.event = event
        self.object = object
        self.parameters = parameters
    }
    
    required public init?(map: Map) {
    }
    
    public func mapping(map: Map) {
        event       <- map["event"]
        object      <- map["object"]
        parameters  <- map["parameters"]
    }
}

extension PSSubscriberEvent: Equatable {
    public static func == (lhs: PSSubscriberEvent, rhs: PSSubscriberEvent) -> Bool {
        guard
            lhs.event == rhs.event,
            lhs.object == rhs.object
        else {
            return false
        }
        
        if lhs.parameters == nil && rhs.parameters == nil {
            return true
        }
        
        guard
            let lParameters = lhs.parameters,
            let rParameters = rhs.parameters
        else { return false }
        
        return NSDictionary(dictionary: lParameters).isEqual(to: rParameters)
    }
}

extension PSSubscriberEvent {
    public func getDirection() -> PSWalletEventDirection {
        guard
            let parameters = parameters,
            let directionParameter = parameters["direction"] as? String,
            let eventDirection = PSWalletEventDirection(rawValue: directionParameter)
        else { return .both }
        return eventDirection
    }
}
