//
//  SensorDeviceViewModel.swift
//  GardenIoT
//
//  Created by đào sơn on 06/12/2022.
//

import Foundation

struct SensorDeviceViewModel {
    var listSensorDevices: [Device]

    init(listSensorDevices: [Device]) {
        self.listSensorDevices = listSensorDevices
    }

    static func makeEmpty() -> SensorDeviceViewModel {
        return SensorDeviceViewModel(listSensorDevices: [])
    }

    func numberOfDevices() -> Int {
        return self.listSensorDevices.count
    }

    func item(at index: Int) -> DeviceItemViewModel {
        return DeviceItemViewModel(device: self.listSensorDevices[index])
    }

    func device(at index: Int) -> Device {
        return self.listSensorDevices[index]
    }
}
