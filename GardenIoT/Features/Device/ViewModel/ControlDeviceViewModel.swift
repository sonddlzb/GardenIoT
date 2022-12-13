//
//  ControlDeviceViewModel.swift
//  GardenIoT
//
//  Created by đào sơn on 06/12/2022.
//

import Foundation

struct ControlDeviceViewModel {
    var listControlDevices: [Device]

    init(listControlDevices: [Device]) {
        self.listControlDevices = listControlDevices
    }

    static func makeEmpty() -> ControlDeviceViewModel {
        return ControlDeviceViewModel(listControlDevices: [])
    }

    func numberOfDevices() -> Int {
        return self.listControlDevices.count
    }

    func item(at index: Int) -> DeviceItemViewModel {
        return DeviceItemViewModel(device: self.listControlDevices[index])
    }

    func device(at index: Int) -> Device {
        return self.listControlDevices[index]
    }
}
