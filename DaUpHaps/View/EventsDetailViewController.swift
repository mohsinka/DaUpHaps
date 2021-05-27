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
        
        
        if event!.venueID == venue!.venueID {
            self.eventVenueLabel.text = venue!.venueName
        } else {
            self.eventVenueLabel.text = "Loading..."
        }
        
    }

    @IBAction func crossButtonPressed(_ sender: UIButton) {
        sheet!.dismiss(animated: false, completion: nil)
    }
    
    func getDayMonthWeekDayForDate(_ date:String) -> (Int, String, String) {
        var tuple:(Int,String,String) = (1,"","")
        
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en")
        dateFormatter.dateFormat = "yyyy.MM.dd'T'HH:mm:ss"
        
        let date = dateFormatter.date(from:date) ?? Date()
        
        dateFormatter.dateFormat = "EEEE"
        let weekDay = dateFormatter.string(from: Date())
        
        let calendar = Calendar.current
        let dayOfMonth = calendar.component(.day, from: date)
        let monthOfDay = calendar.component(.month, from: date)
        
        switch monthOfDay {
        case 1:
            tuple.1 = "JAN"
        case 2:
            tuple.1 = "FEB"
        case 3:
            tuple.1 = "MAR"
        case 4:
            tuple.1 = "APR"
        case 5:
            tuple.1 = "MAY"
        case 6:
            tuple.1 = "JUN"
        case 7:
            tuple.1 = "JUL"
        case 8:
            tuple.1 = "AUG"
        case 9:
            tuple.1 = "SEP"
        case 10:
            tuple.1 = "OCT"
        case 11:
            tuple.1 = "NOV"
        case 12:
            tuple.1 = "DEC"
        default:
            tuple.1 = "JAN"
        }
        
        switch weekDay {
        case "Sunday":
            tuple.2 = "SUN"
        case "Monday":
            tuple.2 = "MON"
        case "Tuesday":
            tuple.2 = "TUE"
        case "Wednesday":
            tuple.2 = "WED"
        case "Thursday":
            tuple.2 = "THURS"
        case "Friday":
            tuple.2 = "FRI"
        case "Saturday":
            tuple.2 = "SAT"
        default:
            tuple.2 = "SUN"
        }
        
        tuple.0 = dayOfMonth
        
        
        return tuple
    }
    
    func getTimeHoursForDate(_ date:String) -> String {
        var hour = ""
        
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en")
        dateFormatter.dateFormat = "yyyy.MM.dd'T'HH:mm:ss"
        
        let dateNew = dateFormatter.date(from:date) ?? Date()
        dateFormatter.dateFormat = "HH:mm"
        
        hour = dateFormatter.string(from: dateNew)
        return hour
    }
    
}
