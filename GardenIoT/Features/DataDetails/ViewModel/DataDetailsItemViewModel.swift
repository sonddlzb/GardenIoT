//
//  DataDetailsItemViewModel.swift
//  GardenIoT
//
//  Created by đào sơn on 11/02/2023.
//

import Foundation

struct DataDetailsItemViewModel {
    var measureData: MeasureResult
    var isHeader: Bool

    func dateLabelContent() -> String {
        return isHeader ? "Time" : measureData.createdAt
    }

    func temperatureLabelContent() -> String {
        return isHeader ? "Temperature" : "\(measureData.temperature)"
    }

    func moistureLabelContent() -> String {
        return isHeader ? "Moisture" : "\(measureData.moisture)"
    }

    func dataLabelFontSize() -> Float {
        return self.isHeader ? 18.0 : 12.0
    }
}
