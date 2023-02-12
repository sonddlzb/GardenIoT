//
//  Notification.swift
//  GardenIoT
//
//  Created by đào sơn on 06/02/2023.
//

import Foundation

struct NotificationMessage: Codable {
    var temperature: Double?
    var moisture: Double?
    var warningType: Warning
    var gardenId: String
}
