//
//  HomeRouter.swift
//  GardenIoT
//
//  Created by đào sơn on 06/11/2022.
//

import RIBs

protocol HomeInteractable: Interactable, ProfileListener, DeviceListener, GardenListener {
    var router: HomeRouting? { get set }
    var listener: HomeListener? { get set }
}

protocol HomeViewControllable: ViewControllable {
    func embedViewController(_ viewControlller: ViewControllable)
    func highlightOnTabBar(tab: HomeTab)
}

final class HomeRouter: ViewableRouter<HomeInteractable, HomeViewControllable> {

    private var profileBuilder: ProfileBuildable
    private var profileRouter: ProfileRouting?

    private var deviceBuilder: DeviceBuildable
    private var deviceRouter: DeviceRouting?

    private var gardenBuilder: GardenBuildable
    private var gardenRouter: GardenRouting?

    private var account: Account?

    init(interactor: HomeInteractable,
         viewController: HomeViewControllable,
         profileBuilder: ProfileBuildable,
         deviceBuilder: DeviceBuildable,
         gardenBuilder: GardenBuildable) {
        self.profileBuilder = profileBuilder
        self.deviceBuilder = deviceBuilder
        self.gardenBuilder = gardenBuilder
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
}

extension HomeRouter: HomeRouting {
    func routeToTab(_ tab: HomeTab) {
        switch tab {
        case .home:
            routeToGarden()
        case .device:
            self.routeToDevice()
        case .profile:
            self.routeToProfile()
        }
    }

    func didFinishGetUserInfor(account: Account) {
        guard self.profileRouter == nil else {
            self.profileRouter!.updateUserInfor(account: account)
            return
        }

        self.account = account
    }

    func routeToProfile() {
        if self.profileRouter == nil {
            self.profileRouter = self.profileBuilder.build(withListener: self.interactor, account: self.account)
            self.attachChild(self.profileRouter!)
        }

        self.viewController.embedViewController(self.profileRouter!.viewControllable)
    }

    func routeToDevice() {
        if self.deviceRouter == nil {
            self.deviceRouter = self.deviceBuilder.build(withListener: self.interactor)
            self.attachChild(self.deviceRouter!)
        }

        self.viewController.embedViewController(self.deviceRouter!.viewControllable)
    }

    func routeToGarden() {
        if self.gardenRouter == nil {
            self.gardenRouter = self.gardenBuilder.build(withListener: self.interactor)
            self.attachChild(self.gardenRouter!)
        }

        self.viewController.embedViewController(self.gardenRouter!.viewControllable)
    }
}
