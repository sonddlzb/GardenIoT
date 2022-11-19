//
//  Account.swift
//  GardenIoT
//
//  Created by đào sơn on 06/11/2022.
//

import Foundation

class Account {
    var id: String
    var name: String
    var phoneNumber: String
    var address: String
    var username: String
    var role: String

    init(id: String, name: String, phoneNumber: String, address: String, username: String, role: String) {
        self.id = id
        self.name = name
        self.phoneNumber = phoneNumber
        self.address = address
        self.username = username
        self.role = role
    }

    init(entity: AccountEntity) {
        self.id = entity.id
        self.name = entity.name
        self.phoneNumber = entity.phoneNumber
        self.address = entity.address
        self.username = entity.username
        self.role = entity.role
    }
}
