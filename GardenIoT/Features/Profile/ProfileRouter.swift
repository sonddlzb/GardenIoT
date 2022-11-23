//
//  ProfileRouter.swift
//  GardenIoT
//
//  Created by đào sơn on 16/11/2022.
//

import RIBs

protocol ProfileInteractable: Interactable, DetailsListener {
    var router: ProfileRouting? { get set }
    var listener: ProfileListener? { get set }
}

protocol ProfileViewControllable: ViewControllable {
}

final class ProfileRouter: ViewableRouter<ProfileInteractable, ProfileViewControllable> {

    private var detailsRouter: DetailsRouting?
    private var detailsBuilder: DetailsBuildable
    
    init(interactor: ProfileInteractable,
         viewController: ProfileViewControllable,
         detailsBuilder: DetailsBuildable) {
        self.detailsBuilder = detailsBuilder
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
}

// MARK: - ProfileRouting
extension ProfileRouter: ProfileRouting {
    func routeToDetails(account: Account) {
        let detailsRouter = detailsBuilder.build(withListener: interactor, account: account)
        detailsRouter.viewControllable.uiviewController.modalPresentationStyle = .fullScreen
        self.viewController.present(viewControllable: detailsRouter.viewControllable)
        attachChild(detailsRouter)
        self.detailsRouter = detailsRouter
    }

    func dismissDetails() {
        guard let router = self.detailsRouter else {
            return
        }

        self.viewControllable.dismiss()
        self.detachChild(router)
        self.detailsRouter = nil
    }
}
