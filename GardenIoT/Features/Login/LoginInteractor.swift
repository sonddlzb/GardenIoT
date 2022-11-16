//
//  LoginInteractor.swift
//  GardenIoT
//
//  Created by đào sơn on 05/11/2022.
//

import RIBs
import RxSwift

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
//        self.networkService.login(username: self.viewModel.username, password: self.viewModel.password).subscribe(onNext: { loginResponse in
//            print("login success")
//            self.listener?.didLoginSuccess()
//        }, onError: { error in
//            print("login failed with error: \(error)")
//            self.listener?.didLoginSuccess()
//        }).disposeOnDeactivate(interactor: self)
        self.listener?.didLoginSuccess()
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
