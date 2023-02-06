//
//  HomeViewController.swift
//  GardenIoT
//
//  Created by đào sơn on 06/11/2022.
//

import RIBs
import RxSwift
import UIKit
import NotificationBannerSwift

protocol HomePresentableListener: AnyObject {
    func didSelectAt(tab: HomeTab)
    func didTapToOpenGardenDetail(at garden: Garden)
}

final class HomeViewController: UIViewController {
    // MARK: - Outlet
    @IBOutlet private weak var contentView: UIView!
    @IBOutlet private weak var homeTabBar: HomeTabBar!

    weak var listener: HomePresentableListener?
    private var currentViewController: ViewControllable?

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.config()
    }

    // MARK: - Config
    private func config() {
        self.configHomeTabBar()
    }

    private func configHomeTabBar() {
        self.homeTabBar.delegate = self
    }
}

// MARK: - HomeTabBarDelegate
extension HomeViewController: HomeTabBarDelegate {
    func homeTabBar(_ homeTabBar: HomeTabBar, didSelect homeTab: HomeTab) {
        self.listener?.didSelectAt(tab: homeTab)
    }
}

// MARK: - HomeViewControllable
extension HomeViewController: HomeViewControllable {
    func highlightOnTabBar(tab: HomeTab) {
        if self.homeTabBar != nil {
            self.homeTabBar.setSelectedTab(tab)
        }
    }

    func embedViewController(_ viewController: ViewControllable) {
        self.loadViewIfNeeded()

        self.currentViewController?.uiviewController.view.removeFromSuperview()
        self.currentViewController?.uiviewController.removeFromParent()

        self.contentView.addSubview(viewController.uiviewController.view)
        viewController.uiviewController.view.fitSuperviewConstraint()

        self.addChild(viewController.uiviewController)
        self.currentViewController = viewController
    }
}

// MARK: - HomePresentable
extension HomeViewController: HomePresentable {
    func showNotification(title: String, subtitle: String, warningType: WarningType, garden: Garden) {
        let banner = GrowingNotificationBanner(title: title, subtitle: subtitle, style: warningType == .dead ? BannerStyle.danger : BannerStyle.warning)
        banner.show()
        banner.onTap = {
            self.listener?.didTapToOpenGardenDetail(at: garden)
        }
    }
}
