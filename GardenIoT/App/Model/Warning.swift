//
//  WarningType.swift
//  GardenIoT
//
//  Created by đào sơn on 06/02/2023.
//

import Foundation

struct Warning: Codable {
    var temperature: WarningType?
    var moisture: WarningType?
}
