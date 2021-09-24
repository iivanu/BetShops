//
//  NetworkApiManager.swift
//  BetShops
//
//  Created by Ivan Ivanušić on 27.08.2021..
//

import Foundation

enum Path {
    case getBetShops(north: Double, east: Double, south: Double, west: Double)
}

enum HTTPMethod: String {
    case get
    var string: String {
        switch self {
        case .get:
            return "GET"
        }
    }
}

enum ContentType: String {
    case json = "application/json"
}

struct Endpoint {
    let path: Path
    let method: HTTPMethod
    let accept: ContentType
    var queryItems: [URLQueryItem]
    
    static func search(for path: Path) -> Endpoint {
        switch path {
        case .getBetShops(let north, let east, let south, let west):
            return Endpoint(
                path: path,
                method: .get,
                accept: .json,
                queryItems: [URLQueryItem(name: "boundingBox", value: "\(north),\(east),\(south),\(west)")])
        }
    }
    
    var url: URL? {
        var components = URLComponents()
        switch path {
        case .getBetShops:
            components.scheme = "https"
            components.host = "interview.superology.dev"
            components.path = "/betshops"
        }
        
        components.queryItems = queryItems
        
        return components.url
    }
}

class ApiManager {
    static var client = ApiManager()
    
    func request(_ endpoint: Endpoint, handler: @escaping ((Data) -> Void)) {
        guard let url = endpoint.url else {
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = endpoint.method.string
        request.setValue(endpoint.accept.rawValue, forHTTPHeaderField: "Accept")
        let session = URLSession(configuration: .default)
        
        let task = session.dataTask(with: request) { data, urlResponse, error in
            if let errorUnwrapped = error {
                print("Error: \(errorUnwrapped.localizedDescription)")
                return
            }
            
            if let httpResponse = urlResponse as? HTTPURLResponse, httpResponse.statusCode != 200 {
                print("Response code: \(httpResponse.statusCode)")
                return
            }
            
            guard let dataUnwrapped = data else {
                fatalError("Data should not be empty, impossible scenario!")
            }
            
            handler(dataUnwrapped)
        }
        task.resume()
    }
}
