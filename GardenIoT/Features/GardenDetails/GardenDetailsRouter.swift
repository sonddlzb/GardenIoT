//
//  GardenDetailsRouter.swift
//  GardenIoT
//
//  Created by đào sơn on 29/11/2022.
//

import RIBs

protocol GardenDetailsInteractable: Interactable {
    var router: GardenDetailsRouting? { get set }
    var listener: GardenDetailsListener? { get set }
}

protocol GardenDetailsViewControllable: ViewControllable {
}

final class GardenDetailsRouter: ViewableRouter<GardenDetailsInteractable, GardenDetailsViewControllable>, GardenDetailsRouting {
    
    override init(interactor: GardenDetailsInteractable, viewController: GardenDetailsViewControllable) {
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
}
