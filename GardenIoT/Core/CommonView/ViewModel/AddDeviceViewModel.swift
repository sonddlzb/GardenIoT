//
//  AddGardenViewModel.swift
//  GardenIoT
//
//  Created by đào sơn on 06/12/2022.
//

import Foundation

struct AddDeviceViewModel {
    var listDeviceTypes = ["sensor", "light-bulb", "esp"]
    var listGardens: [Garden]
    var selectedGarden: Garden?
    var selectedDeviceType: String?

    init(listGardens: [Garden]) {
        self.listGardens = listGardens
    }

    init(listGardens: [Garden], selectedDeviceType: String?) {
        self.listGardens = listGardens
        self.selectedDeviceType = selectedDeviceType
    }

    static func makeEmpty() -> AddDeviceViewModel {
        return AddDeviceViewModel(listGardens: [])
    }

    func isGardenEmptyWarningHidden() -> Bool {
        return self.selectedGarden != nil
    }

    func isDeviceTypeEmptyWarningHidden() -> Bool {
        return self.selectedDeviceType != nil
    }

    func listGardenName() -> [String] {
        return listGardens.map { $0.name }
    }

    mutating func selectItem(at index: Int) {
        self.selectedGarden = self.listGardens[index]
    }

    mutating func selectDeviceType(at index: Int) {
        self.selectedDeviceType = self.listDeviceTypes[index]
    }
}
