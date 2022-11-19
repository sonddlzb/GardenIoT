//
//  ProfileItemViewModel.swift
//  GardenIoT
//
//  Created by đào sơn on 19/11/2022.
//

import UIKit

struct ProfileItemViewModel {
    var profileOption: ProfileOption

    init(profileOption: ProfileOption) {
        self.profileOption = profileOption
    }

    func image() -> UIImage? {
        return UIImage(named: "ic_\(profileOption.name())")
    }

    func labelContent() -> String {
        return self.profileOption.name()
    }
}
