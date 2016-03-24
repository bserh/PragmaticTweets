//
//  UserImageDetailViewController.swift
//  PragmaticTweets
//
//  Created by Sergey Bavykin on 3/23/16.
//  Copyright © 2016 Sergey Bavykin. All rights reserved.
//

import UIKit
import PragmaticTweetsFramework

class UserImageDetailViewController: UIViewController {
    @IBOutlet weak var userImageView: UIImageView!
    
    var preGestureTransform: CGAffineTransform?
    var userImageURL: NSURL?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        if let userImageURL = userImageURL, imageData = NSData(contentsOfURL: userImageURL) {
            userImageView.image = UIImage(data: imageData)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func handlePanGesture(sender: UIPanGestureRecognizer) {
        if sender.state == .Began {
            preGestureTransform = userImageView.transform
        }
        
        if sender.state == .Began || sender.state == .Changed {
            let translation = sender.translationInView(userImageView)
            let translatedTransform = CGAffineTransformTranslate(preGestureTransform!, translation.x, translation.y)
            
            userImageView.transform = translatedTransform
        }
    }

    @IBAction func handleDoubleTapGesture(sender: UITapGestureRecognizer) {
        userImageView.transform = CGAffineTransformIdentity
    }
    
    @IBAction func handlePinchGesture(sender: UIPinchGestureRecognizer) {
        if sender.state == .Began {
            preGestureTransform = userImageView.transform
        }
        if sender.state == .Began || sender.state == .Changed {
            let scaledTransform = CGAffineTransformScale(preGestureTransform!, sender.scale, sender.scale)
            userImageView.transform = scaledTransform
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
