//
//  HomeInteractor+Profile.swift
//  GardenIoT
//
//  Created by đào sơn on 19/11/2022.
//

import Foundation

extension HomeInteractor: ProfileListener {
    func profileWantToSignOut() {
        self.listener?.homeWantToSignOut()
    }
}
