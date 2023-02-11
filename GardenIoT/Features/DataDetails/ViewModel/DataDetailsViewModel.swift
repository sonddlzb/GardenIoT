//
//  DataDetailsViewModel.swift
//  GardenIoT
//
//  Created by đào sơn on 11/02/2023.
//

import Foundation

struct DataDetailsViewModel {
    var listMeasureData: [MeasureResult]

    func highestTemperature() -> Float {
        return listMeasureData.max { (prev, next) in
            prev.temperature < next.temperature
        }?.temperature ?? 0.0
    }

    func lowestTemperature() -> Float {
        return listMeasureData.min { (prev, next) in
            prev.temperature < next.temperature
        }?.temperature ?? 0.0
    }

    func highestMoisture() -> Float {
        return listMeasureData.max { (prev, next) in
            prev.moisture < next.moisture
        }?.moisture ?? 0.0
    }

    func lowestMoisture() -> Float {
        return listMeasureData.min { (prev, next) in
            prev.moisture < next.moisture
        }?.moisture ?? 0.0
    }

    func numberOfRecords() -> Int {
        return self.listMeasureData.count
    }

    func item(at index: Int) -> DataDetailsItemViewModel? {
        guard !self.listMeasureData.isEmpty && index < self.listMeasureData.count else {
            return nil
        }
        
        return DataDetailsItemViewModel(measureData: self.listMeasureData[index], isHeader: index == 0)
    }

    func temperatureLabelContent() -> String {
        return "The highest/lowest temperature: \(self.highestTemperature())°C/\(self.lowestTemperature())°C"
    }

    func moistureLabelContent() -> String {
        return "The highest/lowest moisture: \(self.highestMoisture())%/\(self.lowestMoisture())%"
    }
}
