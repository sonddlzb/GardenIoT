//
//  GardenBuilder.swift
//  GardenIoT
//
//  Created by đào sơn on 26/11/2022.
//

import RIBs

protocol GardenDependency: Dependency {

}

final class GardenComponent: Component<GardenDependency> {
}

// MARK: - Builder

protocol GardenBuildable: Buildable {
    func build(withListener listener: GardenListener) -> GardenRouting
}

final class GardenBuilder: Builder<GardenDependency>, GardenBuildable {

    override init(dependency: GardenDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: GardenListener) -> GardenRouting {
        let component = GardenComponent(dependency: dependency)
        let viewController = GardenViewController()
        let interactor = GardenInteractor(presenter: viewController)
        interactor.listener = listener
        let gardenDetailsBuilder = DIContainer.resolve(GardenDetailsBuildable.self, agrument: component)
        return GardenRouter(interactor: interactor,
                            viewController: viewController,
                            gardenDetailsBuilder: gardenDetailsBuilder)
    }
}
