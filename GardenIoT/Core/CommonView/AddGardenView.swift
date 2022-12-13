//
//  ConfirmDialog.swift
//  PrankSounds
//
//  Created by Dao Dang Son on 26/11/2022.
//

import UIKit

protocol AddGardenViewDelegate: AnyObject {
    func addGardenViewDidTapConfirm(_ addGardenView: AddGardenView, name: String, address: String)
}

class AddGardenView: UIView {
    static var shared = AddGardenView.loadView()

    // MARK: - Outlets
    @IBOutlet private weak var nameTextField: SolarTextField!
    @IBOutlet private weak var addressTextField: SolarTextField!
    @IBOutlet private weak var confirmButton: TapableView!
    @IBOutlet private weak var backgroundView: UIView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var confirmLabel: UILabel!

    // MARK: - Variables
    private var isGardenInformationValid = false {
        didSet {
            self.confirmButton.isUserInteractionEnabled = isGardenInformationValid
            self.confirmButton.backgroundColor = isGardenInformationValid ? UIColor(rgb: 0xFF6C39) : UIColor(rgb: 0xDDDDDD)
        }
    }

    weak var delegate: AddGardenViewDelegate?
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
        self.nameTextField.isHighlightedWhenEditting = true
        self.nameTextField.backgroundColor = UIColor(rgb: 0xF7F7F7)
        self.nameTextField.borderColor = UIColor(rgb: 0x575FCC)
        self.nameTextField.placeholder = "Name"
        self.nameTextField.paddingLeft = 10
        self.nameTextField.delegate = self
        self.becomeFirstResponder()
    }

    private func configAddressTextField() {
        self.addressTextField.isHighlightedWhenEditting = true
        self.addressTextField.backgroundColor = UIColor(rgb: 0xF7F7F7)
        self.addressTextField.borderColor = UIColor(rgb: 0x575FCC)
        self.addressTextField.placeholder = "Address"
        self.addressTextField.paddingLeft = 10
        self.addressTextField.delegate = self
    }

    // MARK: - Action
    @IBAction func confirmButtonDidTap(_ sender: Any) {
        self.delegate?.addGardenViewDidTapConfirm(self, name: self.nameTextField.text, address: self.addressTextField.text)
        self.dismiss()
    }

    @objc func textFieldDidChange() {
        self.isGardenInformationValid = !(self.nameTextField.text.isEmpty || self.addressTextField.text.isEmpty)
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

    private func show(superview: UIView, garden: Garden?) {
        self.alpha = 0
        superview.addSubview(self)
        if let garden = garden {
            self.titleLabel.text = "Update Garden"
            self.confirmLabel.text = "Update"
            self.nameTextField.text = garden.name
            self.addressTextField.text = garden.address
        }

        self.fitSuperviewConstraint()

        UIView.animate(withDuration: 0.25) {
            self.alpha = 1
        }
    }

    // MARK: - Static function
    static func show(garden: Garden?) {
        guard let window = UIApplication.shared.windows.first(where: { $0.isKeyWindow }),
              shared.superview == nil else {
            return
        }

        shared.show(superview: window, garden: garden)
    }

    static func dismiss() {
        shared.dismiss()
    }

    static func loadView() -> AddGardenView {
        return AddGardenView.loadView(fromNib: "AddGardenView")!
    }
}

// MARK: - SolarTextFieldDelegate
extension AddGardenView: SolarTextFieldDelegate {
    func solarTextField(_ textField: SolarTextField, willChangeToText text: String) -> Bool {
        return true
    }

    func solarTextField(addTextFieldChangedValueObserverTo textField: PaddingTextField) {
        textField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
    }
}

extension AddGardenView {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        if touches.first?.view == self.backgroundView {
            self.dismiss()
        }
    }
}
