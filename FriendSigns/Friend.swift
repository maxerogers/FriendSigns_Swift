//
//  Friend.swift
//  FriendSigns
//
//  Created by Max Rogers on 8/26/15.
//  Copyright (c) 2015 max rogers. All rights reserved.
//

import Foundation

class Friend {
    let name:String
    let birthday:String
    let sign:String
    let id:String
    init (name:String, id:String, birthday:String, sign:String) {
        self.name = name
        self.birthday = birthday
        self.sign = sign
        self.id = id
    }
}