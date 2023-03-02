//
//  TemporaryMeasureResult.swift
//  GardenIoT
//
//  Created by đào sơn on 01/03/2023.
//

import Foundation


import Foundation

class TemporaryMeasureResult {
    var temperature: Float
    var moisture: Float

    init(temperature: Float, moisture: Float) {
        self.temperature = temperature
        self.moisture = moisture
    }

    init(entity: TemporaryMeasureResultEntity) {
        self.temperature = entity.temperature
        self.moisture = entity.moisture
    }
}
