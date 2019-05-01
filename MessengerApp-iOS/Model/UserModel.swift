//
//  UserModel.swift
//  MessengerApp-iOS
//
//  Created by Anderson Nascimento on 30/04/19.
//  Copyright © 2019 anderltda. All rights reserved.
//

import Foundation

import Foundation

class UserModel {
    
    var id: String
    var name: String
    var email: String
    var phone: String
    var create: NSDate!
    var update: NSDate!
    
    init(id: String, name: String, email: String, phone: String) {
        self.id = id
        self.name = name
        self.email = email
        self.phone = phone
    }
    
    
}
