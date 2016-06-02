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
    var locationManager = CLLocationManager()
    
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
        showUserLocationOnMap()
        // TODO
    }
    

    @IBAction func favoritesButtonPressed(sender: AnyObject) {
        //TODO remove:
//        showVenuesOnMap()
        
        let testVenue = Venue(context: context)
        testVenue.name = "Name"
        testVenue.address = "Address"
        testVenue.phone = "Phone"
        let overlayVC = OverlayViewController(parentViewController: self, venue: testVenue)
        overlayVC.showView()

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
    
    
    
    func showUserLocationOnMap() {
        if (CLLocationManager.locationServicesEnabled()) {
            mapView.showsUserLocation = true
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            if CLLocationManager.authorizationStatus() == .NotDetermined {
                locationManager.requestAlwaysAuthorization()
            } else {
                locationManager.requestLocation()
            }
        }
    }

}


// MARK: - CLLocationManager Delegate
extension MapViewController: CLLocationManagerDelegate {
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations.last! as CLLocation
        let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        // TODO: update
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: Constants.MapView.latitudeRegion, longitudeDelta: Constants.MapView.longitudeRegion))
        mapView.setRegion(region, animated: true)
    }
    
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        //TODO:
        print("Failed getting location.")
    }
    
    
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        if status == .AuthorizedAlways || status == .AuthorizedWhenInUse {
            locationManager.requestLocation()
            mapView.showsUserLocation = true
        }
    }
}
