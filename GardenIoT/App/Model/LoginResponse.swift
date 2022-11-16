//
//  LoginResponse.swift
//  GardenIoT
//
//  Created by đào sơn on 06/11/2022.
//

import Foundation

class LoginResponse {
    var authorization: String

    init(authorization: String) {
        self.authorization = authorization
    }

    init(entity: LoginResponseEntity) {
        self.authorization = entity.authorization
    var accessToken: String

    init(accessToken: String) {
        self.accessToken = accessToken
    }

    init(entity: LoginResponseEntity) {
        self.accessToken = entity.accessToken
    }
}
