//
//  HomeInteractor.swift
//  GardenIoT
//
//  Created by đào sơn on 06/11/2022.
//

import RIBs
import RxSwift
import SVProgressHUD

protocol HomeRouting: ViewableRouting {
    func routeToTab(_ tab: HomeTab)
    func didFinishGetUserInfor(account: Account)
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
    @DIInjected var networkService: NetworkService

    override init(presenter: HomePresentable) {
        super.init(presenter: presenter)
        presenter.listener = self
    }

    override func didBecomeActive() {
        super.didBecomeActive()
        self.router?.routeToTab(.home)
        self.getUserInfor()
        print(AuthorizationHelper.shared.getToken())
    }

    override func willResignActive() {
        super.willResignActive()
    }

    func getUserInfor() {
        SVProgressHUD.show()
        if let accessToken = AuthorizationHelper.shared.getToken() {
            networkService.getUserInfor(accessToken: accessToken).subscribe(onNext: { account in
                self.router?.didFinishGetUserInfor(account: account)
                SVProgressHUD.dismiss()
            }, onError: { error in
                print("Failed to get user infor with error \(error)")
                SVProgressHUD.dismiss()
            }).disposeOnDeactivate(interactor: self)
        }
    }
}

// MARK: - HomePresentableListener
extension HomeInteractor: HomePresentableListener {
    func didSelectAt(tab: HomeTab) {
        self.router?.routeToTab(tab)
    }
}
