//
//  LoginRouter.swift
//  GardenIoT
//
//  Created by đào sơn on 05/11/2022.
//

import RIBs

protocol LoginInteractable: Interactable, SignUpListener {
    var router: LoginRouting? { get set }
    var listener: LoginListener? { get set }
}

protocol LoginViewControllable: ViewControllable {
}

final class LoginRouter: ViewableRouter<LoginInteractable, LoginViewControllable> {

    var signUpBuilder: SignUpBuildable
    var signUpRouter: SignUpRouting?
    
    init(interactor: LoginInteractable,
         viewController: LoginViewControllable,
         signUpBuilder: SignUpBuildable) {
        self.signUpBuilder = signUpBuilder
        super.init(interactor: interactor,
                   viewController: viewController)
        interactor.router = self
    }
}

extension LoginRouter: LoginRouting {
    func routeToSignUp() {
        let router = self.signUpBuilder.build(withListener: self.interactor)
        self.viewController.present(viewControllable: router.viewControllable)
        attachChild(router)
        self.signUpRouter = router
    }

    func dismissSignUp() {
        guard let router = self.signUpRouter else {
            return
        }

        self.viewControllable.dismiss()
        detachChild(router)
        self.signUpRouter = nil
    }
}
