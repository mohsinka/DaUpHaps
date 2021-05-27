//
//  EventTableViewCell.swift
//  DaUpHaps
//
//  Created by Apple on 27/05/2021.
//

import UIKit

class EventTableViewCell: UITableViewCell {

    @IBOutlet weak var eventHolderView: UIView!
    @IBOutlet weak var eventImageView: UIImageView!
    @IBOutlet weak var eventNameLabel: UILabel!
    @IBOutlet weak var eventVenueLabel: UILabel!
    
    @IBOutlet weak var eventFirstGuestImageView: UIImageView!
    @IBOutlet weak var eventSecondGuestImageView: UIImageView!
    @IBOutlet weak var eventThirdGuestImageView: UIImageView!
    @IBOutlet weak var eventRemainingGuestCounter: UIImageView!
    
    @IBOutlet weak var eventDateHolderView: UIView!
    @IBOutlet weak var eventDayLabel: UILabel!
    @IBOutlet weak var eventDateLabel: UILabel!
    @IBOutlet weak var eventMonthLabel: UILabel!
    @IBOutlet weak var eventTimeDurationLabel: UILabel!
    
    
    func configureCellForEvent(_ event:Event, venue:Venue) {
        
        self.eventHolderView.layer.cornerRadius = 5.0
        self.eventHolderView.layer.shadowColor = UIColor.gray.cgColor
        self.eventHolderView.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        self.eventHolderView.layer.shadowRadius = 7.0
        self.eventHolderView.layer.shadowOpacity = 0.7        
        self.eventDateHolderView.layer.cornerRadius = 5.0

        self.eventNameLabel.text = event.name
        
        
        //Load Event Image
        if let images = event.images {
            for image in images {
                if !image.isEmpty {
                    self.eventImageView.downloaded(from: URL(string:Constants.image_base_url+image)!)
                    self.eventImageView.contentMode = .scaleToFill
                    break
                }
            }
        }
        
        let startHourTime = self.getTimeHoursForDate(event.startTime!)
        let endHourTime = self.getTimeHoursForDate(event.endTime!)
        let totalText = startHourTime + " - " + endHourTime
        self.eventTimeDurationLabel.text = totalText
        
        let tuple = self.getDayMonthWeekDayForDate(event.startTime!)
        let day = tuple.0
        let month = tuple.1
        let weekday = tuple.2
        
        self.eventDayLabel.text = weekday
        self.eventMonthLabel.text = month
        self.eventDateLabel.text = "\(day)"
        
        if event.venueID == venue.venueID {
            self.eventVenueLabel.text = venue.venueName
        } else {
            self.eventVenueLabel.text = "Loading..."
        }
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

// MARK: - UIImageView
extension UIImageView {
    func load(url: URL) {
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                }
            }
        }
    }
}


extension UIImageView {
    func downloaded(from url: URL, contentMode mode: UIView.ContentMode = .scaleToFill) {
            let imageCache = NSCache<NSString, UIImage>()
        let urlStringIs = url.absoluteString
            if let imageFromCache = imageCache.object(forKey: urlStringIs as NSString) {
            self.image = imageFromCache
            return
        }
    
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
            else { return }
            DispatchQueue.main.async { [weak self] in
                self?.image = image
                imageCache.setObject(image, forKey: urlStringIs as NSString)
            }
        }.resume()
    }
    func downloaded(from link: String?, contentMode mode: UIView.ContentMode = .scaleToFill) {
        guard let url = URL(string: link ?? "") else {
            self.image = UIImage(named: "placeholder")
            return
        }
            downloaded(from: url, contentMode: mode)
    }
}
