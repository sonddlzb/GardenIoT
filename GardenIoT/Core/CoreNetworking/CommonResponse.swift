//
//  CommonResponse.swift
//  CoreNetworking
//
//  Created by Thanh Vu on 18/10/2021.
//

import Foundation

public enum StatusCodeType: String, Error, Codable {
    case somethingWrong
    case success = "SUCCESS"
    case passwordNotMatch = "STATUS_USER_WRONG_PASSWORD"
    case userNotExist = "STATUS_USER_NOT_REGISTERED"
    case payloadInvalid = "STATUS_COMMON_PAYLOAD_INVALID"
    case userExist = "STATUS_USER_EXIST"
    case tokenInvalid = "STATUS_TOKEN_INVALID"
}

open class CommonResponse<Body: Codable>: Codable {
    open var data: Body
}

open class ClientFailedResponse<String: Codable>: Codable {
    open var message: String
}
