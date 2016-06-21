//
//  TweetTableViewCell.swift
//  Smashtag
//
//  Created by 朱梦媛 on 16/6/17.
//  Copyright © 2016年 朱梦媛. All rights reserved.
//

import UIKit
import Twitter

class TweetTableViewCell: UITableViewCell {

    @IBOutlet weak var tweetScreenNameLabel: UILabel!
    @IBOutlet weak var tweetTextLabel: UILabel!
    @IBOutlet weak var tweetProfileImageVIew: UIImageView!
    @IBOutlet weak var tweetCreatedLabel: UILabel!
    
    
    var tweet : Twitter.Tweet? {
        didSet{
            updateUI()
        }
    }
    
    private func updateUI()
    {
        // reset any existing tweet information
        tweetTextLabel?.attributedText = nil
        tweetScreenNameLabel?.text = nil
        tweetProfileImageVIew?.image = nil
        tweetCreatedLabel?.text = nil
        
        //load new information from our tweet (if any)
        if let tweet = self.tweet
        {
            let tweetTextLabelAttributedText = NSMutableAttributedString(string: tweet.text)
            for mention : Twitter.Mention in tweet.hashtags {
                tweetTextLabelAttributedText.setAttributes([NSForegroundColorAttributeName : UIColor.orangeColor()], range: mention.nsrange)
            }
            for mention : Twitter.Mention in tweet.urls {
                tweetTextLabelAttributedText.setAttributes([NSForegroundColorAttributeName : UIColor.blueColor()], range: mention.nsrange)
            }
            for mention : Twitter.Mention in tweet.userMentions {
                tweetTextLabelAttributedText.setAttributes([NSForegroundColorAttributeName : UIColor.redColor()], range: mention.nsrange)
            }
            
            
            tweetTextLabel?.attributedText = tweetTextLabelAttributedText
            
            
//            tweetTextLabel?.text = tweet.text
//            if tweetTextLabel?.text != nil {
//                
//                for _ in tweet.media {
//                    tweetTextLabel?.text! += " 📷"
//                }
//            }
            
            tweetScreenNameLabel?.text = "\(tweet.user)" //why?
            
            if let profileImageURL = tweet.user.profileImageURL {
                dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0) , {
                    if let imageData = NSData(contentsOfURL: profileImageURL) {
                        dispatch_async(dispatch_get_main_queue(), {
                            [weak weakSelf = self] in
                            weakSelf?.tweetProfileImageVIew?.image = UIImage(data: imageData)
                        })
                    }
                })
               
            }
            
            let formatter = NSDateFormatter()
            if NSDate().timeIntervalSinceDate(tweet.created) > 24*60*60 {
                formatter.dateStyle = NSDateFormatterStyle.ShortStyle
            } else {
                formatter.timeStyle = NSDateFormatterStyle.ShortStyle
            }
            tweetCreatedLabel?.text = formatter.stringFromDate(tweet.created)
            
            
        
        }
    }
    
}
