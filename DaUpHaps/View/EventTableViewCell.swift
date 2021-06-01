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
        
        self.eventHolderView.layer.cornerRadius = 2.0

        self.eventHolderView.layer.shadowColor = UIColor.lightGray.cgColor
        self.eventHolderView.layer.shadowOpacity = 0.4
        self.eventHolderView.layer.shadowOffset = .zero
        self.eventHolderView.layer.shadowRadius = 3
        
        self.eventDateHolderView.layer.cornerRadius = 5.0

        self.eventNameLabel.text = event.name
        
        
        //Load Event Image
        if let images = event.images {
            for image in images {
                if !image.isEmpty {
                    self.eventImageView.downloaded(from: URL(string:Constants.image_base_url+image)!)
                    self.eventImageView.contentMode = .scaleAspectFill
                    break
                }
            }
        }
        
        let startHourTime = self.getTimeHoursForDate(event.startTime!)
        let endHourTime = self.getTimeHoursForDate(event.endTime!)
        let totalText = startHourTime + "-" + endHourTime
        self.eventTimeDurationLabel.text = totalText
        
        let tuple = self.getDayMonthWeekDayForDate(event.startTime!)
        let day = tuple.0
        let month = tuple.1
        let weekday = tuple.2
        
        self.eventDayLabel.text = weekday
        self.eventMonthLabel.text = month
        self.eventDateLabel.text = "\(day)"
        self.eventVenueLabel.text = venue.venueName
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
