//
//  ProfileListener+DataStatistic.swift
//  GardenIoT
//
//  Created by đào sơn on 09/01/2023.
//

import Foundation

extension ProfileInteractor: DataStatisticListener {
    func dataStatisticWantToDismiss() {
        self.router?.dismissDataStatistic()
    }
}
