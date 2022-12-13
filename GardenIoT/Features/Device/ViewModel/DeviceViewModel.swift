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

    func listSensorDevices() -> [Device] {
        return self.listDevices.filter {
            $0.type == "sensor"
        }
    }

    func listControlDevice() -> [Device] {
        return self.listDevices.filter {
            $0.type != "sensor"
        }
    }

    func sensorItem() -> SensorDeviceViewModel {
        return SensorDeviceViewModel(listSensorDevices: self.listSensorDevices())
    }

    func controlItem() -> ControlDeviceViewModel {
        return ControlDeviceViewModel(listControlDevices: self.listControlDevice())
    }

    func heightForSensorDeviceView(maxValue: Double) -> Double {
        let numberOfSensorDevices = self.numberOfSensorDevices()
        guard numberOfSensorDevices != 0 else {
            return 0.0
        }

        return min(maxValue, Double(numberOfSensorDevices) * SensorDeviceViewConst.cellHeight + Double(numberOfSensorDevices - 1) * SensorDeviceViewConst.cellPadding + SensorDeviceViewConst.contentInsets.top + SensorDeviceViewConst.contentInsets.bottom)
    }

    func numberOfSensorDevices() -> Int {
        return self.listSensorDevices().count
    }

    func numberOfControlDevices() -> Int {
        return self.listControlDevice().count
    }

    func heightForControlDeviceView(maxValue: Double) -> Double {
        let numberOfControlDevices = self.numberOfControlDevices()
        guard numberOfControlDevices != 0 else {
            return 0.0
        }

        return min(maxValue, Double(numberOfControlDevices) * ControlDeviceViewConst.cellHeight + Double(numberOfControlDevices - 1) * ControlDeviceViewConst.cellPadding + ControlDeviceViewConst.contentInsets.top + ControlDeviceViewConst.contentInsets.bottom)
    }
}
