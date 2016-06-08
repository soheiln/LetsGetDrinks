//
//  OverlayViewController.swift
//  LetsGetDrinks
//
//  Created by soheiln on 6/1/16.
//  Copyright © 2016 soheiln. All rights reserved.
//

import UIKit

class OverlayViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var uberButton: UIButton!
    @IBOutlet weak var favoriteButton: UIButton!
    
    var favoriteFlag: Bool!
    var parentVC: UIViewController!
    var tintView: UIView!
    var venue: Venue!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    convenience init(parentViewController: UIViewController, venue: Venue) {
        self.init()
        _ = self.view // call to self.view to initialize all view elements and outlets
        parentVC = parentViewController
        self.venue = venue
        if let photo = venue.photo {
            imageView.image = UIImage(data: photo)
        }
        nameLabel.text = venue.name
        addressLabel.text = venue.address
        phoneLabel.text = venue.phone
        
        if let photo = venue.photo {
            imageView.image = UIImage(data: photo)
        } else {
            imageView.image = UIImage(named: "no_image_available")
        }
        
        favoriteFlag = venue.isFavorite()
        if favoriteFlag! {
            favoriteButton.setImage(UIImage(named: "star-solid"), forState: UIControlState.Normal)
        }
        initView()
    }
    
    
    func initView() {
        nameLabel.adjustsFontSizeToFitWidth = true
        addressLabel.adjustsFontSizeToFitWidth = true
        addressLabel.numberOfLines = 2
        phoneLabel.adjustsFontSizeToFitWidth = true
    }
    
    
    func showView() {
        let frame = parentVC.view.frame
        
        // create a grey tint view
        tintView = UIView(frame: frame)
        tintView.backgroundColor = UIColor.lightGrayColor()
        tintView.alpha = 0.5
        
        // set self view's frame size
        let x = frame.origin.x + CGFloat(Constants.OverlayView.horizontalPadding)
        let y = frame.origin.y + CGFloat(Constants.OverlayView.verticalPadding)
        let width = frame.size.width - CGFloat(2 * Constants.OverlayView.horizontalPadding)
        let height = frame.size.height  - CGFloat(2 * Constants.OverlayView.verticalPadding)
        let overlayFrame = CGRect(x: x, y: y, width: width, height: height)
        self.view.frame = overlayFrame
        
        // add child VC to parent VC and vice versa
        parentVC.addChildViewController(self)

        // add both views to parent vc
        parentVC.view.addSubview(tintView)
        parentVC.view.addSubview(self.view)
        self.didMoveToParentViewController(parentVC)
    }

    
    @IBAction func closeButtonPressed(sender: AnyObject) {
        // remove relationship between view controllers
        self.willMoveToParentViewController(nil)

        // remove both the self view and the tintView from parent view
        parentVC.view.subviews.last?.removeFromSuperview()
        parentVC.view.subviews.last?.removeFromSuperview()
        
        self.removeFromParentViewController()
        
        // update favorite subscription based on favoriteFlag
        handleFavoriteSubscription()
        // save
        CoreDataStack.sharedInstance().saveContext()
    }
    
    
    @IBAction func uberButtonPressed(sender: AnyObject) {
        
        let app = UIApplication.sharedApplication()
        var url: NSURL!
        if app.canOpenURL(NSURL(fileURLWithPath: "uber://")) {
            // Uber app is installed, construct and open deep link.
            url = UberClient.constructUberURLForLocation(venue, universalLink: false)
        } else {
            // No Uber app, open the mobile site.
            url = UberClient.constructUberURLForLocation(venue, universalLink: true)
        }
        app.openURL(url)
    }
    
    
    @IBAction func favoriteButtonPressed(sender: AnyObject) {
        if !favoriteFlag! {
            // save venue to favorites
            favoriteButton.setImage(UIImage(named: "star-solid"), forState: UIControlState.Normal)
            favoriteFlag = true
        } else {
            // remove from favorites
            favoriteButton.setImage(UIImage(named: "star-empty"), forState: UIControlState.Normal)
            favoriteFlag = false
        }
        
        
    }
    
    func handleFavoriteSubscription() {
        if favoriteFlag! {
            venue.addToFavorites()
        } else {
            venue.removeFromFavorites()
        }
        // update map view if favorite mode and a venue is de-favorited
        if let vc = parentVC as? MapViewController {
            if vc.favoritesSwitch.on {
                vc.refreshAndShowFavoritesOnMap()
            }
        }
    }
    
}