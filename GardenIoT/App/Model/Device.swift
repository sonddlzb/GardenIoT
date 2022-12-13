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
    var type: String
    var status: String?
    var userId: String

    init(gardenId: String, id: String, name: String, description: String, type: String, status: String, userId: String) {
        self.gardenId = gardenId
        self.id = id
        self.name = name
        self.description = description
        self.type = type
        self.status = status
        self.userId = userId
    }

    init(gardenId: String, id: String, name: String, description: String, type: String, userId: String) {
        self.gardenId = gardenId
        self.id = id
        self.name = name
        self.description = description
        self.type = type
        self.userId = userId
    }

    init(entity: DeviceEntity) {
        self.gardenId = entity.gardenId
        self.id = entity.id
        self.name = entity.name
        self.description = entity.description
        self.status = entity.status
        self.type = entity.type
        self.userId = entity.userId
    }
}
