//
//  DeviceRouter.swift
//  GardenIoT
//
//  Created by đào sơn on 24/11/2022.
//

import RIBs

protocol DeviceInteractable: Interactable {
    var router: DeviceRouting? { get set }
    var listener: DeviceListener? { get set }
}

protocol DeviceViewControllable: ViewControllable {
}

final class DeviceRouter: ViewableRouter<DeviceInteractable, DeviceViewControllable>, DeviceRouting {
    
    override init(interactor: DeviceInteractable, viewController: DeviceViewControllable) {
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
}
