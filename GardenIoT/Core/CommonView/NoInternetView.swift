//
//  NoInternetView.swift
//  commonUI
//
//  Created by đào sơn on 09/09/2022.
//

import UIKit

final class NoInternetView: UIView {
    var retryAction: (() -> Void)?
    private static var shared = NoInternetView()
    private var imageView: UIImageView!
    private var backgroundView: UIView!
    private var containerView: UIView!
    private var retryButton: TapableView!
    private var okButton: TapableView!
    private var titleLabel: UILabel!
    private var messageLabel: UILabel!
    private var retryLabel: UILabel!
    private var okLabel: UILabel!

    // MARK: - Init
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.commonInit()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInit()
    }

    // MARK: - Override
    override func layoutSubviews() {
        super.layoutSubviews()
        self.retryButton.layoutIfNeeded()
        self.okButton.layoutIfNeeded()
        self.retryButton.cornerRadius = 20.0
        self.okButton.cornerRadius = 20.0
    }

    // MARK: - Common init
    private func commonInit() {
        self.cornerRadius = 24.0
        self.config()
        self.addContentView()
        self.setUpConstraints()
    }

    // MARK: - Config
    private func config() {
        self.configBackgroundView()
        configContainerView()
        configImageView()
        configTitleLabel()
        configMessageLabel()
        configRetryButton()
        configOkButton()
    }

    private func configBackgroundView() {
        self.backgroundView = UIView()
        self.backgroundView.backgroundColor = .black
        self.backgroundView.alpha = 0.5
    }

    private func configContainerView() {
        self.containerView = UIView()
        self.containerView.backgroundColor = .white
        self.containerView.cornerRadius = 12.0
        self.containerView.translatesAutoresizingMaskIntoConstraints = false
    }

    private func configImageView() {
        self.imageView = UIImageView()
        self.imageView.image = UIImage(named: "ic_no_internet")
        self.imageView.translatesAutoresizingMaskIntoConstraints = false
    }

    private func configTitleLabel() {
        self.titleLabel = UILabel()
        self.titleLabel.text = "God bless you"
        self.titleLabel.numberOfLines = 0
        self.titleLabel.font = Outfit.semiBoldFont(size: 20)
        self.titleLabel.textColor = UIColor(rgb: 0x212121)
        self.titleLabel.textAlignment = .center
        self.titleLabel.translatesAutoresizingMaskIntoConstraints = false
    }

    private func configMessageLabel() {
        self.messageLabel = UILabel()
        self.messageLabel.text = "No Internet connection. Please check your Internet connection and try again."
        self.messageLabel.numberOfLines = 2
        self.messageLabel.font = Outfit.regularFont(size: 14)
        self.messageLabel.textColor = UIColor(rgb: 0x666666)
        self.messageLabel.textAlignment = .center
        self.messageLabel.translatesAutoresizingMaskIntoConstraints = false
    }

    private func configRetryButton() {
        self.retryButton = TapableView()
        self.retryButton.backgroundColor = UIColor(rgb: 0x2D83FF)
        self.retryButton.translatesAutoresizingMaskIntoConstraints = false
        self.retryButton.addTarget(self, action: #selector(retryButtonDidTap), for: .touchUpInside)

        self.retryLabel = UILabel()
        self.retryLabel.textColor = .white
        self.retryLabel.text = "Try Again"
        self.retryLabel.font = Outfit.mediumFont(size: 16)
        self.retryLabel.textAlignment = .center
        self.retryLabel.translatesAutoresizingMaskIntoConstraints = false
    }

    private func configOkButton() {
        self.okButton = TapableView()
        self.okButton.backgroundColor = UIColor(rgb: 0xFFB623)
        self.okButton.translatesAutoresizingMaskIntoConstraints = false
        self.okButton.addTarget(self, action: #selector(okButtonDidTap), for: .touchUpInside)

        self.okLabel = UILabel()
        self.okLabel.textColor = .black
        self.okLabel.text = "OK"
        self.okLabel.font = Outfit.mediumFont(size: 16)
        self.okLabel.textAlignment = .center
        self.okLabel.translatesAutoresizingMaskIntoConstraints = false
    }

    private func addContentView() {
        self.addSubview(self.backgroundView)
        self.addSubview(self.containerView)
        self.containerView.addSubview(imageView)
        self.containerView.addSubview(titleLabel)
        self.containerView.addSubview(messageLabel)
        self.containerView.addSubview(self.retryButton)
        self.containerView.addSubview(self.okButton)
        self.retryButton.addSubview(retryLabel)
        self.okButton.addSubview(okLabel)
    }

    private func setUpConstraints() {
        self.backgroundView.fitSuperviewConstraint()
        self.retryLabel.fitSuperviewConstraint()
        self.okLabel.fitSuperviewConstraint()
        NSLayoutConstraint.activate([
            self.imageView.topAnchor.constraint(equalTo: self.containerView.topAnchor, constant: 21),
            self.imageView.widthAnchor.constraint(equalTo: self.imageView.heightAnchor),
            self.imageView.widthAnchor.constraint(equalToConstant: 56),
            self.imageView.centerXAnchor.constraint(equalTo: self.containerView.centerXAnchor),

            self.titleLabel.topAnchor.constraint(equalTo: self.imageView.bottomAnchor, constant: 18),
            self.titleLabel.centerXAnchor.constraint(equalTo: self.containerView.centerXAnchor),

            self.messageLabel.topAnchor.constraint(equalTo: self.titleLabel.bottomAnchor, constant: 8.0),
            self.messageLabel.leftAnchor.constraint(equalTo: self.containerView.leftAnchor, constant: 18),
            self.messageLabel.rightAnchor.constraint(equalTo: self.containerView.rightAnchor, constant: -18),

            self.retryButton.topAnchor.constraint(equalTo: self.messageLabel.bottomAnchor, constant: 21),
            self.retryButton.bottomAnchor.constraint(equalTo: self.containerView.bottomAnchor, constant: -30),
            self.retryButton.leadingAnchor.constraint(equalTo: self.containerView.leadingAnchor, constant: 33),
            self.retryButton.widthAnchor.constraint(equalToConstant: 100.0),
            self.retryButton.heightAnchor.constraint(equalToConstant: 40.0),

            self.okButton.bottomAnchor.constraint(equalTo: self.containerView.bottomAnchor, constant: -30),
            self.okButton.trailingAnchor.constraint(equalTo: self.containerView.trailingAnchor, constant: -33),
            self.okButton.widthAnchor.constraint(equalToConstant: 100.0),
            self.okButton.heightAnchor.constraint(equalToConstant: 40.0),

            self.containerView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 40),
            self.containerView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -40),
            self.containerView.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ])
    }

    // MARK: - Action
    @objc private func retryButtonDidTap() {
        self.dismiss(animated: self.retryAction == nil)
        self.retryAction?()
    }

    @objc private func okButtonDidTap() {
        self.dismiss()
    }

    // MARK: - Static function
    static func show(retryAction: (() -> Void)? = nil) {
        guard let window = UIApplication.shared.windows.first(where: { $0.isKeyWindow }), shared.superview == nil else {
            return
        }

        shared.alpha = 0
        shared.retryAction = retryAction
        window.addSubview(shared)
        shared.fitSuperviewConstraint()
        UIView.animate(withDuration: 0.25) {
            shared.alpha = 1
        }
    }

    // MARK: - Helper
    private func dismiss(animated: Bool = true) {
        guard self.superview != nil else {
            return
        }

        if !animated {
            self.removeFromSuperview()
            return
        }

        UIView.animate(withDuration: 0.25) {
            self.alpha = 0
        } completion: { _ in
            self.removeFromSuperview()
        }
    }
}
