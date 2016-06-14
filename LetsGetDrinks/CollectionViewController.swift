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
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!

    @IBOutlet weak var favoritesSwitch: UISwitch!
    
    @IBOutlet weak var refreshButton: UIButton!
    
    @IBOutlet weak var searchBar: UISearchBar!
    
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
        searchBar.delegate = self
        context = CoreDataStack.sharedInstance().managedObjectContext
        scratchContext = CoreDataStack.sharedInstance().scratchContext
        favoritesSwitch.transform = CGAffineTransformMakeScale(0.75, 0.75)
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
    
    
    @IBAction func favoritesSwitchToggled(sender: AnyObject) {
        if favoritesSwitch.on {
            // show favorites only
            setFetchedResultsControllerForContext(context)
        } else {
            // show regular results
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
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
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
        cell.venue = venue
        cell.initView()
        return cell
    }
    
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let cell = collectionView.cellForItemAtIndexPath(indexPath) as! VenueCollectionViewCell
        let venue = cell.venue
        let overlayVC = OverlayViewController(parentViewController: self, venue: venue)
        overlayVC.showView()
    }
    
}



// MARK: - UISearchBarDelegate
extension CollectionViewController: UISearchBarDelegate {
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        let context = favoritesSwitch.on ? CoreDataStack.sharedInstance().managedObjectContext : CoreDataStack.sharedInstance().scratchContext
        if searchText == "" {
            setFetchedResultsControllerForContext(context)
        } else {
            let namePredicate = NSPredicate(format: "name CONTAINS[c] %@", argumentArray: [searchText])
            let fetchRequest = NSFetchRequest(entityName: "Venue")
            fetchRequest.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
            fetchRequest.predicate = namePredicate
            fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        }
    }
}