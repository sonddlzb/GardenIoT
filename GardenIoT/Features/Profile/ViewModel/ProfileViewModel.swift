//
//  ProfileViewModel.swift
//  GardenIoT
//
//  Created by đào sơn on 17/11/2022.
//

import Foundation

struct ProfileViewModel {
    var account: Account
    var profileOptions: [ProfileOption] = [.details, .aboutUs, .signOut]

    init(account: Account) {
        self.account = account
    }

    func item(at index: Int) -> ProfileItemViewModel {
        return ProfileItemViewModel(profileOption: self.profileOptions[index])
    }

    func numberOfOptions() -> Int {
        return self.profileOptions.count
    }

    static func makeEmpty() -> ProfileViewModel {
        return ProfileViewModel(account: Account(id: "", name: "", phoneNumber: "", address: "", username: "", role: ""))
    }
}
