//
//  Parser.swift
//  DaUpHaps
//
//  Created by Apple on 27/05/2021.
//

import Foundation
import UIKit

class ViewModel {
    
    func parseforEvents(_ eventPlace:EventPlaceModel, completionHandler: @escaping (Root) -> ())  {
        
        var api = URL(string: Constants.base_url+eventPlace.url!)!
        api.appendQueryItem(name:"long", value: "\(eventPlace.longitude!)")
        api.appendQueryItem(name:"lat", value: "\(eventPlace.latitude!)")
        api.appendQueryItem(name:"placeId", value: eventPlace.placeId!)
        api.appendQueryItem(name:"locationRadius", value: "\(eventPlace.locationRadius!)")
        api.appendQueryItem(name:"pageNumber", value: "\(eventPlace.pageNumber!)")
        api.appendQueryItem(name:"pageSize", value: "\(eventPlace.pageSize!)")

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
