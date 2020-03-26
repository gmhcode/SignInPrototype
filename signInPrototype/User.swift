//
//  User.swift
//  signInPrototype
//
//  Created by Greg Hughes on 3/26/20.
//  Copyright © 2020 Greg Hughes. All rights reserved.
//

import Foundation

class User {
    let userID : String
    let email : String?
    let firstName : String
    let lastName : String
    let uuid = UUID()
    
    init(userID : String, email: String?, firstName: String?, lastName: String?) {
        self.userID = userID
        self.email = email
        self.firstName = firstName ?? " "
        self.lastName = lastName ?? " "
    }
    
    
}
