//
//  RootInteractor+Login.swift
//  GardenIoT
//
//  Created by đào sơn on 05/11/2022.
//

import Foundation

extension RootInteractor: LoginListener {
    func didLoginSuccess() {
        self.router?.dismissLogin()
        self.router?.routeToHome()
    }
}
