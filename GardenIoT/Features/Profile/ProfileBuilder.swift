//
//  ProfileBuilder.swift
//  GardenIoT
//
//  Created by đào sơn on 16/11/2022.
//

import RIBs

protocol ProfileDependency: Dependency {

}

final class ProfileComponent: Component<ProfileDependency> {
}

// MARK: - Builder

protocol ProfileBuildable: Buildable {
    func build(withListener listener: ProfileListener, account: Account?) -> ProfileRouting
}

final class ProfileBuilder: Builder<ProfileDependency>, ProfileBuildable {

    override init(dependency: ProfileDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: ProfileListener, account: Account?) -> ProfileRouting {
        let component = ProfileComponent(dependency: dependency)
        let viewController = ProfileViewController()
        let interactor = ProfileInteractor(presenter: viewController, account: account)
        interactor.listener = listener
        let detailsBuilder = DIContainer.resolve(DetailsBuildable.self, agrument: component)
        let dataStatisticBuilder = DIContainer.resolve(DataStatisticBuildable.self, agrument: component)
        return ProfileRouter(interactor: interactor,
                             viewController: viewController,
                             detailsBuilder: detailsBuilder,
                             dataStatisticBuilder: dataStatisticBuilder)
    }
}
