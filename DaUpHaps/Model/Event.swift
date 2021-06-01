//
//  Event.swift
//  DaUpHaps
//
//  Created by Apple on 27/05/2021.
//

import Foundation

// MARK: - Event
struct Event: Codable {
    let endTime: String?
    let tickets: [Ticket]?
    let images: [String]?
    let name: String?
    let startTime: String?
    let venueID: Int?

    enum CodingKeys: String, CodingKey {
        case endTime
        case tickets
        case name, startTime, images
        case venueID = "venueId"
    }
}

// MARK: - Ticket
struct Ticket: Codable {
    let title: String?

    enum CodingKeys: String, CodingKey {
        case title
    }
}
