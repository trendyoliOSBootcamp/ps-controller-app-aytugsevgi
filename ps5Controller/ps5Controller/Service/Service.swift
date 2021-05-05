import UIKit

enum ServiceError: Error {
    case noDataAvailable
    case canNotProcessData
}

final class Service {
    
    func fetchProductList(completion: @escaping(Result<[Product], ServiceError>) -> Void) {
        // some fetching process
        let products: [Product] = [.init(name: "Dual Sense", description: "Official PS5 controller", image: "dualSenseBlack"),
                                   .init(name: "Dual Sense", description: "Official PS5 controller", image: "dualSenseWhite"),
                                   .init(name: "Dual Sense", description: "Official PS5 controller", image: "dualSenseBlack"),
                                   .init(name: "Dual Sense", description: "Official PS5 controller", image: "dualSenseBlack")]
        completion(.success(products))
    }
}
