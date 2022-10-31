//
//  PictureDetailEntity.swift
//  ColoringByPixel
//
//  Created by Dao Dang Son on 10/10/2022.
//

import Foundation

struct PictureDetailEntity: Codable {
    var id: String
    var thumb: String
    var isPremium: Bool
    var category: String
    var data: PictureDataEntity
}
