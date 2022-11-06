//
//  LoginViewModel.swift
//  GardenIoT
//
//  Created by đào sơn on 06/11/2022.
//

import Foundation

struct LoginViewModel {
    var username = ""
    var password = ""

    init(username: String, password: String) {
        self.username = username
        self.password = password
    }

    func checkEmpty() -> Bool {
        return self.username.isEmpty || self.password.isEmpty
    }

    mutating func updateData(username: String, password: String) {
        self.username = username
        self.password = password
    }
}
