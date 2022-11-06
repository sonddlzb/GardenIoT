//
//  NetworkService.swift
//  ColoringByPixel
//
//  Created by Dao Dang Son on 27/09/2022.
//

import Foundation
import RxSwift

protocol NetworkService {
//    func getListPictures(page: Int, pageSize: Int) -> Observable<[Picture]>
//    func getListHotPictures() -> Observable<[Picture]>
//    func getListNewPictures() -> Observable<[Picture]>
//    func getAllCategories() -> Observable<[Category]>
//    func getListPicturesByCategoryId(_ categoryId: String, page: Int, pageSize: Int) -> Observable<[Picture]>
//    func getListDailyPictures(utc: Int) -> Observable<[DailyPicture]>
//    func getPictureDetailById(_ id: String) -> Observable<PictureDetail>
    func login(username: String, password: String) -> Observable<LoginResponse>
}

final class NetworkServiceImpl: NetworkService {
//    func getListPictures(page: Int, pageSize: Int) -> Observable<[Picture]> {
//        return GetListPicturesAPI(page: page, pageSize: pageSize).execute()
//    }
//
//    func getListHotPictures() -> Observable<[Picture]> {
//        return GetHotPicturesAPI().execute()
//    }
//
//    func getListNewPictures() -> Observable<[Picture]> {
//        return GetNewPicturesAPI().execute()
//    }
//
//    func getAllCategories() -> Observable<[Category]> {
//        return GetAllCategoriesAPI().execute()
//    }
//
//    func getListPicturesByCategoryId(_ categoryId: String, page: Int, pageSize: Int) -> Observable<[Picture]> {
//        return GetListPicturesByCategoryAPI(categoryId: categoryId, page: page, pageSize: pageSize).execute()
//    }
//
//    func getListDailyPictures(utc: Int) -> Observable<[DailyPicture]> {
//        return GetDailyPicturesAPI(utc: utc).execute()
//    }
//
//    func getPictureDetailById(_ id: String) -> Observable<PictureDetail> {
//        return GetPictureDetailByIdAPI(pictureId: id).execute()
//    }

    func login(username: String, password: String) -> Observable<LoginResponse> {
        return LoginAPI(username: username, password: password).execute()
    }
}
