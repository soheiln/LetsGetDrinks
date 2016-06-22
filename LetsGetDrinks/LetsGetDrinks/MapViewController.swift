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

class MapViewController: UIViewController, MKMapViewDelegate, ActivityIndicatorProtocol {

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var favoritesSwitch: UISwitch!
    @IBOutlet weak var refreshButton: UIButton!
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    var context: NSManagedObjectContext!
    var locationManager = CLLocationManager()
    var userLocation: CLLocation!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
    }

    
    // initializes ViewController
    func initView() {
        mapView.delegate = self
        searchBar.delegate = self
        context = CoreDataStack.sharedInstance().managedObjectContext
        showActivityIndicator()
        showUserLocationOnMap()
        showVenuesOnMap()
        favoritesSwitch.transform = CGAffineTransformMakeScale(0.75, 0.75)
    }
    
    
    @IBAction func favoritesSwitchToggled(sender: AnyObject) {
        if favoritesSwitch.on {
            // show favorites only
            refreshAndShowFavoritesOnMap()
        } else {
            // show regular results
            clearAllPins()
            showVenuesOnMap()

        }
    }
    
    
    @IBAction func refreshButtonPressed(sender: AnyObject) {
        CoreDataStack.sharedInstance().venues = [Venue]()
        CoreDataStack.sharedInstance().scratchContext.reset()
        showActivityIndicator()
        clearAllPins()
        locationManager.requestLocation()
    }
    
    
    func refreshAndShowFavoritesOnMap() {
        CoreDataStack.sharedInstance().loadData() // load favorites into CoreDataStack.sharedInstance().favorites
        clearAllPins()
        for venue in CoreDataStack.sharedInstance().favorites {
            showVenueOnMap(venue)
        }
    }
    
    func clearAllPins() {
        mapView.removeAnnotations(mapView.annotations)
    }
    

    func showActivityIndicator() {
        activityIndicator.startAnimating()
    }
    
    
    func hideActivityIndicator() {
        activityIndicator.hidesWhenStopped = true
        activityIndicator.stopAnimating()
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
        let annotation = PinAnnotation()
        annotation.venue = venue
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
        //user location detected
        let location = locations.last! as CLLocation
        userLocation = location
        let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: Constants.MapView.latitudeRegion, longitudeDelta: Constants.MapView.longitudeRegion))
        mapView.setRegion(region, animated: true)
        GoogleClient.getVenuesNearLocation(callerViewController: self, latitude: location.coordinate.latitude, longitude: location.coordinate.longitude, errorHandler: nil,  completionHandler: { venue in
            dispatch_async(dispatch_get_main_queue()) {
                CoreDataStack.sharedInstance().venues.append(venue)
                self.showVenueOnMap(venue)
            }
        })
        hideActivityIndicator()
    }
    
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        UIUtilities.showAlret(callerViewController: self, message: "Failed to get user location", completionHandler: {
            self.hideActivityIndicator()
        })
    }
    
    
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        if status == .AuthorizedAlways || status == .AuthorizedWhenInUse {
            locationManager.requestLocation()
            mapView.showsUserLocation = true
        }
    }
}


// pin selection handlers
extension MapViewController {
    func mapView(mapView: MKMapView, didDeselectAnnotationView view: MKAnnotationView) {
        mapView.deselectAnnotation(view.annotation, animated: false)
        CoreDataStack.sharedInstance().currentAnnotation = nil
        CoreDataStack.sharedInstance().currentVenue = nil
    }
    
    func mapView(mapView: MKMapView, didSelectAnnotationView view: MKAnnotationView) {
        let pinAnnotation = view.annotation as! PinAnnotation
        mapView.deselectAnnotation(pinAnnotation, animated: false)
        CoreDataStack.sharedInstance().currentAnnotation = pinAnnotation
        CoreDataStack.sharedInstance().currentVenue = pinAnnotation.venue
        let overlayVC = OverlayViewController(parentViewController: self, venue: pinAnnotation.venue)
        overlayVC.showView()
    }

}


// MARK: - UISearchBarDelegate
extension MapViewController: UISearchBarDelegate {
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText == "" {
            showVenuesOnMap()
        }
        else {
            clearAllPins()
            for venue in CoreDataStack.sharedInstance().venues {
                if venue.name!.lowercaseString.containsString(searchText.lowercaseString) {
                    showVenueOnMap(venue)
                }
            }
        }
        
    }
}