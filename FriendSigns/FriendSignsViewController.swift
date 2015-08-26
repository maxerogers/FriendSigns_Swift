//
//  FriendSignsViewController.swift
//  FriendSigns
//
//  Created by Max Rogers on 8/26/15.
//  Copyright (c) 2015 max rogers. All rights reserved.
//

import UIKit

class FriendSignsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet var searchImage: UIImageView!
    @IBOutlet var searchButton: UIButton!
    @IBOutlet var searchField: UITextField!
    @IBOutlet var tableView: UITableView!
    
    var friends:Array<Friend>
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        self.friends = [Friend]()
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
            for friend in friends {
                let date = self.dateFromFacebookString(friend["birthday"] as! String) as NSDate
                var dict:NSDictionary = friend["picture"] as! NSDictionary
                let newFriend = Friend(name: friend["name"] as! String, id: friend["id"] as! String, birthday: friend["birthday"] as! String, sign: self.signFromDate(date), avatarUrl: dict["data"]!["url"]! as! String)
                self.friends.append(newFriend)
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
        cell?.userAvatar.sd_setImageWithURL(self.friends[indexPath.row].avatarUrl, completed: { (image, error, type, url) -> Void in
//            println("\nImage: \(image)\nError: \(error)\nType: \(type)\nUrl: \(url)")
        })
        return cell!
    }
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 88
    }


}
