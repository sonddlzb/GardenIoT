//
//  GardenViewModel.swift
//  GardenIoT
//
//  Created by đào sơn on 26/11/2022.
//

import Foundation

struct GardenViewModel {
    var listGardens: [Garden]

    init(listGardens: [Garden]) {
        self.listGardens = listGardens
    }

    static func makeEmpty() -> GardenViewModel {
        return GardenViewModel(listGardens: [])
    }

    func item(at index: Int) -> GardenItemViewModel {
        return GardenItemViewModel(garden: self.listGardens[index])
    }

    func numberOfGardens() -> Int {
        return self.listGardens.count
    }

    func garden(at index: Int) -> Garden {
        return self.listGardens[index]
    }

    mutating func add(garden: Garden) {
        self.listGardens.append(garden)
    }
}
