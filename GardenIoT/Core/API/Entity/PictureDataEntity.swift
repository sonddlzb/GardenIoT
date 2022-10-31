//
//  PictureDataEntity.swift
//  ColoringByPixel
//
//  Created by Dao Dang Son on 10/10/2022.
//

import Foundation

struct PictureDataEntity: Codable {
    var matrix: [[Int]]
    var colors: [String: String]
    var grayscaleColors: [String: String]

    func toString() -> String? {
        let encoder = JSONEncoder()
        if let jsonData = try? encoder.encode(self) {
            return String(data: jsonData, encoding: .utf8)
        }

        return nil
    }
}
