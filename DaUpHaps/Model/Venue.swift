//
//  Venue.swift
//  DaUpHaps
//
//  Created by Apple on 27/05/2021.
//

import Foundation

// MARK: - Venue
struct Venue: Codable {
    let venueName:String?
    let venueID: Int?

    enum CodingKeys: String, CodingKey {
        case venueName
        case venueID = "venueId"
    }
}
