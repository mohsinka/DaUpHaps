//
//  Data.swift
//  DaUpHaps
//
//  Created by Apple on 27/05/2021.
//

import Foundation


struct Root: Codable {
    let data: DataClass

    enum CodingKeys:String, CodingKey {
        case data
    }
}

// MARK: - DataClass
struct DataClass: Codable {
    let events: [Event]
    let venues: [Venue]

    enum CodingKeys: String, CodingKey {
        case events
        case venues
    }
}

struct EventPlaceModel {
    let url:String?
    let longitude:Double?
    let latitude:Double?
    let placeId:String?
    let locationRadius:Double?
    let pageNumber:Int?
    let pageSize: Int?
    
    init(url: String? = nil, longitude:Double? = nil, latitude:Double? = nil,
         placeId: String? = nil, locationRadius: Double? = nil, pageNumber:Int? = nil, pageSize:Int? = nil) {
        
        self.url = url
        self.longitude = longitude
        self.latitude = latitude
        
        self.placeId = placeId
        self.locationRadius = locationRadius
        self.pageNumber = pageNumber
        self.pageSize = pageSize
    }
}
