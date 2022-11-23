//
//  HomeInteractor.swift
//  GardenIoT
//
//  Created by đào sơn on 06/11/2022.
//

import RIBs
import RxSwift

protocol HomeRouting: ViewableRouting {
    func routeToTab(_ tab: HomeTab)
}

protocol HomePresentable: Presentable {
    var listener: HomePresentableListener? { get set }
}

protocol HomeListener: AnyObject {
    func homeWantToSignOut()
}

final class HomeInteractor: PresentableInteractor<HomePresentable>, HomeInteractable {

    weak var router: HomeRouting?
    weak var listener: HomeListener?

    override init(presenter: HomePresentable) {
        super.init(presenter: presenter)
        presenter.listener = self
    }

    override func didBecomeActive() {
        super.didBecomeActive()
        print(AuthorizationHelper.shared.getToken())
    }

    override func willResignActive() {
        super.willResignActive()
    }
}

// MARK: - HomePresentableListener
extension HomeInteractor: HomePresentableListener {
    func didSelectAt(tab: HomeTab) {
        self.router?.routeToTab(tab)
    }
}
