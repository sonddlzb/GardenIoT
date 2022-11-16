//
//  SignUpViewModel.swift
//  GardenIoT
//
//  Created by đào sơn on 07/11/2022.
//

import Foundation

struct SignUpViewModel {
    var username = ""
    var password = ""
    var confirmPassword = ""
    var name = ""
    var address = ""
    var phoneNumber = ""

    init(username: String, password: String, confirmPassword: String, name: String, address: String, phoneNumber: String) {
        self.username = username
        self.password = password
        self.confirmPassword = confirmPassword
        self.name = name
        self.address = address
        self.phoneNumber = phoneNumber
    }

    func isEmpty() -> Bool {
        return self.username.isEmpty || self.password.isEmpty || self.confirmPassword.isEmpty || self.address.isEmpty || self.name.isEmpty || self.phoneNumber.isEmpty
    }

    func isPhoneNumberValid() -> Bool {
        return self.phoneNumber.matches(regex: "(\\+84)+([0-9]{9})\\b")
    }

    func isValidPassword() -> Bool {
        return self.password == self.confirmPassword
    }

    mutating func updateData(username: String, password: String, confirmPassword: String, name: String, address: String, phoneNumber: String) {
        self.username = username
        self.password = password
        self.confirmPassword = confirmPassword
        self.name = name
        self.address = address
        self.phoneNumber = phoneNumber
    }

    func validateData() -> [ValidationStatus] {
        var validatedResult: [ValidationStatus] = []

        if !self.isPhoneNumberValid() {
            validatedResult.append(.invalidPhoneNumber)
        }

        if !self.isValidPassword() {
            validatedResult.append(.invalidPassword)
        }

        return validatedResult
    }
}
