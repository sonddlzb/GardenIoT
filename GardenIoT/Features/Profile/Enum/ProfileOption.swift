//
//  ProfileOption.swift
//  GardenIoT
//
//  Created by đào sơn on 19/11/2022.
//

import Foundation
import UIKit

enum ProfileOption: String {
    case details = "Details"
    case dataStatistic = "Data Statistic"
    case aboutUs = "About Us"
    case signOut = "Sign Out"

    func name() -> String {
        return self.rawValue
    }
}
