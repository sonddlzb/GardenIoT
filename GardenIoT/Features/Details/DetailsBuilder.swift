//
//  DetailsBuilder.swift
//  GardenIoT
//
//  Created by đào sơn on 22/11/2022.
//

import RIBs

protocol DetailsDependency: Dependency {

}

final class DetailsComponent: Component<DetailsDependency> {
}

// MARK: - Builder

protocol DetailsBuildable: Buildable {
    func build(withListener listener: DetailsListener, account: Account) -> DetailsRouting
}

final class DetailsBuilder: Builder<DetailsDependency>, DetailsBuildable {

    override init(dependency: DetailsDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: DetailsListener, account: Account) -> DetailsRouting {
        let component = DetailsComponent(dependency: dependency)
        let viewController = DetailsViewController()
        let interactor = DetailsInteractor(presenter: viewController, account: account)
        interactor.listener = listener
        return DetailsRouter(interactor: interactor, viewController: viewController)
    }
}
