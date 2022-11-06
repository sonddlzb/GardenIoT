//
//  LoginBuilder.swift
//  GardenIoT
//
//  Created by đào sơn on 05/11/2022.
//

import RIBs

protocol LoginDependency: Dependency {

}

final class LoginComponent: Component<LoginDependency> {
}

// MARK: - Builder

protocol LoginBuildable: Buildable {
    func build(withListener listener: LoginListener) -> LoginRouting
}

final class LoginBuilder: Builder<LoginDependency>, LoginBuildable {

    override init(dependency: LoginDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: LoginListener) -> LoginRouting {
        let component = LoginComponent(dependency: dependency)
        let viewController = LoginViewController()
        let interactor = LoginInteractor(presenter: viewController)
        let signUpBuilder = DIContainer.resolve(SignUpBuildable.self, agrument: component)
        interactor.listener = listener
        return LoginRouter(interactor: interactor, viewController: viewController, signUpBuilder: signUpBuilder)
    }
}
