//
//  SignUpInteractor.swift
//  GardenIoT
//
//  Created by đào sơn on 05/11/2022.
//

import RIBs
import RxSwift

protocol SignUpRouting: ViewableRouting {
}

protocol SignUpPresentable: Presentable {
    var listener: SignUpPresentableListener? { get set }

    func bind(viewModel: SignUpViewModel)
}

protocol SignUpListener: AnyObject {
    func signUpWantToDismiss()
}

final class SignUpInteractor: PresentableInteractor<SignUpPresentable>, SignUpInteractable {

    weak var router: SignUpRouting?
    weak var listener: SignUpListener?

    var viewModel: SignUpViewModel
    @DIInjected var networkService: NetworkService

    override init(presenter: SignUpPresentable) {
        self.viewModel = SignUpViewModel(username: "", password: "", confirmPassword: "", name: "", address: "", phoneNumber: "")
        super.init(presenter: presenter)
        presenter.listener = self
    }

    override func didBecomeActive() {
        super.didBecomeActive()
    }

    override func willResignActive() {
        super.willResignActive()
    }
}

extension SignUpInteractor: SignUpPresentableListener {
    func didTapCancelButton() {
        self.listener?.signUpWantToDismiss()
    }

    func didTapSignUpButton() {
        guard !self.viewModel.isEmpty() else {
            self.presenter.bind(viewModel: self.viewModel)
            return
        }

        let validatedResult = self.viewModel.validateData()
        guard validatedResult.isEmpty else {
            FailedDialog.show(title: "Failed to sign up!", message: validatedResult.first!.rawValue)
            return
        }

        self.networkService.register(username: self.viewModel.username, password: self.viewModel.password, name: self.viewModel.name, address: self.viewModel.address, phoneNumber: self.viewModel.phoneNumber).subscribe(onNext: { registerResponse in
            AuthorizationHelper.shared.saveToken(registerResponse.accessToken)
       }, onError: { error in
            FailedDialog.show(title: "Failed to sign up!", message: "Please check your information and try again.")
        }).disposeOnDeactivate(interactor: self)
        self.presenter.bind(viewModel: self.viewModel)
    }

    func didEndEditTextField(username: String, password: String, confirmPassword: String, name: String, address: String, phoneNumber: String) {
        self.viewModel.updateData(username: username, password: password, confirmPassword: confirmPassword, name: name, address: address, phoneNumber: phoneNumber)
        self.presenter.bind(viewModel: self.viewModel)
    }
}
