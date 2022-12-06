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
        if AuthorizationHelper.shared.getToken() == nil {
            self.router?.routeToLogin()
        } else {
            self.router?.routeToHome()
        }
//        self.router?.routeToHome()
    }
}
