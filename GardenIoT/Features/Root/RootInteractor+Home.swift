//
//  RootInteractor+Home.swift
//  GardenIoT
//
//  Created by đào sơn on 19/11/2022.
//

import Foundation

extension RootInteractor: HomeListener {
    func homeWantToSignOut() {
        self.router?.routeToLogin()
    }
}
