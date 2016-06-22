//
//  RecentSearchITermsTableViewController.swift
//  Smashtag
//
//  Created by 朱梦媛 on 16/6/21.
//  Copyright © 2016年 朱梦媛. All rights reserved.
//

import UIKit

class RecentSearchITermsTableViewController: UITableViewController {

    private var rencentSearchTerms : Array<String>? {
        get {
            if let terms = NSUserDefaults.standardUserDefaults().objectForKey("rencentSearchTerms") as? Array<String> {
                return terms
            } else {
                return nil
            }
        }
    }
    
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
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if let terms = rencentSearchTerms {
            return terms.count
        } else {
            return 0
        }
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("TermCells", forIndexPath: indexPath)

        if let terms = rencentSearchTerms {
            cell.textLabel?.text = terms[indexPath.row]
        }

        return cell
    }
 
 
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if let cell = sender as? UITableViewCell {
            if segue.identifier == "ShowSearchResult" {
                if let tweetVC = segue.destinationViewController as? TweetTableViewController {
                    tweetVC.searchText = cell.textLabel?.text
                }
            }
        }
    }
 

}
