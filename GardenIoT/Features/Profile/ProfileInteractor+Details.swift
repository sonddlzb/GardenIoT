//
//  ProfileInteractor+Details.swift
//  GardenIoT
//
//  Created by đào sơn on 23/11/2022.
//

import Foundation

extension ProfileInteractor: DetailsListener {
    func detailsWantToDismiss(updatedAccount: Account) {
        self.reloadAccountInformation(updatedAccount: updatedAccount)
        self.router?.dismissDetails()
    }
}
