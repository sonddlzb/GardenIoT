//
//  LoginInteractor.swift
//  GardenIoT
//
//  Created by đào sơn on 05/11/2022.
//

import RIBs
import RxSwift
import SVProgressHUD

protocol LoginRouting: ViewableRouting {
    func routeToSignUp()
    func dismissSignUp()
}

protocol LoginPresentable: Presentable {
    var listener: LoginPresentableListener? { get set }

    func bind(viewModel: LoginViewModel)
}

protocol LoginListener: AnyObject {
    func didLoginSuccess()
}

final class LoginInteractor: PresentableInteractor<LoginPresentable>, LoginInteractable {

    weak var router: LoginRouting?
    weak var listener: LoginListener?

    var viewModel: LoginViewModel
    @DIInjected var networkService: NetworkService

    override init(presenter: LoginPresentable) {
        self.viewModel = LoginViewModel(username: "", password: "")
        super.init(presenter: presenter)
        presenter.listener = self
    }

    override func didBecomeActive() {
        super.didBecomeActive()
    }

    override func willResignActive() {
        super.willResignActive()
    }

    func login() {
        guard !self.viewModel.checkEmpty() else {
            self.presenter.bind(viewModel: self.viewModel)
            return
        }

        SVProgressHUD.show()
        self.networkService.login(username: self.viewModel.username, password: self.viewModel.password).subscribe(onNext: { loginResponse in
            AuthorizationHelper.shared.saveToken(loginResponse.accessToken)
            SVProgressHUD.dismiss()
            self.listener?.didLoginSuccess()
        }, onError: { error in
            SVProgressHUD.dismiss()
            FailedDialog.show(title: "Failed to sign in!", message: "Please check your username or password and try again.")
        }).disposeOnDeactivate(interactor: self)
        self.presenter.bind(viewModel: self.viewModel)
    }
}

// MARK: - LoginPresentableListener
extension LoginInteractor: LoginPresentableListener {
    func didTapSignUp() {
        self.router?.routeToSignUp()
    }

    func didTapSignIn() {
        self.login()
    }

    func didEndEditTextField(username: String, password: String) {
        self.viewModel.updateData(username: username, password: password)
        self.presenter.bind(viewModel: self.viewModel)
    }
}
