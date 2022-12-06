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
}
