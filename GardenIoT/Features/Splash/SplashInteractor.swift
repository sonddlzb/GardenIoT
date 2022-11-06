//
//  SplashInteractor.swift
//  GardenIoT
//
//  Created by đào sơn on 04/11/2022.
//

import RIBs
import RxSwift

protocol SplashRouting: ViewableRouting {
}

protocol SplashPresentable: Presentable {
    var listener: SplashPresentableListener? { get set }
}

protocol SplashListener: AnyObject {
    func dismissSplash()
}

final class SplashInteractor: PresentableInteractor<SplashPresentable>, SplashInteractable, SplashPresentableListener {

    weak var router: SplashRouting?
    weak var listener: SplashListener?

    override init(presenter: SplashPresentable) {
        super.init(presenter: presenter)
        presenter.listener = self
    }

    override func didBecomeActive() {
        super.didBecomeActive()
        DispatchQueue.main.asyncAfter(deadline: .now()+3, execute: {
            self.listener?.dismissSplash()
        })
    }

    override func willResignActive() {
        super.willResignActive()
    }
}
