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
}
