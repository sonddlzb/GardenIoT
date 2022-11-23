//
//  DetailsInteractor.swift
//  GardenIoT
//
//  Created by đào sơn on 22/11/2022.
//

import RIBs
import RxSwift
import SVProgressHUD

protocol DetailsRouting: ViewableRouting {
}

protocol DetailsPresentable: Presentable {
    var listener: DetailsPresentableListener? { get set }

    func didUpdateAccount(isSuccess: Bool, message: String)
    func bind(viewModel: DetailsViewModel)
}

protocol DetailsListener: AnyObject {
    func detailsWantToDismiss(updatedAccount: Account)
}

final class DetailsInteractor: PresentableInteractor<DetailsPresentable>, DetailsInteractable {

    weak var router: DetailsRouting?
    weak var listener: DetailsListener?
    var originalAccount: Account
    var viewModel: DetailsViewModel
    @DIInjected var networkService: NetworkService

    init(presenter: DetailsPresentable, account: Account) {
        self.originalAccount = account
        self.viewModel = DetailsViewModel(account: originalAccount.makeACopy())
        super.init(presenter: presenter)
        presenter.listener = self
    }

    override func didBecomeActive() {
        super.didBecomeActive()
        self.presenter.bind(viewModel: self.viewModel)
    }

    override func willResignActive() {
        super.willResignActive()
    }

    func updateAccount() {
        SVProgressHUD.show()
        if let token = AuthorizationHelper.shared.getToken() {
            self.networkService.updateUserInfor(accessToken: token, userId: self.originalAccount.id, account: self.viewModel.account).subscribe(onNext: { responseData in
                SVProgressHUD.dismiss()
                if let account = responseData as? Account {
                    self.presenter.didUpdateAccount(isSuccess: true, message: "Save account information successfully")
                } else {
                    self.presenter.didUpdateAccount(isSuccess: false, message: responseData as! String)
                }
            }, onError: { error in
                SVProgressHUD.dismiss()
                self.presenter.didUpdateAccount(isSuccess: false, message: error.localizedDescription)
            }).disposeOnDeactivate(interactor: self)
        }
    }
}

// MARK: - DetailsPresentableListener
extension DetailsInteractor: DetailsPresentableListener {
    func didEndEditTextField(name: String, address: String, phoneNumber: String) {
        self.viewModel.updateAccount(name: name, address: address, phoneNumber: phoneNumber)
        self.presenter.bind(viewModel: self.viewModel)
        print("update phone number to \(phoneNumber)")
    }

    func didFinishUpdateAccount(isSaved: Bool) {
        guard isSaved, self.viewModel.isAccountChanged(originalAccount: self.originalAccount) else {
            return
        }

        self.updateAccount()
    }

    func didTapCancelToExit() {
        self.listener?.detailsWantToDismiss(updatedAccount: self.viewModel.account)
    }
}
