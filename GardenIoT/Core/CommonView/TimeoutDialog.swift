//
//  TimeoutDialog.swift
//  ColoringByPixel
//
//  Created by đào sơn on 12/09/2022.
//

import UIKit

final class TimeoutDialog: UIView {

    static var shared = TimeoutDialog()

    private var imageView: UIImageView!
    private var containerView: UIView!
    private var confirmButton: TapableView!
    private var titleLabel: UILabel!
    private var messageLabel: UILabel!
    private var confirmLabel: UILabel!

    // MARK: - Init
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.config()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.config()
    }

    // MARK: - Config
    private func config() {
        self.cornerRadius = 24.0
        self.backgroundColor = UIColor(rgb: 0x0B0D0F, alpha: 0.5)
        self.configContainerView()
        self.configImageView()
        self.configTitleLabel()
        self.configMessageLabel()
        self.configConfirmButton()
        self.addContentView()
        self.setUpConstraints()
    }

    private func configContainerView() {
        self.containerView = UIView()
        self.containerView.backgroundColor = .white
        self.containerView.cornerRadius = 12.0
        self.containerView.translatesAutoresizingMaskIntoConstraints = false
    }

    private func configImageView() {
        self.imageView = UIImageView()
        self.imageView.image = UIImage(named: "ic_wrong")
        self.imageView.translatesAutoresizingMaskIntoConstraints = false
    }

    private func configTitleLabel() {
        self.titleLabel = UILabel()
        self.titleLabel.text = "Error"
        self.titleLabel.numberOfLines = 0
        self.titleLabel.font = Outfit.semiBoldFont(size: 20)
        self.titleLabel.textColor = UIColor(rgb: 0x212121)
        self.titleLabel.textAlignment = .center
        self.titleLabel.translatesAutoresizingMaskIntoConstraints = false
    }

    private func configMessageLabel() {
        self.messageLabel = UILabel()
        self.messageLabel.text = "Something went wrong, please try again later"
        self.messageLabel.numberOfLines = 2
        self.messageLabel.font = Outfit.regularFont(size: 14)
        self.messageLabel.textColor = UIColor(rgb: 0x666666)
        self.messageLabel.textAlignment = .center
        self.messageLabel.translatesAutoresizingMaskIntoConstraints = false
    }

    private func configConfirmButton() {
        self.confirmButton = TapableView()
        self.confirmButton.backgroundColor = UIColor(rgb: 0xFFB623)
        self.confirmButton.translatesAutoresizingMaskIntoConstraints = false
        self.confirmButton.cornerRadius = 20.0
        self.confirmButton.addTarget(self, action: #selector(confirmButtonDidTap), for: .touchUpInside)

        self.confirmLabel = UILabel()
        self.confirmLabel.textColor = UIColor(rgb: 0x212121)
        self.confirmLabel.text = "Confirm"
        self.confirmLabel.font = Outfit.mediumFont(size: 16)
        self.confirmLabel.textAlignment = .center
        self.confirmLabel.translatesAutoresizingMaskIntoConstraints = false
    }

    private func addContentView() {
        self.addSubview(self.containerView)
        self.containerView.addSubview(imageView)
        self.containerView.addSubview(titleLabel)
        self.containerView.addSubview(messageLabel)
        self.containerView.addSubview(self.confirmButton)
        self.confirmButton.addSubview(confirmLabel)
    }

    private func setUpConstraints() {
        self.confirmLabel.fitSuperviewConstraint()

        NSLayoutConstraint.activate([

            containerView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 40),
            containerView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -40),
            containerView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            containerView.heightAnchor.constraint(equalToConstant: 250.0),

            self.imageView.topAnchor.constraint(equalTo: self.containerView.topAnchor, constant: 24),
            self.imageView.widthAnchor.constraint(equalTo: self.imageView.heightAnchor),
            self.imageView.widthAnchor.constraint(equalToConstant: 56),
            self.imageView.centerXAnchor.constraint(equalTo: self.containerView.centerXAnchor),

            self.titleLabel.topAnchor.constraint(equalTo: self.imageView.bottomAnchor, constant: 15),
            self.titleLabel.centerXAnchor.constraint(equalTo: self.containerView.centerXAnchor),

            self.messageLabel.topAnchor.constraint(equalTo: self.titleLabel.bottomAnchor, constant: 8.0),
            self.messageLabel.leftAnchor.constraint(equalTo: self.containerView.leftAnchor, constant: 18),
            self.messageLabel.rightAnchor.constraint(equalTo: self.containerView.rightAnchor, constant: -18),

            self.confirmButton.topAnchor.constraint(equalTo: self.messageLabel.bottomAnchor, constant: 21.0),
            self.confirmButton.centerXAnchor.constraint(equalTo: self.containerView.centerXAnchor),
            self.confirmButton.widthAnchor.constraint(equalToConstant: 106.0),
            self.confirmButton.heightAnchor.constraint(equalToConstant: 40.0)
        ])
    }

    @objc private func confirmButtonDidTap() {
        self.dismiss()
    }

    // MARK: - Helper
    private func dismiss() {
        guard self.superview != nil else {
            return
        }

        UIView.animate(withDuration: 0.15) {
            self.alpha = 0
        } completion: { _ in
            self.removeFromSuperview()
        }
    }

    // MARK: - Static function
    static func show() {
        guard let window = UIApplication.shared.windows.first(where: { $0.isKeyWindow }),
              shared.superview == nil else {
            return
        }

        shared.alpha = 0
        window.addSubview(shared)
        shared.fitSuperviewConstraint()

        UIView.animate(withDuration: 0.15) {
            shared.alpha = 1
        }
    }

    static func dismiss() {
        shared.dismiss()
    }

    // MARK: - Touches
    public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        self.dismiss()
    }
}
