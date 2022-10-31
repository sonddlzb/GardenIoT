//
//  DailyPictureEntity.swift
//  ColoringByPixel
//
//  Created by Dao Dang Son on 04/10/2022.
//

import Foundation

struct DailyPictureEntity: Codable {
    var id: String
    var thumb: String
    var isPremium: Bool
    var category: String
    var date: String
}
