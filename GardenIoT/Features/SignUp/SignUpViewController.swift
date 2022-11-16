//
//  SignUpViewController.swift
//  GardenIoT
//
//  Created by đào sơn on 05/11/2022.
//

import RIBs
import RxSwift
import UIKit

protocol SignUpPresentableListener: AnyObject {
    func didTapCancelButton()
}

final class SignUpViewController: UIViewController, SignUpPresentable, SignUpViewControllable {
    // MARK: - Outlets
    @IBOutlet private weak var cancelButton: TapableView!
    @IBOutlet private weak var nameTextField: SolarTextField!
    @IBOutlet private weak var phoneNumberTextField: SolarTextField!
    @IBOutlet private weak var addressTextField: SolarTextField!
    @IBOutlet private weak var usernameTextField: SolarTextField!
    @IBOutlet private weak var passwordTextField: PasswordTextField!
    @IBOutlet private weak var confirmPasswordTextField: PasswordTextField!

    weak var listener: SignUpPresentableListener?
    var viewModel: LoginViewModel!

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.config()
    }

    // MARK: - Config
    private func config() {
        configNameTextField()
        configAddressTextField()
        configPhoneNumberTextField()
        configUsernameTextField()
        configPasswordTextField()
        configConfirmPasswordTextField()
    }

    private func configPhoneNumberTextField() {
        self.phoneNumberTextField.isHighlightedWhenEditting = true
        self.phoneNumberTextField.backgroundColor = UIColor(rgb: 0xF7F7F7)
        self.phoneNumberTextField.borderColor = UIColor(rgb: 0x575FCC)
        self.phoneNumberTextField.placeholder = "Phone Number"
        self.phoneNumberTextField.paddingLeft = 10
        self.phoneNumberTextField.delegate = self
    }

    private func configNameTextField() {
        self.nameTextField.isHighlightedWhenEditting = true
        self.nameTextField.backgroundColor = UIColor(rgb: 0xF7F7F7)
        self.nameTextField.borderColor = UIColor(rgb: 0x575FCC)
        self.nameTextField.placeholder = "Name"
        self.nameTextField.paddingLeft = 10
        self.nameTextField.delegate = self
    }

    private func configAddressTextField() {
        self.addressTextField.isHighlightedWhenEditting = true
        self.addressTextField.backgroundColor = UIColor(rgb: 0xF7F7F7)
        self.addressTextField.borderColor = UIColor(rgb: 0x575FCC)
        self.addressTextField.placeholder = "Ađdress"
        self.addressTextField.paddingLeft = 10
        self.addressTextField.delegate = self
    }

    private func configUsernameTextField() {
        self.usernameTextField.isHighlightedWhenEditting = true
        self.usernameTextField.backgroundColor = UIColor(rgb: 0xF7F7F7)
        self.usernameTextField.borderColor = UIColor(rgb: 0x575FCC)
        self.usernameTextField.placeholder = "Username"
        self.usernameTextField.paddingLeft = 10
        self.usernameTextField.delegate = self
    }

    private func configPasswordTextField() {
        self.passwordTextField.isHighlightedWhenEditting = true
        self.passwordTextField.backgroundColor = UIColor(rgb: 0xF7F7F7)
        self.passwordTextField.borderColor = UIColor(rgb: 0x575FCC)
        self.passwordTextField.placeholder = "Password"
        self.passwordTextField.paddingLeft = 10
        self.passwordTextField.delegate = self
    }

    private func configConfirmPasswordTextField() {
        self.confirmPasswordTextField.isHighlightedWhenEditting = true
        self.confirmPasswordTextField.backgroundColor = UIColor(rgb: 0xF7F7F7)
        self.confirmPasswordTextField.borderColor = UIColor(rgb: 0x575FCC)
        self.confirmPasswordTextField.placeholder = "Password"
        self.confirmPasswordTextField.paddingLeft = 10
        self.confirmPasswordTextField.delegate = self
    }

    // MARK: - Action
    @IBAction func cancelButtonDidTap(_ sender: Any) {
        self.listener?.didTapCancelButton()
    }
}

// MARK: - SolarTextFieldDelegate
extension SignUpViewController: SolarTextFieldDelegate {
    func solarTextField(_ textField: SolarTextField, willChangeToText text: String) -> Bool {
        return true
    }
}

extension SignUpViewController {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}
