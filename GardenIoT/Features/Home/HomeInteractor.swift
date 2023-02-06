//
//  HomeInteractor.swift
//  GardenIoT
//
//  Created by đào sơn on 06/11/2022.
//

import RIBs
import RxSwift
import SVProgressHUD

protocol HomeRouting: ViewableRouting {
    func routeToTab(_ tab: HomeTab)
    func didFinishGetUserInfor(account: Account)
    func routeDirectlyToGardenDetail(at garden: Garden)
}

protocol HomePresentable: Presentable {
    var listener: HomePresentableListener? { get set }

    func showNotification(title: String, subtitle: String, warningType: WarningType, garden: Garden)
}

protocol HomeListener: AnyObject {
    func homeWantToSignOut()
}

final class HomeInteractor: PresentableInteractor<HomePresentable>, HomeInteractable {

    weak var router: HomeRouting?
    weak var listener: HomeListener?
    @DIInjected var networkService: NetworkService
    private var mqttHelper: MQTTHelper!

    override init(presenter: HomePresentable) {
        super.init(presenter: presenter)
        presenter.listener = self
    }

    override func didBecomeActive() {
        super.didBecomeActive()
        self.router?.routeToTab(.home)
        self.getUserInfor()
        print(AuthorizationHelper.shared.getToken())
    }

    override func willResignActive() {
        super.willResignActive()
    }

    func getUserInfor() {
        SVProgressHUD.show()
        if let accessToken = AuthorizationHelper.shared.getToken() {
            networkService.getUserInfor(accessToken: accessToken).subscribe(onNext: { account in
                print("user id is \(account.id)")
                self.subcribeForNotification(userId: account.id)
                self.router?.didFinishGetUserInfor(account: account)
                SVProgressHUD.dismiss()
            }, onError: { error in
                print("Failed to get user infor with error \(error)")
                SVProgressHUD.dismiss()
            }).disposeOnDeactivate(interactor: self)
        }
    }

    func getGardenById(gardenId: String, completion: @escaping (Garden?) -> Void) {
        if let accessToken = AuthorizationHelper.shared.getToken() {
            self.networkService.getGardenById(accessToken: accessToken, gardenId: gardenId).subscribe(onNext: { garden in
                completion(garden)
            }, onError: { error in
                completion(nil)
            }).disposeOnDeactivate(interactor: self)
        }
    }

    func subcribeForNotification(userId: String) {
        self.mqttHelper = MQTTHelper(userId: userId)
        self.mqttHelper.delegate = self
    }
}

// MARK: - HomePresentableListener
extension HomeInteractor: HomePresentableListener {
    func didSelectAt(tab: HomeTab) {
        self.router?.routeToTab(tab)
    }

    func didTapToOpenGardenDetail(at garden: Garden) {
        self.router?.routeDirectlyToGardenDetail(at: garden)
    }
}

// MARK: - MQTTHelperDelegate
extension HomeInteractor: MQTTHelperDelegate {
    func mqttHelperDidReceive(_ mqttHelper: MQTTHelper, measureResult: MeasureResult) {
    }

    func mqttHelperDidReceive(_ mqttHelper: MQTTHelper, notificationMessage: NotificationMessage) {
        self.getGardenById(gardenId: notificationMessage.gardenId, completion: { garden in
            guard let garden = garden else {
                return
            }

            let subtitle = notificationMessage.warningType == .dead ? "Environment condition in garden \(garden.name) is over control. Tap here for details" : "Environment condition in garden \(garden.name) is becoming worse. Activate your device now"
            let title = notificationMessage.warningType == .dead ? "Oh no!" : "Be careful!"

            self.presenter.showNotification(title: title, subtitle: subtitle, warningType: notificationMessage.warningType, garden: garden)
        })
    }
}
