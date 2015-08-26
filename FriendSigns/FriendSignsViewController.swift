//
//  FriendSignsViewController.swift
//  FriendSigns
//
//  Created by Max Rogers on 8/26/15.
//  Copyright (c) 2015 max rogers. All rights reserved.
//

import UIKit
import Foundation

class FriendSignsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate {
    
    @IBOutlet var searchField: UITextField!
    @IBOutlet var tableView: UITableView!
    
    var friends:Array<Friend>
    var allFriends:Array<Friend>
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        self.friends = [Friend]()
        self.allFriends = [Friend]()
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tableView.delegate = self
        tableView.dataSource = self
        tableView.registerNib(UINib(nibName: "FriendCell", bundle: nil), forCellReuseIdentifier: "friendCell")
        searchField.returnKeyType = UIReturnKeyType.Search
        searchField.delegate = self
        loadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    // MARK: - Zodiac
    func dateFromFacebookString(dateString:String) -> NSDate{
        var dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        var date = dateFormatter.dateFromString(dateString)
        return date!
    }
    
    func signFromDate(date:NSDate) -> String {
        var result:String
        var components = NSCalendar.currentCalendar().components(NSCalendarUnit.DayCalendarUnit | NSCalendarUnit.MonthCalendarUnit | NSCalendarUnit.YearCalendarUnit , fromDate: date)
        switch components.month {
        case 1:
            if components.day >= 21 {
                result = "aquarius"
            }
            else {
                result = "capricorn"
            }
        case 2:
            if components.day >= 20 {
                result = "pisces"
            }
            else {
                result = "aquarius"
            }
        case 3:
            if components.day >= 21 {
                result = "aries"
            }
            else {
                result = "pisces"
            }
        case 4:
            if components.day >= 21 {
                result = "taurus"
            }
            else {
                result = "aries"
            }
        case 5:
            if components.day >= 22 {
                result = "gemini"
            }
            else {
                result = "taurus"
            }
        case 6:
            if components.day >= 22 {
                result = "cancer"
            }
            else {
                result = "gemini"
            }
        case 7:
            if components.day >= 23 {
                result = "leo"
            }
            else {
                result = "cancer"
            }
        case 8:
            if components.day >= 24 {
                result = "virgo"
            }
            else {
                result = "leo"
            }
        case 9:
            if components.day >= 24 {
                result = "libra"
            }
            else {
                result = "virgo"
            }
        case 10:
            if components.day >= 24 {
                result = "scorpio"
            } else {
                result = "libra"
            }
        case 11:
            if components.day >= 23 {
                result = "sagittarius"
            }
            else {
                result = "scorpio"
            }
        case 12:
            if components.day >= 22 {
                result = "capricorn"
            }
            else {
                result = "sagittarius"
            }
        default:
            result = "pisces"
        }
        return result
    }
    
    // MARK: - Facebook
    func loadData() {
        //Get user's information
        //me?fields=name,birthday // user's info
        //me/friends?fields=name,birthday //friends' info
        FBSDKGraphRequest(graphPath: "me/friends?fields=name,birthday,picture", parameters: nil).startWithCompletionHandler({ (connection, object, error) -> Void in
            var friends = object["data"] as! NSArray
            println(friends)
            self.friends = [Friend]()
            self.allFriends = [Friend]()
            for friend in friends {
                let date = self.dateFromFacebookString(friend["birthday"] as! String) as NSDate
                var dict:NSDictionary = friend["picture"] as! NSDictionary
                let newFriend = Friend(name: friend["name"] as! String, id: friend["id"] as! String, birthday: friend["birthday"] as! String, sign: self.signFromDate(date), avatarUrl: dict["data"]!["url"]! as! String)
                self.friends.append(newFriend)
                self.allFriends.append(newFriend)
            }
            self.tableView.reloadData()
        })
    }
    
    // MARK: - TableView
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.friends.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let friendCell = "friendCell"
        var cell:FriendCell? = tableView.dequeueReusableCellWithIdentifier(friendCell) as? FriendCell
        if cell == nil{
            cell = FriendCell(style: UITableViewCellStyle.Default, reuseIdentifier: friendCell)
            
        }
        cell?.userNameLabel.text = self.friends[indexPath.row].name
        cell?.birthdayLabel.text = self.friends[indexPath.row].birthday
        cell?.signImageView.image = UIImage(named: self.friends[indexPath.row].sign)
        println(self.friends[indexPath.row].avatarUrl)
        cell?.userAvatar.sd_setImageWithURL(self.friends[indexPath.row].avatarUrl)
        return cell!
    }
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return FriendCell.heightForCell()
    }
    
    //Mark: - Textfield
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        var searchString:String
        if range.length > 0 {
            let index: String.Index = advance(textField.text.endIndex, -1*range.length)
            searchString = textField.text.substringToIndex(index)
        }
        else {
            searchString = textField.text + string
        }
        self.friends = [Friend]()
        for friend in self.allFriends {
            var userName:NSString = friend.name.lowercaseString as NSString
            println("\(searchString) \(userName)")
            if userName.containsString(searchString.lowercaseString) {
                self.friends.append(friend)
            }
        }
        if searchString == "" {
            self.friends = self.allFriends.map {$0.copy()}
        }
        self.tableView.reloadData()
        return true
    }// return NO to not change text
    
//    func textFieldShouldReturn(textField: UITextField) -> Bool {
//        textField.text = ""
//        if searchString == "" {
//            self.friends = self.allFriends.map {$0.copy()}
//        }
//        self.tableView.reloadData()
//        return true
//    }

}
