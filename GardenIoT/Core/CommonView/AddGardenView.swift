//
//  ConfirmDialog.swift
//  PrankSounds
//
//  Created by Dao Dang Son on 26/11/2022.
//

import UIKit

class AddGardenView: UIView {
    static var shared = AddGardenView.loadView()

    // MARK: - Outlets
    @IBOutlet private weak var nameTextField: SolarTextField!
    @IBOutlet private weak var addressTextField: SolarTextField!

    // MARK: - Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        self.config()
    }

    private func config() {
        configNameTextField()
        configAddressTextField()
    }

    private func configNameTextField() {

    }

    private func configAddressTextField() {

    }

    // MARK: - Action
    @IBAction func confirmButtonDidTap(_ sender: Any) {
        self.dismiss()
    }

    @IBAction func cancelButtonDidTap(_ sender: Any) {
        self.dismiss()
    }

    // MARK: - Helper
    private func dismiss() {
        guard self.superview != nil else {
            return
        }

        UIView.animate(withDuration: 0.25) {
            self.alpha = 0
        } completion: { _ in
            self.removeFromSuperview()
        }
    }

    private func show(superview: UIView) {
        self.alpha = 0
        superview.addSubview(self)
        self.fitSuperviewConstraint()

        UIView.animate(withDuration: 0.25) {
            self.alpha = 1
        }
    }

    // MARK: - Static function
    static func show() {
        guard let window = UIApplication.shared.windows.first(where: { $0.isKeyWindow }),
              shared.superview == nil else {
            return
        }

        shared.show(superview: window)
    }

    static func dismiss() {
        shared.dismiss()
    }

    static func loadView() -> AddGardenView {
        return AddGardenView.loadView(fromNib: "AddGardenView")!
    }
}
