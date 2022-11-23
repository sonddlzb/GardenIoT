//
//  ProfileInteractor.swift
//  GardenIoT
//
//  Created by đào sơn on 16/11/2022.
//

import RIBs
import RxSwift
import SVProgressHUD

protocol ProfileRouting: ViewableRouting {
    func routeToDetails(account: Account)
    func dismissDetails()
}

protocol ProfilePresentable: Presentable {
    var listener: ProfilePresentableListener? { get set }

    func bind(viewModel: ProfileViewModel)
    func showConfirmDialog()
}

protocol ProfileListener: AnyObject {
    func profileWantToSignOut()
}

final class ProfileInteractor: PresentableInteractor<ProfilePresentable>, ProfileInteractable {

    weak var router: ProfileRouting?
    weak var listener: ProfileListener?
    @DIInjected var networkService: NetworkService
    var viewModel: ProfileViewModel!

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
                print("userID:  \(account.id)")
                self.viewModel = ProfileViewModel(account: account)
                self.presenter.bind(viewModel: self.viewModel)
            }, onError: { error in
                print("Failed to get user infor with error \(error)")
            })
        }
    }

    func reloadAccountInformation(updatedAccount: Account) {
        self.viewModel.account = updatedAccount
        self.presenter.bind(viewModel: self.viewModel)
    }
}

// MARK: - ProfilePresentableListener
extension ProfileInteractor: ProfilePresentableListener {
    func didSelect(option: ProfileOption) {
        switch option {
        case .details:
            self.router?.routeToDetails(account: self.viewModel.account)
        case .aboutUs:
            print("did select about us")
        case .signOut:
            self.presenter.showConfirmDialog()
        }
    }

    func didTapConfirmToSignOut() {
        AuthorizationHelper.shared.deleteCurrentToken()
        SVProgressHUD.show()
        // delay 0.5s to improve UX
        DispatchQueue.main.asyncAfter(deadline: .now()+0.5, execute: {
            SVProgressHUD.dismiss()
            self.listener?.profileWantToSignOut()
        })
    }
}
