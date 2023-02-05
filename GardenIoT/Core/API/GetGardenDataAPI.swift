//
//  GetGardenDataAPI.swift
//  GardenIoT
//
//  Created by đào sơn on 10/01/2023.
//

import Foundation

class GetGardenDataAPI: HttpEndpoint {
    var accessToken: String
    var gardenId: String
    var fromDate: Date
    var toDate: Date

    init(accessToken: String, gardenId: String, fromDate: Date, toDate: Date) {
        self.accessToken = accessToken
        self.gardenId = gardenId
        self.fromDate = fromDate
        self.toDate = toDate
    }

    func path() -> String {
        return "api/measure-data?from=\(self.fromDate.formatDate())&to=\(self.toDate.formatDate())&gardenId=\(self.gardenId)"
    }

    func method() -> HttpMethod {
        .get
    }

    func headers() -> [String: String]? {
        return ["Authorization": "Bearer \(accessToken)"]
    }

    func middleware() -> NetworkMiddleware {
        return SolarCatchErrorMiddleware()
    }

    func convertObject(data: Data) throws -> [MeasureResult] {
        let response = try JSONDecoder().decode(CommonResponse<[MeasureResultEntity]>.self, from: data)
        return (response.data.map({
            MeasureResult(entity: $0)
        }))
    }
}
