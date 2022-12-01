//
//  GardenRouter.swift
//  GardenIoT
//
//  Created by đào sơn on 26/11/2022.
//

import RIBs

protocol GardenInteractable: Interactable, GardenDetailsListener {
    var router: GardenRouting? { get set }
    var listener: GardenListener? { get set }
}

protocol GardenViewControllable: ViewControllable {
}

final class GardenRouter: ViewableRouter<GardenInteractable, GardenViewControllable> {

    private var gardenDetailsRouter: GardenDetailsRouting?
    private var gardenDetailsBuilder: GardenDetailsBuildable

    init(interactor: GardenInteractable,
         viewController: GardenViewControllable,
         gardenDetailsBuilder: GardenDetailsBuildable) {
        self.gardenDetailsBuilder = gardenDetailsBuilder
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
}

// MARK: - GardenRouting
extension GardenRouter: GardenRouting {
    func routeToGardenDetails(garden: Garden) {
        guard self.gardenDetailsRouter == nil else {
            return
        }

        let router = self.gardenDetailsBuilder.build(withListener: self.interactor, garden: garden)
        self.viewControllable.push(viewControllable: router.viewControllable, animated: true)
        self.attachChild(router)
        self.gardenDetailsRouter = router
    }

    func dismissGardenDetails() {
        guard let router = self.gardenDetailsRouter else {
            return
        }

        self.viewController.popToBefore(viewControllable: router.viewControllable)
        detachChild(router)
        self.gardenDetailsRouter = nil
    }
}
