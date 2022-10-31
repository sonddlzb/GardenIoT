//
//  SplashViewController.swift
//  GardenIoT
//
//  Created by đào sơn on 04/11/2022.
//

import RIBs
import RxSwift
import UIKit
import SDWebImage

protocol SplashPresentableListener: AnyObject {
}

final class SplashViewController: BaseViewControler, SplashPresentable, SplashViewControllable {
    // MARK: - Outlets
    weak var listener: SplashPresentableListener?
    @IBOutlet private weak var imageView: SDAnimatedImageView!

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.config()
    }

    // MARK: - Config
    private func config() {
        configImageView()
    }

    private func configImageView() {
        self.imageView.isUserInteractionEnabled = false
        let url = Bundle.main.url(forResource: "splash", withExtension: "gif")
        self.imageView.sd_setImage(with: url)
        self.imageView.startAnimating()
    }
}
