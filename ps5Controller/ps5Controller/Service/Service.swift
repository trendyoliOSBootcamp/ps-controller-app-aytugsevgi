import UIKit

enum ServiceError: Error {
    case noDataAvailable
    case canNotProcessData
}

final class Service {
    func fetchProductList(type: HomeTabType, completion: @escaping(Result<[Product], ServiceError>) -> Void) {
        // some fetching process
        var products = [Product]()
        switch type {
        case .controller:
            products = [.init(name: "Dual Sense", description: "Official PS5 controller", image: "dualSenseBlack"),
                                      .init(name: "Dual Sense", description: "Official PS5 controller", image: "dualSenseWhite"),
                                      .init(name: "Dual Sense", description: "Official PS5 controller", image: "dualSenseBlack"),
                                      .init(name: "Dual Sense", description: "Official PS5 controller", image: "dualSenseBlack")]
        case .switcher:
            products = [.init(name: "Dual Switch", description: "Official PS5 switch", image: "dualSenseWhite"),
                                      .init(name: "Dual Switch", description: "Official PS5 controller", image: "dualSenseWhite"),
                                      .init(name: "Dual Switch", description: "Official PS5 switch", image: "dualSenseBlack"),
                                      .init(name: "Dual Switch", description: "Official PS5 switch", image: "dualSenseBlack")]
        case .mouse:
            products = [.init(name: "Dual Mouse", description: "Official PS5 mouse", image: "dualSenseBlack"),
                                      .init(name: "Dual Mouse", description: "Official PS5 mouse", image: "dualSenseBlack"),
                                      .init(name: "Dual Mouse", description: "Official PS5 mouse", image: "dualSenseBlack"),
                                      .init(name: "Dual Mouse", description: "Official PS5 mouse", image: "dualSenseBlack")]
        }
        completion(.success(products))
    }
}
