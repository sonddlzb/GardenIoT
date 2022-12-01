//
//  Garden.swift
//  GardenIoT
//
//  Created by đào sơn on 26/11/2022.
//

import Foundation

class Garden {
    var id: String
    var name: String
    var address: String

    init(id: String, name: String, address: String) {
        self.id = id
        self.name = name
        self.address = address
    }

    init(entity: GardenEntity) {
        self.id = entity.id
        self.name = entity.name
        self.address = entity.address
    }
}
