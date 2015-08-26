//
//  LoginViewController.swift
//  FriendSigns
//
//  Created by Max Rogers on 8/26/15.
//  Copyright (c) 2015 max rogers. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    @IBOutlet var loginButton: FBSDKLoginButton!
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loginButton.readPermissions = ["public_profile", "user_birthday", "user_friends"]
        // Do any additional setup after loading the view.
        if let token = FBSDKAccessToken.currentAccessToken() {
            // User is logged in, do work such as go to next view controller.
//            self.navigationController?.setViewControllers([FriendSignsViewController(nibName: "FriendSignsViewController", bundle: nil)], animated: true)
            self.navigationController?.pushViewController(FriendSignsViewController(nibName: "FriendSignsViewController", bundle: nil), animated: true)
        }
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

}
