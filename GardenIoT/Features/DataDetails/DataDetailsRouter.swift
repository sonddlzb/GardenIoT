//
//  DataDetailsRouter.swift
//  GardenIoT
//
//  Created by đào sơn on 11/02/2023.
//

import RIBs

protocol DataDetailsInteractable: Interactable {
    var router: DataDetailsRouting? { get set }
    var listener: DataDetailsListener? { get set }
}

protocol DataDetailsViewControllable: ViewControllable {
}

final class DataDetailsRouter: ViewableRouter<DataDetailsInteractable, DataDetailsViewControllable>, DataDetailsRouting {
    
    override init(interactor: DataDetailsInteractable, viewController: DataDetailsViewControllable) {
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
}
