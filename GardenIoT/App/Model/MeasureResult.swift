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
    var temparature: Float
    var moisture: Float

    init(id: String, temparature: Float, moisture: Float, gardenId: String, deviceId: String) {
        self.id = id
        self.temparature = temparature
        self.moisture = moisture
        self.gardenId = gardenId
        self.deviceId = deviceId
    }

    init(entity: MeasureResultEntity) {
        self.id = entity.id
        self.temparature = entity.temparature
        self.moisture = entity.moisture
        self.gardenId = entity.gardenId
        self.deviceId = entity.deviceId
    }
}
