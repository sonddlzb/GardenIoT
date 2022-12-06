//
//  AddGardenViewModel.swift
//  GardenIoT
//
//  Created by đào sơn on 06/12/2022.
//

import Foundation

struct AddDeviceViewModel {
    var listGardens: [Garden]
    var selectedGarden: Garden?

    init(listGardens: [Garden]) {
        self.listGardens = listGardens
    }

    static func makeEmpty() -> AddDeviceViewModel {
        return AddDeviceViewModel(listGardens: [])
    }

    func isEmptyWarningHidden() -> Bool {
        return self.selectedGarden != nil
    }

    func listGardenName() -> [String] {
        return listGardens.map { $0.name }
    }

    mutating func selectItem(at index: Int) {
        self.selectedGarden = self.listGardens[index]
    }
}
