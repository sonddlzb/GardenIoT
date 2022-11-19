//
//  ProfileInteractor.swift
//  GardenIoT
//
//  Created by đào sơn on 16/11/2022.
//

import RIBs
import RxSwift

protocol ProfileRouting: ViewableRouting {
}

protocol ProfilePresentable: Presentable {
    var listener: ProfilePresentableListener? { get set }

    func bind(viewModel: ProfileViewModel)
}

protocol ProfileListener: AnyObject {
}

final class ProfileInteractor: PresentableInteractor<ProfilePresentable>, ProfileInteractable, ProfilePresentableListener {

    weak var router: ProfileRouting?
    weak var listener: ProfileListener?
    @DIInjected var networkService: NetworkService

    override init(presenter: ProfilePresentable) {
        super.init(presenter: presenter)
        presenter.listener = self
    }

    override func didBecomeActive() {
        super.didBecomeActive()
        self.getUserInfor()
    }

    override func willResignActive() {
        super.willResignActive()
    }

    func getUserInfor() {
        if let accessToken = AuthorizationHelper.shared.getToken() {
            networkService.getUserInfor(accessToken: accessToken).subscribe(onNext: { account in
                print(account.name)
                self.presenter.bind(viewModel: ProfileViewModel(account: account))
            }, onError: { error in
                print("Failed to get user infor with error \(error)")
            })
        }
    }
}
