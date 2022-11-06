//
//  RootInteractor+Splash.swift
//  GardenIoT
//
//  Created by đào sơn on 05/11/2022.
//

import Foundation

extension RootInteractor: SplashListener {
    func dismissSplash() {
        self.router?.dismissSplash()
        self.router?.routeToLogin()
    }
}
