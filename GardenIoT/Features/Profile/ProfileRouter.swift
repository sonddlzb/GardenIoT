//
//  ProfileRouter.swift
//  GardenIoT
//
//  Created by đào sơn on 16/11/2022.
//

import RIBs

protocol ProfileInteractable: Interactable, DetailsListener, DataStatisticListener {
    var router: ProfileRouting? { get set }
    var listener: ProfileListener? { get set }

    func updateUserInfor(account: Account)
}

protocol ProfileViewControllable: ViewControllable {
}

final class ProfileRouter: ViewableRouter<ProfileInteractable, ProfileViewControllable> {

    private var detailsRouter: DetailsRouting?
    private var detailsBuilder: DetailsBuildable

    private var dataStatisticRouter: DataStatisticRouting?
    private var dataStatisticBuilder: DataStatisticBuildable

    init(interactor: ProfileInteractable,
         viewController: ProfileViewControllable,
         detailsBuilder: DetailsBuildable,
         dataStatisticBuilder: DataStatisticBuildable) {
        self.detailsBuilder = detailsBuilder
        self.dataStatisticBuilder = dataStatisticBuilder
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

    func updateUserInfor(account: Account) {
        self.interactor.updateUserInfor(account: account)
    }

    func routeToDataStatistic() {
        guard self.dataStatisticRouter == nil else {
            return
        }

        let router = self.dataStatisticBuilder.build(withListener: self.interactor)
        self.viewControllable.push(viewControllable: router.viewControllable, animated: true)
        self.attachChild(router)
        self.dataStatisticRouter = router
    }

    func dismissDataStatistic() {
        guard let router = self.dataStatisticRouter else {
            return
        }

        self.viewControllable.popToBefore(viewControllable: router.viewControllable)
        self.detachChild(router)
        self.dataStatisticRouter = nil
    }
}
