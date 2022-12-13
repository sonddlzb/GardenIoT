//
//  DeleteResponseEntity.swift
//  GardenIoT
//
//  Created by đào sơn on 07/12/2022.
//

import Foundation

struct DeleteResponseEntity: Codable {
    var acknowledged: Bool
    var deletedCount: Int
}
