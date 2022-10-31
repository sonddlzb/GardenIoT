//
//  NoInternetEmbedView.swift
//  ColoringByPixel
//
//  Created by đào sơn on 12/09/2022.
//

import UIKit

final class NoInternetEmbedView: UIView {
    var retryAction: (() -> Void)?

    private var imageView: UIImageView!
    private var containerView: UIView!
    private var retryButton: TapableView!
    private var titleLabel: UILabel!
    private var messageLabel: UILabel!
    private var retryLabel: UILabel!

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
        self.retryButton.cornerRadius = 20.0
    }

    // MARK: - Common init
    private func commonInit() {
        config()
        addContentView()
        setUpConstraints()
    }

    // MARK: - Config
    private func config() {
        configContainerView()
        configImageView()
        configTitleLabel()
        configMessageLabel()
        configRetryButton()
    }

    private func configRetryButton() {
        self.retryButton = TapableView()
        self.retryButton.backgroundColor = UIColor(rgb: 0x2D83FF)
        self.retryButton.translatesAutoresizingMaskIntoConstraints = false
        self.retryButton.addTarget(self, action: #selector(retryButtonDidTap), for: .touchUpInside)

        self.retryLabel = UILabel()
        self.retryLabel.textColor = .white
        self.retryLabel.text = "Try Again"
        self.retryLabel.font = Outfit.semiBoldFont(size: 16)
        self.retryLabel.textAlignment = .center
        self.retryLabel.textColor = .white
        self.retryLabel.translatesAutoresizingMaskIntoConstraints = false
    }

    private func configMessageLabel() {
        self.messageLabel = UILabel()
        self.messageLabel.text = "Please check your Internet connection and try again."
        self.messageLabel.numberOfLines = 2
        self.messageLabel.font = Outfit.regularFont(size: 14)
        self.messageLabel.textColor = UIColor(rgb: 0x666666)
        self.messageLabel.textAlignment = .center
        self.messageLabel.translatesAutoresizingMaskIntoConstraints = false
    }

    private func configTitleLabel() {
        self.titleLabel = UILabel()
        self.titleLabel.text = "God bless you!"
        self.titleLabel.numberOfLines = 0
        self.titleLabel.font = Outfit.semiBoldFont(size: 16)
        self.titleLabel.textColor = UIColor(rgb: 0x666666)
        self.titleLabel.textAlignment = .center
        self.titleLabel.translatesAutoresizingMaskIntoConstraints = false
    }

    private func configImageView() {
        self.imageView = UIImageView()
        self.imageView.image = UIImage(named: "ic_no_internet_black")
        self.imageView.translatesAutoresizingMaskIntoConstraints = false
    }

    private func configContainerView() {
        self.containerView = UIView()
        self.containerView.backgroundColor = UIColor(rgb: 0xFFF9F0)
        self.containerView.translatesAutoresizingMaskIntoConstraints = false
    }

    private func addContentView() {
        self.addSubview(self.containerView)
        self.containerView.addSubview(imageView)
        self.containerView.addSubview(titleLabel)
        self.containerView.addSubview(messageLabel)
        self.containerView.addSubview(self.retryButton)
        self.retryButton.addSubview(retryLabel)
    }

    private func setUpConstraints() {
        self.containerView.fitSuperviewConstraint()
        self.retryLabel.fitSuperviewConstraint()
        NSLayoutConstraint.activate([
            self.imageView.topAnchor.constraint(equalTo: self.containerView.topAnchor, constant: 0),
            self.imageView.widthAnchor.constraint(equalTo: self.imageView.heightAnchor),
            self.imageView.widthAnchor.constraint(equalToConstant: 56),
            self.imageView.centerXAnchor.constraint(equalTo: self.containerView.centerXAnchor),

            self.titleLabel.topAnchor.constraint(equalTo: self.imageView.bottomAnchor, constant: 12),
            self.titleLabel.leftAnchor.constraint(equalTo: self.containerView.leftAnchor, constant: 0),
            self.titleLabel.rightAnchor.constraint(equalTo: self.containerView.rightAnchor, constant: 0),

            self.messageLabel.topAnchor.constraint(equalTo: self.titleLabel.bottomAnchor, constant: 4.0),
            self.messageLabel.leftAnchor.constraint(equalTo: self.containerView.leftAnchor, constant: 0),
            self.messageLabel.rightAnchor.constraint(equalTo: self.containerView.rightAnchor, constant: 0),

            self.retryButton.topAnchor.constraint(equalTo: self.messageLabel.bottomAnchor, constant: 25),
            self.retryButton.centerXAnchor.constraint(equalTo: self.containerView.centerXAnchor),
            self.retryButton.widthAnchor.constraint(equalToConstant: 115.0),
            self.retryButton.heightAnchor.constraint(equalToConstant: 40.0)
        ])
    }

    // MARK: - Action
    @objc private func retryButtonDidTap() {
        self.retryAction?()
    }
}
