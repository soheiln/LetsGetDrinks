//
//  MapViewController.swift
//  LetsGetDrinks
//
//  Created by soheiln on 5/24/16.
//  Copyright © 2016 soheiln. All rights reserved.
//

import UIKit
import MapKit
import CoreData

class MapViewController: UIViewController, MKMapViewDelegate {

    @IBOutlet weak var favoritesButton: UIButton!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var context: NSManagedObjectContext!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
    }

    
    // initializes ViewController
    func initView() {
        mapView.delegate = self
        context = CoreDataStack.sharedInstance().managedObjectContext
        hideActivityIndicator()
        loadData()
        // TODO
    }
    

    @IBAction func favoritesButtonPressed(sender: AnyObject) {
        //TODO remove:
        showVenuesOnMap()
    }
    

    func showActivityIndicator() {
        activityIndicator.startAnimating()
    }
    
    
    func hideActivityIndicator() {
        activityIndicator.hidesWhenStopped = true
        activityIndicator.stopAnimating()
    }
    
    
    // loads all the data from persistent memory
    func loadData() {
        // check if the data is already loaded, if not load
    }

    
    // show the already loaded venues as annotations on the map
    func showVenuesOnMap() {
        let venues = CoreDataStack.sharedInstance().venues
        for venue in venues {
            showVenueOnMap(venue)
        }
    }
    
    
    // Shows a single Pin object on map
    func showVenueOnMap(venue: Venue) {
        let annotation = MKPointAnnotation()
        annotation.coordinate.latitude = CLLocationDegrees(venue.latitude)
        annotation.coordinate.longitude = CLLocationDegrees(venue.longitude)
        mapView.addAnnotation(annotation)
        
    }

}

