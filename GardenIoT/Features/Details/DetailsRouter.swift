//
//  DetailsRouter.swift
//  GardenIoT
//
//  Created by đào sơn on 22/11/2022.
//

import RIBs

protocol DetailsInteractable: Interactable {
    var router: DetailsRouting? { get set }
    var listener: DetailsListener? { get set }
}

protocol DetailsViewControllable: ViewControllable {
}

final class DetailsRouter: ViewableRouter<DetailsInteractable, DetailsViewControllable>, DetailsRouting {
    
    override init(interactor: DetailsInteractable, viewController: DetailsViewControllable) {
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
}
