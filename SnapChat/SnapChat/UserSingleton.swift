//
//  UserSingleton.swift
//  SnapChat
//
//  Created by Veysal on 16.10.22.
//

import Foundation

class UserSingleton {
    
    static let sharedUserInfo = UserSingleton()
    var email = ""
    var username = ""

    private init() {
        
    }
}
