//
//  DataStatisticRouter.swift
//  GardenIoT
//
//  Created by đào sơn on 09/01/2023.
//

import RIBs

protocol DataStatisticInteractable: Interactable {
    var router: DataStatisticRouting? { get set }
    var listener: DataStatisticListener? { get set }
}

protocol DataStatisticViewControllable: ViewControllable {
}

final class DataStatisticRouter: ViewableRouter<DataStatisticInteractable, DataStatisticViewControllable>, DataStatisticRouting {
    
    override init(interactor: DataStatisticInteractable, viewController: DataStatisticViewControllable) {
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
}
