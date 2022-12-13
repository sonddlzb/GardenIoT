//
//  DeviceItemViewModel.swift
//  GardenIoT
//
//  Created by đào sơn on 07/12/2022.
//

import Foundation
import RxSwift

struct DeviceItemViewModel {
    var device: Device
    @DIInjected var networkService: NetworkService
    let disposeBag = DisposeBag()

    init(device: Device) {
        self.device = device
    }

    func name() -> String {
        return self.device.name
    }

    func gardenName(completion: @escaping (String?) -> Void) {
        if let accessToken = AuthorizationHelper.shared.getToken() {
            self.networkService.getGardenById(accessToken: accessToken, gardenId: self.device.gardenId).subscribe(onNext: { garden in
                completion(garden.name)
            }, onError: { error in
                print("get garden name error \(error)")
                completion(nil)
            }).disposed(by: self.disposeBag)
        }
    }

    func isOn() -> Bool {
        return self.device.status == "ON"
    }

    func changeStatus() {
        guard self.device.status != nil else {
            return
        }

        self.device.status! = self.device.status! == "ON" ? "OFF" : "ON"
    }
}
