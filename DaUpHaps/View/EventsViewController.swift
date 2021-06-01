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
    var eventPlaceModel:EventPlaceModel?
    let refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        self.tableView.register(UINib(nibName: Constants.cell_nib,
                                      bundle: nil), forCellReuseIdentifier: Constants.event_cell)
        self.setUpUIComponents()
        self.initializeRefreshControl()
        self.showProgress()
        self.fetchEvents()
    }

    @IBAction func goOutTonightButtonPressed(_ sender: UIButton) {
        
    }
    
    let activityIndicator: UIActivityIndicatorView? = UIActivityIndicatorView(style: .medium)
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
    }
    
    func showProgress() {
        DispatchQueue.main.async {
            self.activityIndicator?.center = self.view.center
            self.activityIndicator?.hidesWhenStopped = true
            self.activityIndicator?.startAnimating()
            self.view.addSubview(self.activityIndicator!)
        }
    }
    
    func hideProgress() {
        DispatchQueue.main.async {
            self.activityIndicator?.stopAnimating()
        }
    }
    
    @objc func fetchEvents() {
        if let evtPlaceModel = self.eventPlaceModel {
            self.viewModel.parseforEvents(evtPlaceModel) { (rootObj) in
                
                self.rootObject = rootObj
                
                self.events = self.rootObject?.data.events ?? []
                self.venues = self.rootObject?.data.venues ?? []
                self.hideProgress()
                DispatchQueue.main.async {
                    self.refreshControl.endRefreshing()
                    self.tableView.reloadData()
                    
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
    }
    
    func setUpUIComponents() {
        
        self.titleLabel.text = "Stockholm"
        self.eventPlaceModel = EventPlaceModel(url: Constants.events_url,
                                               longitude: 59.33539270000001,
                                               latitude: 18.07379500000002,
                                               placeId: "ChIJywtkGTF2X0YRZnedZ9MnDag",
                                               locationRadius: 100,
                                               pageNumber: 1,
                                               pageSize: 50)
        
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
        return 200
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return events.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.event_cell, for: indexPath) as! EventTableViewCell
        let event = events[indexPath.row]
        let venue = self.venues.filter({$0.venueID == event.venueID}).first
        cell.configureCellForEvent(event, venue: venue!)
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let event = self.events[indexPath.row]
        let venue = self.venues.filter({$0.venueID == event.venueID}).first
        self.showEventsPopupWithEvent(event, venue: venue!)
    }
}

