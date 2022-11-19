//
//  NetworkService.swift
//  GardenIoT
//
//  Created by Dao Dang Son on 27/10/2022.
//

import Foundation
import RxSwift

protocol NetworkService {
    func login(username: String, password: String) -> Observable<LoginResponse>
    func register(username: String, password: String, name: String, address: String, phoneNumber: String) -> Observable<Any>
    func getUserInfor(accessToken: String) -> Observable<Account>
}

final class NetworkServiceImpl: NetworkService {
    func login(username: String, password: String) -> Observable<LoginResponse> {
        return LoginAPI(username: username, password: password).execute()
    }

    func register(username: String, password: String, name: String, address: String, phoneNumber: String) -> Observable<Any> {
        return RegisterAPI(username: username, password: password, name: name, address: address, phoneNumber: phoneNumber).execute()
    }

    func getUserInfor(accessToken: String) -> Observable<Account> {
        return GetUserInforAPI(accessToken: accessToken).execute()
    }
}
