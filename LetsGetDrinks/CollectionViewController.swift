//
//  CollectionViewController.swift
//  LetsGetDrinks
//
//  Created by soheiln on 5/24/16.
//  Copyright © 2016 soheiln. All rights reserved.
//

import UIKit

class CollectionViewController: UIViewController {
    
    @IBOutlet weak var favoritesButton: UIButton!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
    }
    
    
    func initView() {
        hideActivityIndicator()
        //TODO
        GoogleClient.getVenuesNearLocation(callerViewController: self, latitude: 37.7749, longitude: -122.4194, errorHandler: nil,  completionHandler: { venue in
            print(venue)
            CoreDataStack.sharedInstance().venues.append(venue)
            
        })
    }
    
    @IBAction func favoritesButtonPressed(sender: AnyObject) {
    }
    
    
    
    func showActivityIndicator() {
        activityIndicator.startAnimating()
    }
    
    
    func hideActivityIndicator() {
        activityIndicator.hidesWhenStopped = true
        activityIndicator.stopAnimating()
    }

}

