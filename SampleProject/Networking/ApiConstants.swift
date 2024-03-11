import Foundation

struct ApiConstants {
    static let baseApiURL = URL(string: "https://api.simkl.com")!

    static let clientID: String = {
        Bundle.main.infoDictionary!["API_CLIENT_ID"] as! String
    }()
    
    static let imageBaseURL = URL(string: "https://wsrv.nl/")!
    static let imageContentBaseURL = URL(string: "https://simkl.in/")!
}
