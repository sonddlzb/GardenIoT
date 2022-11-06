//
//  RootInteractor.swift
//  GardenIoT
//
//  Created by đào sơn on 01/11/2022.
//

import RIBs
import RxSwift

protocol RootRouting: ViewableRouting {
    func routeToSplash()
    func dismissSplash()
    func routeToLogin()
    func dismissLogin()
    func routeToHome()
}

protocol RootPresentable: Presentable {
    var listener: RootPresentableListener? { get set }
}

protocol RootListener: AnyObject {
}

final class RootInteractor: PresentableInteractor<RootPresentable>, RootInteractable, RootPresentableListener {

    weak var router: RootRouting?
    weak var listener: RootListener?

    override init(presenter: RootPresentable) {
        super.init(presenter: presenter)
        presenter.listener = self
    }

    override func didBecomeActive() {
        super.didBecomeActive()
        self.router?.routeToSplash()
    }

    override func willResignActive() {
        super.willResignActive()
    }
}
