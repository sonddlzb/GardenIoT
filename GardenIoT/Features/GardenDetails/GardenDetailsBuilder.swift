//
//  GardenDetailsBuilder.swift
//  GardenIoT
//
//  Created by đào sơn on 29/11/2022.
//

import RIBs

protocol GardenDetailsDependency: Dependency {

}

final class GardenDetailsComponent: Component<GardenDetailsDependency> {
}

// MARK: - Builder

protocol GardenDetailsBuildable: Buildable {
    func build(withListener listener: GardenDetailsListener, garden: Garden) -> GardenDetailsRouting
}

final class GardenDetailsBuilder: Builder<GardenDetailsDependency>, GardenDetailsBuildable {

    override init(dependency: GardenDetailsDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: GardenDetailsListener, garden: Garden) -> GardenDetailsRouting {
        let component = GardenDetailsComponent(dependency: dependency)
        let viewController = GardenDetailsViewController()
        let interactor = GardenDetailsInteractor(presenter: viewController, garden: garden)
        interactor.listener = listener
        return GardenDetailsRouter(interactor: interactor, viewController: viewController)
    }
}
