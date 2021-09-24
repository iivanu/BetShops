//
//  NetworkApiClient.swift
//  BetShops
//
//  Created by Ivan Ivanušić on 27.08.2021..
//

import Foundation


class NetworkApiClient {
    
    static let client = NetworkApiClient()
    
    func getBetShops(north: Double, east: Double, south: Double, west: Double, completion: ((BetShops?) -> Void)?) {
        ApiManager.client.request(.search(for: .getBetShops(north: north, east: east, south: south, west: west))) { (data) in
            DispatchQueue.main.async {
                completion?(self.processResults(data: data))
            }
        }
    }
    
    private func processResults(data: Data) -> BetShops? {
        do {
            let betShops = try JSONDecoder().decode(BetShops.self, from: data)
            return betShops
        } catch {
            return nil
        }
    }
}
