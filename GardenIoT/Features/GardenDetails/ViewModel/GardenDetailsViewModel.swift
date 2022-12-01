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
}
