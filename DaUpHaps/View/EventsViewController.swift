//
//  ViewController.swift
//  DaUpHaps
//
//  Created by Apple on 27/05/2021.
//

import UIKit

class EventsViewController: UIViewController {

    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var messageButton: UIButton!
    @IBOutlet weak var globalFeedButton: UIButton!
    
    @IBOutlet weak var noEventsLabel: UILabel!
    @IBOutlet weak var goOutTonightButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    let viewModel = ViewModel()
    
    var events = [Event]()
    var venues = [Venue]()
    var rootObject: Root?
    
    var indicator = UIActivityIndicatorView()
    let refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        self.tableView.register(UINib(nibName: Constants.cell_nib,
                                      bundle: nil), forCellReuseIdentifier: Constants.event_cell)
        self.setUpUIComponents()
        self.initializeRefreshControl()
        self.fetchEvents()
    }

    @IBAction func goOutTonightButtonPressed(_ sender: UIButton) {
        
    }
    
    @objc func fetchEvents() {
        self.initializeActivityIndicator()
        self.viewModel.parseforEvents(Constants.events_url,
                                      longitude:45.33539270000001,
                                      latitude: 29.07379500000002,
                                      placeId: "ChIJywtkGTF2X0YRZnedZ9MnDag",
                                      locationRadius: 20,
                                      pageNumber: 1,
                                      pageSize: 50) { (rootObj) in
            
            self.rootObject = rootObj
            
            self.events = self.rootObject?.data.events ?? []
            self.venues = self.rootObject?.data.venues ?? []
            
            DispatchQueue.main.async {
                self.refreshControl.endRefreshing()
                self.indicator.removeFromSuperview()
                self.tableView.reloadData()
                
                if let locationCity = self.venues.first?.venueLocation?.locationCity {
                    self.titleLabel.text = locationCity
                }
                
                if self.events.count <= 0 {
                    self.tableView.isHidden = true
                    self.noEventsLabel.isHidden = false
                } else {
                    self.tableView.isHidden = false
                    self.noEventsLabel.isHidden = true
                }
            }
        }
    }
    
    func setUpUIComponents() {
        self.headerView.layer.shadowColor = UIColor.gray.cgColor
        self.headerView.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        self.headerView.layer.shadowRadius = 3.0
        self.headerView.layer.shadowOpacity = 0.3
        
        self.noEventsLabel.isHidden = true
        self.goOutTonightButton.layer.backgroundColor = UIColor.black.cgColor
        self.goOutTonightButton.layer.cornerRadius = 5.0
        self.tableView.tableFooterView = UIView()
    }
    
    func initializeRefreshControl() {
        refreshControl.addTarget(self, action:#selector(fetchEvents), for: .valueChanged)
        self.tableView.refreshControl = refreshControl
        self.tableView.contentInsetAdjustmentBehavior = .never
    }
    
    func initializeActivityIndicator() {
        indicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        indicator.style = UIActivityIndicatorView.Style.medium
        indicator.color = .clear
        indicator.center = self.view.center
        self.view.addSubview(indicator)
    }
    
    func showEventsPopupWithEvent(_ event:Event, venue:Venue) {
        let vc = SheetMiddleVC(nibName: "SheetMiddleVC", bundle: nil)
        vc.providesPresentationContextTransitionStyle = true
        vc.definesPresentationContext = true
        vc.modalPresentationStyle = .overCurrentContext

        let popup = EventsDetailViewController(nibName: "EventsDetailViewController", bundle: nil)
        popup.sheet = vc
        popup.event = event
        popup.venue = venue
        
        vc.controller = popup
        vc.height = 385
        vc.dismissTap = false
        self.present(vc, animated: false, completion: nil)
    }
}

extension EventsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 250
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return events.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.event_cell, for: indexPath) as! EventTableViewCell
        let event = events[indexPath.row]
        let venue = venues[indexPath.row]
        cell.configureCellForEvent(event, venue: venue)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let event = events[indexPath.row]
        let venue = venues[indexPath.row]
        self.showEventsPopupWithEvent(event, venue: venue)
    }
}

