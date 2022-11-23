//
//  DetailsViewModel.swift
//  GardenIoT
//
//  Created by đào sơn on 23/11/2022.
//

import Foundation

struct DetailsViewModel {
    var account: Account

    init(account: Account) {
        self.account = account
    }

    func updateAccount(name: String, address: String, phoneNumber: String) {
        self.account.name = name
        self.account.address = address
        self.account.phoneNumber = phoneNumber
    }

    static func makeEmpty() -> DetailsViewModel {
        return DetailsViewModel(account: Account(id: "", name: "", phoneNumber: "", address: "", username: "", role: ""))
    }

    func isAccountChanged(originalAccount: Account) -> Bool {
        return (self.account.name != originalAccount.name) ||
                (self.account.address != originalAccount.address) ||
                (self.account.phoneNumber != originalAccount.phoneNumber)
    }

    func isPhoneNumberValid() -> Bool {
        return self.account.phoneNumber.matches(regex: "(\\+84)+([0-9]{9})\\b")
    }

    func isEmpty() -> Bool {
        return self.account.address.isEmpty || self.account.name.isEmpty || self.account.phoneNumber.isEmpty
    }

    func isSaveEnable() -> Bool {
        return self.isPhoneNumberValid() && !self.isEmpty()
    }
}
