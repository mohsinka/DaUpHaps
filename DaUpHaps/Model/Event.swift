//
//  Event.swift
//  DaUpHaps
//
//  Created by Apple on 27/05/2021.
//

import Foundation

// MARK: - Event
struct Event: Codable {
    let consents: [JSONAny]?
    let minimumAge: Int?
    let endTime: String?
    let eventDescription: String?
    let tickets: [Ticket]?
    let receivedTickets: [JSONAny]?
    let videoURI: String?
    let vipCardStatus: [JSONAny]?
    let atmosphere: [String]?
    let atmosphereIDArray, musicIDArray: [Int]?
    let eventLegalDisclaimerReceipt: String?
    let sentTickets: [JSONAny]?
    let id: Int?
    let uri: String?
    let images: [String]?
    let doorPolicy, name: String?
    let startTime: String?
    let music: [String]?
    let venueID: Int?

    enum CodingKeys: String, CodingKey {
        case consents, minimumAge, endTime
        case eventDescription = "description"
        case tickets
        case receivedTickets
        case videoURI = "video_uri"
        case vipCardStatus, atmosphere
        case atmosphereIDArray = "atmosphereIdArray"
        case musicIDArray = "musicIdArray"
        case eventLegalDisclaimerReceipt, sentTickets, id, uri, images, doorPolicy, name, startTime, music
        case venueID = "venueId"
    }
}

// MARK: - Ticket
class Ticket: Codable {
    let title: String?
    let priceTax: Int?
    let isRequestableTicket: Bool?
    let enabled: Bool?
    let ticketDescription: String?
    let totalPrice: Int?
    let type: String?
    let taxRatio: Double?
    let currency: String?
    let bookingFeeTax, quantity, priceBeforeTax: Int?
    let saleStart: String?
    let id, bookingFee: Int?
    let color: String?
    let saleEnd: String?
    let taxStrategy: String?
    let maxTicketsPerGuest: Int?
    let taxName: String?
    let drinkTableID: Int?
    let bookingFeeBeforeTax, freeInvites: Int?
    let payInvites: Int?
    let soldOut: Bool?
    let price, ticketsSold: Int?
    let kfChargeOnlyReservationFee: Bool?
    let lowestBidPrice, biddableItemID: Int?
    let lastEntryTime: String?
    let requestableTicketRejectedMessage, requestableTicketApprovedMessage: String?

    enum CodingKeys: String, CodingKey {
        case title, priceTax, isRequestableTicket, enabled
        case ticketDescription = "description"
        case totalPrice, type, taxRatio, currency, bookingFeeTax, quantity, priceBeforeTax, saleStart, id, bookingFee, color, saleEnd, taxStrategy, maxTicketsPerGuest, taxName
        case drinkTableID = "drinkTableId"
        case bookingFeeBeforeTax, freeInvites, payInvites, soldOut, price, ticketsSold, kfChargeOnlyReservationFee, lowestBidPrice
        case biddableItemID = "biddableItemId"
        case lastEntryTime, requestableTicketRejectedMessage, requestableTicketApprovedMessage
    }
}
