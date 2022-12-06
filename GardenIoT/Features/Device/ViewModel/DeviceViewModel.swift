//
//  DeviceViewModel.swift
//  GardenIoT
//
//  Created by đào sơn on 06/12/2022.
//

import Foundation

struct DeviceViewModel {
    var listDevices: [Device]

    init(listDevices: [Device]) {
        self.listDevices = listDevices
    }

    static func makeEmpty() -> DeviceViewModel {
        return DeviceViewModel(listDevices: [])
    }

    func sensorItem() -> SensorDeviceViewModel {
        return SensorDeviceViewModel(listSensorDevices: self.listDevices.filter {
            $0.status.isEmpty
        })
    }

    func controlItem() -> ControlDeviceViewModel {
        return ControlDeviceViewModel(listControlDevices: self.listDevices.filter {
            !$0.status.isEmpty
        })
    }
}
