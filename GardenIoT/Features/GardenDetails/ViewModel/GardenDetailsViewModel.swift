//
//  GardenDetailsViewModel.swift
//  GardenIoT
//
//  Created by đào sơn on 29/11/2022.
//

import Foundation

struct GardenDetailsViewModel {
    var garden: Garden
    var temparature: Float = 0.0
    var moisture: Float = 0.0
    var listDevices: [Device] = []
    var currentSensor: Device?

    init(garden: Garden) {
        self.garden = garden
    }

    func celciusTemparatureValue() -> Float {
        return round(self.temparature*100)/100
    }

    func fahrenheitTemparatureValue() -> Float {
        return round((self.temparature * 1.8 + 32) * 100)/100
    }

    func name() -> String {
        return self.garden.name
    }

    private func listSensorDevices() -> [Device] {
        return self.listDevices.filter {
            $0.type == "sensor"
        }
    }

    private func listControlDevice() -> [Device] {
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

    func numberOfSensorDevices() -> Int {
        return self.listSensorDevices().count
    }

    func numberOfControlDevices() -> Int {
        return self.listControlDevice().count
    }

    func heightForSensorDeviceView(maxValue: Double) -> Double {
        let numberOfSensorDevices = self.numberOfSensorDevices()
        guard numberOfSensorDevices != 0 else {
            return 0.0
        }

        return min(maxValue, Double(numberOfSensorDevices) * SensorDeviceViewConst.cellHeight + Double(numberOfSensorDevices - 1) * SensorDeviceViewConst.cellPadding + SensorDeviceViewConst.contentInsets.top + SensorDeviceViewConst.contentInsets.bottom)
    }

    func heightForControlDeviceView(maxValue: Double) -> Double {
        let numberOfControlDevices = self.numberOfControlDevices()
        guard numberOfControlDevices != 0 else {
            return 0.0
        }

        return min(maxValue, Double(numberOfControlDevices) * ControlDeviceViewConst.cellHeight + Double(numberOfControlDevices - 1) * ControlDeviceViewConst.cellPadding + ControlDeviceViewConst.contentInsets.top + ControlDeviceViewConst.contentInsets.bottom)
    }
}
