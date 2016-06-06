//
//  CollectionViewController.swift
//  LetsGetDrinks
//
//  Created by soheiln on 5/24/16.
//  Copyright © 2016 soheiln. All rights reserved.
//

import UIKit
import CoreData

class CollectionViewController: UIViewController, ActivityIndicatorProtocol {
    
    @IBOutlet weak var favoritesButton: UIButton!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!

    var favoriteMode: Bool!
    var context: NSManagedObjectContext!
    var scratchContext: NSManagedObjectContext!
    var fetchedResultsController : NSFetchedResultsController! {
        // property observer
        didSet{
            executeSearch()
            collectionView.reloadData()
        }
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
    }
    
    
    func initView() {
        hideActivityIndicator()
        collectionView.dataSource = self
        collectionView.delegate = self
        favoriteMode = false
        context = CoreDataStack.sharedInstance().managedObjectContext
        scratchContext = CoreDataStack.sharedInstance().scratchContext
        initCollectionView()
        
        // initially set the frc to scratchContext for loading pins over network
        setFetchedResultsControllerForContext(scratchContext)
    }
    
    
    // Initializes collection view
    func initCollectionView() {
        collectionView.backgroundColor = UIColor.whiteColor()
        let screenSize = UIScreen.mainScreen().bounds
        let screenWidth = screenSize.width
        let space: CGFloat = CGFloat(Constants.CollectionView.SpaceBetweenSections)
        let numSection = Constants.CollectionView.NumSectionsInPortraitMode
        let dimension = (screenWidth - (CGFloat(numSection-1) * space)) / CGFloat(numSection)
        flowLayout.minimumInteritemSpacing = space
        flowLayout.minimumLineSpacing = space
        flowLayout.itemSize = CGSizeMake(dimension, dimension)
    }

    // toggle show favorite buttons
    @IBAction func favoritesButtonPressed(sender: AnyObject) {
        if !favoriteMode {
            // show favorites only
            favoriteMode = true
            favoritesButton.setImage(UIImage(named: "star-solid"), forState: UIControlState.Normal)
            setFetchedResultsControllerForContext(context)
            
        } else {
            // show regular results
            favoriteMode = false
            favoritesButton.setImage(UIImage(named: "star-empty"), forState: UIControlState.Normal)
            setFetchedResultsControllerForContext(scratchContext)
        }
    }
    
    
        
    func showActivityIndicator() {
        activityIndicator.startAnimating()
    }
    
    
    func hideActivityIndicator() {
        activityIndicator.hidesWhenStopped = true
        activityIndicator.stopAnimating()
    }
    
    
    // Loads the collection view with loaded venues
    func setFetchedResultsControllerForContext(context: NSManagedObjectContext) {
        let fetchRequest = NSFetchRequest(entityName: "Venue")
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "latitude", ascending: false)]
        fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        fetchedResultsController.delegate = self
    }


}


// MARK: - Fetched Results Controller Delegate
extension CollectionViewController: NSFetchedResultsControllerDelegate {
    
    func controllerDidChangeContent(controller: NSFetchedResultsController) {
        fetchedResultsController = controller
        executeSearch()
        collectionView.reloadData()
    }
    
    func executeSearch() {
        do {
            try fetchedResultsController.performFetch()
        } catch {
            print("Error while trying to perform a search: \n\(error)\n\(fetchedResultsController)")
        }
    }
    
}


// MARK: - Collection View Controller Delegate and Data Source
extension CollectionViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if fetchedResultsController == nil {
            return 0
        } else {
            return fetchedResultsController.sections![section].numberOfObjects
        }
    }
    
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("VenueCollectionViewCell", forIndexPath: indexPath) as! VenueCollectionViewCell
        let venues = fetchedResultsController.fetchedObjects as! [Venue]
        let venue = venues[indexPath.row]
        if let photo = venue.photo {
            cell.imageView.image = UIImage(data: photo)
        } else {
            cell.imageView.image = UIImage(named: "no_image_available")
        }
        cell.venue = venue
        cell.label.text = venue.name
        return cell
    }
    
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let cell = collectionView.cellForItemAtIndexPath(indexPath) as! VenueCollectionViewCell
        let venue = cell.venue
        let overlayVC = OverlayViewController(parentViewController: self, venue: venue)
        overlayVC.showView()
    }
    
}