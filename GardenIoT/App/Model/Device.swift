//
//  Device.swift
//  GardenIoT
//
//  Created by đào sơn on 29/11/2022.
//

import Foundation

class Device {
    var gardenId: String
    var id: String
    var name: String
    var description: String
    var status: String

    init(gardenId: String, id: String, name: String, description: String, status: String) {
        self.gardenId = gardenId
        self.id = id
        self.name = name
        self.description = description
        self.status = status
    }

    init(entity: DeviceEntity) {
        self.gardenId = entity.gardenId
        self.id = entity.id
        self.name = entity.name
        self.description = entity.description
        self.status = entity.status
    }
}
