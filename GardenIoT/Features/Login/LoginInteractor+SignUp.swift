//
//  LoginInteractor+SignUp.swift
//  GardenIoT
//
//  Created by đào sơn on 05/11/2022.
//

import Foundation

extension LoginInteractor: SignUpListener {
    func signUpWantToDismiss() {
        self.router?.dismissSignUp()
    }
}
