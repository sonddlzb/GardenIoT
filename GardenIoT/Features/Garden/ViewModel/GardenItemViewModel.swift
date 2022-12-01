//
//  GardenItemViewModel.swift
//  GardenIoT
//
//  Created by đào sơn on 26/11/2022.
//

import Foundation

struct GardenItemViewModel {
    var garden: Garden

    init(garden: Garden) {
        self.garden = garden
    }

    func name() -> String {
        return self.garden.name
    }

    func address() -> String {
        return self.garden.address
    }
}
