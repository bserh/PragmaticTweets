//
//  TweetDetailViewController.swift
//  PragmaticTweets
//
//  Created by Sergey Bavykin on 3/21/16.
//  Copyright © 2016 Sergey Bavykin. All rights reserved.
//

import UIKit
import PragmaticTweetsFramework

class TweetDetailViewController: UIViewController {
    
    @IBOutlet weak var userImageButton: UIButton!
    @IBOutlet weak var userRealNameLabel: UILabel!
    @IBOutlet weak var userScreenNameLabel: UILabel!
    @IBOutlet weak var tweetTextLabel: UILabel!
    @IBOutlet weak var tweetImageView: UIImageView!
    
    var tweetIdString: String? {
        didSet {
            reloadTweetDetails()
        }
    }
    
    @IBAction func unwindToTweetDetailVC(segue: UIStoryboardSegue) {
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        reloadTweetDetails()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let userDetailVC = segue.destinationViewController as? UserDetailViewController where segue.identifier == "showUserDetailSegue" {
            userDetailVC.screenName = userScreenNameLabel.text
        }
    }
    
    func reloadTweetDetails() {
        guard let tweetIdString = tweetIdString else {
            return
        }
        if let twitterAPIURL = NSURL(string: "https://api.twitter.com/1.1/statuses/show.json") {
            let twitterParams = ["id": tweetIdString]
            sendTwitterRequest(twitterAPIURL,
                params: twitterParams,
                completion: {
                    (data, urlResponse, error) -> Void in
                    dispatch_async(dispatch_get_main_queue()) {
                        self.handleTwitterData(data, urlResponse: urlResponse, error: error)
                    }
            })
        }
    }
    
    func handleTwitterData(data: NSData!, urlResponse: NSHTTPURLResponse!, error: NSError!) {
        guard let data = data else {
            NSLog("handleTwitterData() no data")
            return
        }
        NSLog("handleTwitterData(), \(data.length) bytes")
        
        do {
            let jsonObject = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions([]))
            guard let tweetDict = jsonObject as? [String: AnyObject] else {
                NSLog("didn't get a dictionary")
                return
            }
            NSLog("tweetDict: \(tweetDict)")
            self.tweetTextLabel.text = tweetDict["text"] as? String
            
            if let userDict = tweetDict["user"] as? [String: AnyObject] {
                self.userRealNameLabel.text = (userDict["name"] as! String)
                self.userScreenNameLabel.text = (userDict["screen_name"] as! String)
                self.userImageButton.setTitle(nil, forState: .Normal)
                
                if let userImageUrl = NSURL(string: userDict["profile_image_url_https"] as! String),
                    userImageData = NSData(contentsOfURL: userImageUrl) {
                        self.userImageButton.setImage(UIImage(data: userImageData), forState: .Normal)
                }
                
                if let entities = tweetDict["entities"] as? [String : AnyObject],
                    media = entities["media"] as? [[String : AnyObject]],
                    mediaString = media[0]["media_url_https"] as? String,
                    mediaURL = NSURL (string: mediaString),
                    mediaData = NSData (contentsOfURL: mediaURL) {
                        tweetImageView.image = UIImage(data: mediaData)
                } else {
                    tweetImageView.image = nil
                }
            }
        } catch let error as NSError {
            NSLog("JSON error: \(error)")
        }
        
    }

}
