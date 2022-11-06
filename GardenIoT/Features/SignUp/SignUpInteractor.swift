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
}

protocol SignUpListener: AnyObject {
    func signUpWantToDismiss()
}

final class SignUpInteractor: PresentableInteractor<SignUpPresentable>, SignUpInteractable {

    weak var router: SignUpRouting?
    weak var listener: SignUpListener?

    override init(presenter: SignUpPresentable) {
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
}
