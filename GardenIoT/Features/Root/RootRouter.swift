//
//  RootRouter.swift
//  GardenIoT
//
//  Created by đào sơn on 01/11/2022.
//

import RIBs

protocol RootInteractable: Interactable, SplashListener, LoginListener, HomeListener {
    var router: RootRouting? { get set }
    var listener: RootListener? { get set }
}

protocol RootViewControllable: ViewControllable {
}

final class RootRouter: ViewableRouter<RootInteractable, RootViewControllable> {
    var window: UIWindow

    var splashBuilder: SplashBuildable
    var splashRouter: SplashRouting?

    var loginBuilder: LoginBuildable
    var loginRouter: LoginRouting?

    var homeBuilder: HomeBuildable
    var homeRouter: HomeRouting?

    init(interactor: RootInteractable,
         viewController: RootViewControllable,
         window: UIWindow,
         splashBuilder: SplashBuildable,
         loginBuilder: LoginBuildable,
         homeBuilder: HomeBuildable) {
        self.window = window
        self.splashBuilder = splashBuilder
        self.loginBuilder = loginBuilder
        self.homeBuilder = homeBuilder
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
}

// MARK: - RootRouting
extension RootRouter: RootRouting {
    func routeToSplash() {
        let router = self.splashBuilder.build(withListener: self.interactor)
        let navigationController = BaseNavigationController(rootViewController: router.viewControllable.uiviewController)
        window.rootViewController = navigationController
        attachChild(router)
        self.splashRouter = router
    }

    func dismissSplash() {
        guard let router = self.splashRouter else {
            return
        }

        detachChild(router)
        self.splashRouter = nil
    }

    func routeToLogin() {
        let router = self.loginBuilder.build(withListener: self.interactor)
        let navigationController = BaseNavigationController(rootViewController: router.viewControllable.uiviewController)
        window.rootViewController = navigationController
        attachChild(router)
        self.loginRouter = router
    }

    func dismissLogin() {
        guard let router = self.loginRouter else {
            return
        }

        detachChild(router)
        self.loginRouter = nil
    }

    func routeToHome() {
        let router = self.homeBuilder.build(withListener: self.interactor)
        let navigationController = BaseNavigationController(rootViewController: router.viewControllable.uiviewController)
        window.rootViewController = navigationController
        attachChild(router)
        self.homeRouter = router
    }
}
