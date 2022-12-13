//
//  DeleteResponse.swift
//  GardenIoT
//
//  Created by đào sơn on 07/12/2022.
//

import Foundation

class DeleteResponse {
    var acknowledged: Bool
    var deletedCount: Int

    init(acknowledged: Bool, deletedCount: Int) {
        self.acknowledged = acknowledged
        self.deletedCount = deletedCount
    }

    init(entity: DeleteResponseEntity) {
        self.acknowledged = entity.acknowledged
        self.deletedCount = entity.deletedCount
    }
}
