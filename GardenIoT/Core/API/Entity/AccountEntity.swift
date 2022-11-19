//
//  AccountEntity.swift
//  GardenIoT
//
//  Created by đào sơn on 17/11/2022.
//

import Foundation

struct AccountEntity: Codable {
    var id: String
    var name: String
    var phoneNumber: String
    var address: String
    var username: String
    var role: String
}
