//
//  EventsDetailViewController.swift
//  DaUpHaps
//
//  Created by Apple on 27/05/2021.
//

import UIKit

class EventsDetailViewController: UIViewController {

    @IBOutlet weak var eventImageView: UIImageView!
    @IBOutlet weak var eventNameLabel: UILabel!
    @IBOutlet weak var eventVenueLabel: UILabel!
    @IBOutlet weak var eventTimeAndDateLabel: UILabel!
    @IBOutlet weak var eventTicketsSoldLabel: UILabel!
    
    @IBOutlet weak var crossButton: UIButton!
    
    var sheet:SheetMiddleVC?
    var event:Event?
    var venue:Venue?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.layer.cornerRadius = 10.0
        self.eventImageView.layer.cornerRadius = self.eventImageView.frame.size.width/2
        self.eventNameLabel.text = event!.name
        
        
        //Load Event Image
        if let images = event!.images {
            for image in images {
                if !image.isEmpty {
                    self.eventImageView.downloaded(from: URL(string:Constants.image_base_url+image)!)
                    self.eventImageView.contentMode = .scaleToFill
                    break
                }
            }
        }
        
        let tuple = self.getDayMonthWeekDayForDate(event!.startTime!)
        let day = tuple.0
        let month = tuple.1
        let weekday = tuple.2
        
        let startHourTime = self.getTimeHoursForDate(event!.startTime!)
        let endHourTime = self.getTimeHoursForDate(event!.endTime!)
        let totalText = startHourTime + " - " + endHourTime
        self.eventTimeAndDateLabel.text = "\(weekday)  \(day)   \(month)   during          \(totalText)"
        
        if let tickets = event!.tickets {
            self.eventTicketsSoldLabel.text = "Tickets Sold: \(tickets.count)"
        } else {
            self.eventTicketsSoldLabel.text = "All Tickets Available"
        }
        
        self.eventVenueLabel.text = venue!.venueName
    }

    @IBAction func crossButtonPressed(_ sender: UIButton) {
        sheet!.dismiss(animated: false, completion: nil)
    }
    
    func getDayMonthWeekDayForDate(_ dateStr:String) -> (Int, String, String) {
        var tuple:(Int,String,String) = (1,"","")
        
        let localISOFormatter = ISO8601DateFormatter()
        localISOFormatter.timeZone = TimeZone(secondsFromGMT: 7200)
        
        let date = localISOFormatter.date(from:dateStr)!
        
        let calendar = Calendar.current
        let dayOfMonth = calendar.component(.day, from: date)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM"
        
        let dayFormatter = DateFormatter()
        dayFormatter.dateFormat = "EE"
        
        tuple.0 = dayOfMonth
        tuple.1 = dateFormatter.string(from: date)
        tuple.2 = dayFormatter.string(from: date).uppercased()
        
        return tuple
    }
    
    func getTimeHoursForDate(_ dateStr:String) -> String {
        var hour = ""
        
        let dateFormatter = DateFormatter()
        let localISOFormatter = ISO8601DateFormatter()
        localISOFormatter.timeZone = TimeZone.current
        
        let date = localISOFormatter.date(from:dateStr)!
        dateFormatter.dateFormat = "HH:mm"
        
        hour = dateFormatter.string(from: date)
        return hour
    }
    
}
