//
//  Account.swift
//  GardenIoT
//
//  Created by đào sơn on 06/11/2022.
//

import Foundation

class Account {
    var name: String
    var phoneNumber: String
    var address: String
    var username: String
    var password: String

    init(name: String, phoneNumber: String, address: String, username: String, password: String) {
        self.name = name
        self.phoneNumber = phoneNumber
        self.address = address
        self.username = username
        self.password = password
    }
}
