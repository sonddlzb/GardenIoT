//
//  MeasureResultEntity.swift
//  GardenIoT
//
//  Created by đào sơn on 29/11/2022.
//

import Foundation

struct MeasureResultEntity: Codable {
    var id: String
    var gardenId: String
    var deviceId: String
    var temperature: Float
    var moisture: Float
    var createdAt: String
}
