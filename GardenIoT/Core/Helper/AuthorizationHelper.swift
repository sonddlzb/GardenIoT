//
//  AuthorizationHelper.swift
//  GardenIoT
//
//  Created by đào sơn on 08/11/2022.
//

import Foundation

public struct AuthorizationConst {
    static let authorizationKey = "authorization"
}

class AuthorizationHelper {
    static var shared = AuthorizationHelper()
    func saveToken(_ token: String) {
        UserDefaults.standard.set(token, forKey: AuthorizationConst.authorizationKey)
    }

    func getToken() -> String? {
        return UserDefaults.standard.string(forKey: AuthorizationConst.authorizationKey)
    }
}
