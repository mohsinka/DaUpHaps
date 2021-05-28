//
//  Venue.swift
//  DaUpHaps
//
//  Created by Apple on 27/05/2021.
//

import Foundation

// MARK: - Venue
struct Venue: Codable {
    let venueLocation: VenueLocation?
    let venueMusic: [String]?
    let accountCurrency, venueURL: String?
    let venueAtmosphere: [String]?
    let venueEmail: String?
    let venueSortRank: Int?
    let venueBidRateMessage: JSONNull?
    let venueRglInfoMessage: JSONNull?
    let venueWebsite, venueRglInfoColor, venueTZ: String?
    let venueImages: [String]?
    let venueLogo, venueName, venueDoorPolicy, venueLegalDisclaimerReceipt: String?
    let venuePhone: String?
    let venueBidTimeMessage: JSONNull?
    let keyflowCityID:Int?
    let venueID: Int?
    let venueDescription: String?
    let venueUpcomingEventsCount: Int?

    enum CodingKeys: String, CodingKey {
        case venueLocation, venueMusic, accountCurrency
        case venueURL = "venueUrl"
        case venueAtmosphere, venueEmail, venueSortRank, venueBidRateMessage, venueRglInfoMessage, venueWebsite, venueRglInfoColor, venueTZ, venueImages, venueLogo, venueName, venueDoorPolicy, venueLegalDisclaimerReceipt, venuePhone, venueBidTimeMessage
        case keyflowCityID = "keyflowCityId"
        case venueID = "venueId"
        case venueDescription, venueUpcomingEventsCount
    }
}

//// MARK: - VenueLocation
struct VenueLocation: Codable {
    let locationReference, locationAddress, locationCity, locationCountry: String?
    let locationCoordinates: [String]?
    let locationPlaceID: String?
    let locationZoom: Int?
    let locationCountryCode: String?
    
    enum CodingKeys: String, CodingKey {
        case locationReference, locationAddress, locationCity, locationCountry
        case locationCoordinates, locationPlaceID
        case locationZoom
        case locationCountryCode
    }
}

