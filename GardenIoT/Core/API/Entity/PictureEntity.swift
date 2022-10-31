//
//  PictureEntity.swift
//  ColoringByPixel
//
//  Created by Dao Dang Son on 27/09/2022.
//

import Foundation

struct PictureEntity: Codable {
    var id: String
    var thumb: String
    var isPremium: Bool
    var category: String
}
