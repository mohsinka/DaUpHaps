//
//  Parser.swift
//  DaUpHaps
//
//  Created by Apple on 27/05/2021.
//

import Foundation
import UIKit

class ViewModel {
    
    func parseforEvents(_ url:String, longitude:Double, latitude:Double, placeId:String, locationRadius:Double, pageNumber:Int, pageSize: Int, completionHandler: @escaping (Root) -> ())  {
        
        var api = URL(string: Constants.base_url+url)!
        api.appendQueryItem(name:"long", value: "\(longitude)")
        api.appendQueryItem(name:"lat", value: "\(latitude)")
        api.appendQueryItem(name:"placeId", value: placeId)
        api.appendQueryItem(name:"locationRadius", value: "\(locationRadius)")
        api.appendQueryItem(name:"pageNumber", value: "\(pageNumber)")
        api.appendQueryItem(name:"pageSize", value: "\(pageSize)")

        print(api)
        var request = URLRequest(url: api)

        request.httpMethod = "GET"
       
        URLSession.shared.dataTask(with: api) { dat, response, error in

            var rootResponse: Root
            guard let data = dat else {
                print("No data found")
                return
            }
            rootResponse = try! JSONDecoder().decode(Root.self, from: data)
            completionHandler(rootResponse)
            
        }.resume()
    }
}

extension URL {

    mutating func appendQueryItem(name: String, value: String?) {

        guard var urlComponents = URLComponents(string: absoluteString) else { return }
        var queryItems: [URLQueryItem] = urlComponents.queryItems ??  []
        let queryItem = URLQueryItem(name: name, value: value)
        queryItems.append(queryItem)
        urlComponents.queryItems = queryItems
        self = urlComponents.url!
    }
}
