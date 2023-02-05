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
    func updateUserInfor(accessToken: String, userId: String, account: Account) -> Observable<Any>
    func getAllGardens(accessToken: String) -> Observable<[Garden]>
    func addNewGarden(accessToken: String, name: String, address: String) -> Observable<Any>
    func createNewDevice(accessToken: String, name: String, description: String, gardenId: String, deviceType: String) -> Observable<Any>
    func getAllDevices(accessToken: String) -> Observable<[Device]>
    func getGardenById(accessToken: String, gardenId: String) -> Observable<Garden>
    func deleteDeviceById(accessToken: String, gardenId: String, deviceId: String) -> Observable<Any>
    func getAllDevicesByGardenId(accessToken: String, gardenId: String) -> Observable<[Device]>
    func updateDevice(accessToken: String, name: String, description: String, gardenId: String, deviceType: String, deviceId: String) -> Observable<Any>
    func updateGarden(accessToken: String, name: String, address: String, gardenId: String) -> Observable<Any>
    func getGardenData(accessToken: String, gardenId: String, fromDate: Date, toDate: Date) -> Observable<[MeasureResult]>
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

    func updateUserInfor(accessToken: String, userId: String, account: Account) -> Observable<Any> {
        return UpdateUserInforAPI(accessToken: accessToken, userId: userId, account: account).execute()
    }

    func getAllGardens(accessToken: String) -> Observable<[Garden]> {
        return GetAllGardensAPI(accessToken: accessToken).execute()
    }

    func addNewGarden(accessToken: String, name: String, address: String) -> Observable<Any> {
        return AddNewGardenAPI(accessToken: accessToken, name: name, address: address).execute()
    }

    func createNewDevice(accessToken: String, name: String, description: String, gardenId: String, deviceType: String) -> Observable<Any> {
        return CreateNewDeviceAPI(name: name, description: description, gardenId: gardenId, accessToken: accessToken, deviceType: deviceType).execute()
    }

    func getAllDevices(accessToken: String) -> Observable<[Device]> {
        return GetAllDevicesAPI(accessToken: accessToken).execute()
    }

    func getGardenById(accessToken: String, gardenId: String) -> Observable<Garden> {
        return GetGardenByIdAPI(accessToken: accessToken, gardenId: gardenId).execute()
    }

    func deleteDeviceById(accessToken: String, gardenId: String, deviceId: String) -> Observable<Any> {
        return DeleteDeviceByIdAPI(accessToken: accessToken, gardenId: gardenId, deviceId: deviceId).execute()
    }

    func getAllDevicesByGardenId(accessToken: String, gardenId: String) -> Observable<[Device]> {
        return GetAllDevicesByGardenIdAPI(accessToken: accessToken, gardenId: gardenId).execute()
    }

    func updateDevice(accessToken: String, name: String, description: String, gardenId: String, deviceType: String, deviceId: String) -> Observable<Any> {
        return UpdateDeviceAPI(name: name, description: description, gardenId: gardenId, accessToken: accessToken, deviceType: deviceType, deviceId: deviceId).execute()
    }

    func updateGarden(accessToken: String, name: String, address: String, gardenId: String) -> Observable<Any> {
        return UpdateGardenAPI(name: name, address: address, gardenId: gardenId, accessToken: accessToken).execute()
    }

    func getGardenData(accessToken: String, gardenId: String, fromDate: Date, toDate: Date) -> Observable<[MeasureResult]> {
        return GetGardenDataAPI(accessToken: accessToken, gardenId: gardenId, fromDate: fromDate, toDate: toDate).execute()
    }
}
