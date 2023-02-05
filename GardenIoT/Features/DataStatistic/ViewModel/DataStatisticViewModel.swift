//
//  DataStatisticViewModel.swift
//  GardenIoT
//
//  Created by đào sơn on 10/01/2023.
//

import Foundation

struct DataStatisticViewModel {
    var fromDate: Date
    var toDate: Date
    var listGardens: [Garden] = []
    var selectedGarden: Garden?

    func fromDateToString() -> String {
        return self.fromDate.formatDate()
    }

    func toDateToString() -> String {
        return self.toDate.formatDate()
    }

    func listGardenName() -> [String] {
        return listGardens.map { $0.name }
    }

    mutating func selectItem(at index: Int) {
        self.selectedGarden = listGardens[index]
    }

    func toDate(dateString: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter.date(from: dateString)
    }
}
