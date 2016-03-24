//
//  KeyboardViewController.swift
//  PragmaticTweetsKeyboard
//
//  Created by Sergey Bavykin on 3/24/16.
//  Copyright © 2016 Sergey Bavykin. All rights reserved.
//

import UIKit
import PragmaticTweetsFramework

class KeyboardViewController: UIInputViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var nextKeyboardBarButton: UIBarButtonItem!
    @IBOutlet weak var tableView: UITableView!
    
    var tweepNames: [String] = []
    
    override func updateViewConstraints() {
        super.updateViewConstraints()
    
        // Add custom view sizing constraints here
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let twitterParams = ["count": "100"]
        guard let twitterAPIURL = NSURL(string: "https://api.twitter.com/1.1/friends/list.json") else {
            return
        }
        
        sendTwitterRequest(twitterAPIURL, params: twitterParams, completion: {
            data, urlResponse, error in
            dispatch_async(dispatch_get_main_queue(), {
                self.handleTwitterData(data, urlResponse: urlResponse, error: error)
            })
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated
    }

    override func textWillChange(textInput: UITextInput?) {
        // The app is about to change the document's contents. Perform any preparation here.
    }

    override func textDidChange(textInput: UITextInput?) {
        // The app has just changed the document's contents, the document context has been updated.
    }

    @IBAction func nextKeyboardBarButtonTapped(sender: UIBarButtonItem) {
        advanceToNextInputMode()
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tweepNames.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("DefaultCell") as UITableViewCell!
        cell.textLabel?.text = "@\(tweepNames[indexPath.row])"
        
        return cell
    }
    
    func handleTwitterData(data: NSData!, urlResponse: NSURLResponse!, error: NSError!) {
        guard let data = data else {
            NSLog ("handleTwitterData() received no data")
            return
        }
        NSLog ("handleTwitterData(), \(data.length) bytes")
        do {
            let jsonObject = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions([]))
            guard let jsonDict = jsonObject as? [String: AnyObject], usersArray = jsonDict ["users"] as? [ [String : AnyObject] ]else {
                NSLog ("handleTwitterData() can't parse data")
                return
            }
            tweepNames.removeAll()
            for userDict in usersArray {
                if let tweepName = userDict["screen_name"] as? String {
                    tweepNames.append(tweepName)
                }
            }
            
            dispatch_async(dispatch_get_main_queue()) {
                self.tableView.reloadData()
            }
        } catch let error as NSError {
            NSLog ("JSON error: \(error)")
        }
    }
    
    func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        let atName = "\(tweepNames[indexPath.row])"
        textDocumentProxy.insertText(atName)
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
}
