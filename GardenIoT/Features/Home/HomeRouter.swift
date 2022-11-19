//
//  HomeRouter.swift
//  GardenIoT
//
//  Created by đào sơn on 06/11/2022.
//

import RIBs

protocol HomeInteractable: Interactable, ProfileListener {
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

    init(interactor: HomeInteractable,
         viewController: HomeViewControllable,
         profileBuilder: ProfileBuildable) {
        self.profileBuilder = profileBuilder
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
}

extension HomeRouter: HomeRouting {
    func routeToTab(_ tab: HomeTab) {
        switch tab {
        case .home:
            print("route to home tab")
        case .device:
            print("route to device tab")
        case .profile:
            self.routeToProfile()
        }
    }

    func routeToProfile() {
        if self.profileRouter == nil {
            self.profileRouter = self.profileBuilder.build(withListener: self.interactor)
            self.attachChild(self.profileRouter!)
        }

        self.viewController.embedViewController(self.profileRouter!.viewControllable)
    }
}
