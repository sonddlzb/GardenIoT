//
//  GardenDetailsViewController.swift
//  GardenIoT
//
//  Created by đào sơn on 29/11/2022.
//

import RIBs
import RxSwift
import UIKit

protocol GardenDetailsPresentableListener: AnyObject {
    func didTapBackButton()
}

final class GardenDetailsViewController: UIViewController, GardenDetailsViewControllable {
    // MARK: - Outlets
    @IBOutlet private weak var celciusTemparatureLabel: UILabel!
    @IBOutlet private weak var deviceLabel: UILabel!
    @IBOutlet private weak var fahrenheitTemparatureLabel: UILabel!
    @IBOutlet private weak var moistureLabel: UILabel!

    // MARK: - Variables
    weak var listener: GardenDetailsPresentableListener?

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.config()
    }

    // MARK: - Config
    private func config() {
        self.configUI()
    }

    private func configUI() {
        let backgroundGradientLayer = CAGradientLayer()
        backgroundGradientLayer.frame = self.view.frame
        backgroundGradientLayer.colors = [UIColor(rgb: 0xEAA9A9).cgColor, UIColor.black.cgColor]
        self.view.layer.insertSublayer(backgroundGradientLayer, at: 0)
    }

    // MARK: - Actions
    @IBAction func backButtonDidTap(_ sender: TapableView) {
        self.listener?.didTapBackButton()
    }
}

extension GardenDetailsViewController: GardenDetailsPresentable {
    func bind(viewModel: GardenDetailsViewModel) {
        self.loadViewIfNeeded()
        self.celciusTemparatureLabel.text = "\(viewModel.celciusTemparatureValue())°C"
        self.fahrenheitTemparatureLabel.text = "\(viewModel.fahrenheitTemparatureValue())°F"
        self.moistureLabel.text = "\(viewModel.moisture)%"
    }
}
