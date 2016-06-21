//
//  MentionsTableViewController.swift
//  Smashtag
//
//  Created by 朱梦媛 on 16/6/17.
//  Copyright © 2016年 朱梦媛. All rights reserved.
//

import UIKit
import Twitter

class MentionsTableViewController: UITableViewController {

    
    var tweet : Twitter.Tweet? {
        didSet{
            tweetMentions = ["Images" : .image(tweet!.media),
                             "Hashtags" : .mentions(tweet!.hashtags),
                             "Users" : .mentions(tweet!.userMentions),
                             "Urls" : .mentions(tweet!.urls)]
        }
    }
    private var imageView = UIImageView()
    private var image : UIImage? {
        get{
            return imageView.image!
        }
        set {
            imageView.image = newValue
            imageView.sizeToFit()
        }
    }
    private var imageURL : NSURL? {
        didSet{
            image = nil
            fetchImage()
        }
    }
    
    private func fetchImage() {
        if let url = imageURL {
            if let imageData = NSData(contentsOfURL: url) {
                image = UIImage(data: imageData)
            }
        }
    }
    private enum TweetMentionContents {
        case mentions([Twitter.Mention])
        case image([Twitter.MediaItem])
    }
    
    private var tweetMentions = Dictionary<String, TweetMentionContents>() {
        didSet {
            tableView.reloadData()
        }
    }
    
    
    private let headers : Array = ["Images","Hashtags", "Users", "Urls"]
    override func viewDidLoad() {
        super.viewDidLoad()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return 4
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if let mentions = tweetMentions[headers[section]] {
            switch mentions {
            case .mentions(let value):
                return value.count
            case .image(let value):
                return value.count
            }
            
        }
        return 0
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {

        if let mentions = tweetMentions[headers[section]] {
            switch mentions {
            case .mentions(let value):
                if value.count <= 0 {
                    return nil
                } else {
                    return headers[section]
                }
            case .image(let value):
                if value.count <= 0 {
                    return nil
                } else {
                    return headers[section]
                }
            }
        }
        return  nil
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("MentionsCell", forIndexPath: indexPath)

        if let mentions = tweetMentions[headers[indexPath.section]] {
            switch mentions {
            case .mentions(let value):
                cell.textLabel?.text = value[indexPath.row].keyword
            case .image(let value):
                let imageURL = value[indexPath.row].url
                
                cell.textLabel?.text = imageURL.absoluteString
            }
        }

        return cell
    }
    
    private func configureImageView(media:Twitter.MediaItem) -> UIImageView
    {
        return imageView
        
    }
 
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let cell = tableView.cellForRowAtIndexPath(indexPath)
        let title = headers[indexPath.section]
        switch title {
        case "Images":
            performSegueWithIdentifier("ShowImageView", sender: cell)
            break
        case "Hashtags":
            performSegueWithIdentifier("ShowSearchResult", sender: cell)
            break
        case "Users":
            performSegueWithIdentifier("ShowSearchResult", sender: cell)
            break
        case "Urls":
            if let urlString = cell!.textLabel?.text {
                UIApplication.sharedApplication().openURL(NSURL(string:urlString)!)
            }
            break
        default:
            break
        }

        
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let cell = sender as? UITableViewCell {
            if segue.identifier == "ShowSearchResult" {
                if let tweetVC = segue.destinationViewController as? TweetTableViewController {
                    tweetVC.searchText = cell.textLabel?.text
                }
            }
            if segue.identifier == "ShowImageView"{
                if let imageVC = segue.destinationViewController as? ImageViewController {
                    if let urlString = cell.textLabel?.text {
                        imageVC.imageURL = NSURL(string: urlString)
                    }
                }
            }
            
        }
        
        
            
          
         
    }

}
