//
//  MeasureResult.swift
//  GardenIoT
//
//  Created by đào sơn on 29/11/2022.
//

import Foundation

class MeasureResult {
    var id: String
    var gardenId: String
    var deviceId: String
    var temperature: Float
    var moisture: Float
    var createdAt: String

    init(id: String, temperature: Float, moisture: Float, gardenId: String, deviceId: String, createdAt: String) {
        self.id = id
        self.temperature = temperature
        self.moisture = moisture
        self.gardenId = gardenId
        self.deviceId = deviceId
        self.createdAt = createdAt
    }

    init(entity: MeasureResultEntity) {
        self.id = entity.id
        self.temperature = entity.temperature
        self.moisture = entity.moisture
        self.gardenId = entity.gardenId
        self.deviceId = entity.deviceId
        self.createdAt = entity.createdAt
    }
}
