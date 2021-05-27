//
//  Data.swift
//  DaUpHaps
//
//  Created by Apple on 27/05/2021.
//

import Foundation


class Root: Codable {
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
