//
//  GardenInteractor+GardenDetails.swift
//  GardenIoT
//
//  Created by đào sơn on 29/11/2022.
//

import Foundation

extension GardenInteractor: GardenDetailsListener {
    func dismissGardenDetails() {
        self.router?.dismissGardenDetails()
    }

    func reloadData() {
        self.fetchListGardens()
    }
}
