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
    func didTapSignUpButton()
    func didEndEditTextField(username: String, password: String, confirmPassword: String, name: String, address: String, phoneNumber: String)
}

final class SignUpViewController: UIViewController, SignUpViewControllable {
    // MARK: - Outlets
    @IBOutlet private weak var cancelButton: TapableView!
    @IBOutlet private weak var nameTextField: SolarTextField!
    @IBOutlet private weak var phoneNumberTextField: SolarTextField!
    @IBOutlet private weak var addressTextField: SolarTextField!
    @IBOutlet private weak var usernameTextField: SolarTextField!
    @IBOutlet private weak var passwordTextField: PasswordTextField!
    @IBOutlet private weak var confirmPasswordTextField: PasswordTextField!
    @IBOutlet private weak var emptyLabel: UILabel!
    @IBOutlet private weak var createAccountTopConstraint: NSLayoutConstraint!
    @IBOutlet private weak var phoneNumberLeadingConstraint: NSLayoutConstraint!
    @IBOutlet private weak var nameLeadingConstraint: NSLayoutConstraint!
    @IBOutlet private weak var addressLeadingConstraint: NSLayoutConstraint!
    @IBOutlet private weak var usernameLeadingConstraint: NSLayoutConstraint!
    @IBOutlet private weak var passwordLeadingConstraint: NSLayoutConstraint!
    @IBOutlet private weak var confirmPasswordLeadingConstraint: NSLayoutConstraint!

    weak var listener: SignUpPresentableListener?
    var viewModel: LoginViewModel!
    var didTapSignUpButtonBefore = false

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.config()
        // Delay 0.1s for better UX
        DispatchQueue.main.asyncAfter(deadline: .now()+0.1, execute: {
            self.animateAppearance()
        })
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
        self.addressTextField.placeholder = "Address"
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
        self.confirmPasswordTextField.placeholder = "Confirm Password"
        self.confirmPasswordTextField.paddingLeft = 10
        self.confirmPasswordTextField.delegate = self
    }

    // MARK: - Animation
    private func animateAppearance() {
        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseInOut, animations: { [weak self] in
            self?.createAccountTopConstraint.constant = 80
            self?.nameLeadingConstraint.constant = 50
            self?.phoneNumberLeadingConstraint.constant = 50
            self?.addressLeadingConstraint.constant = 50
            self?.usernameLeadingConstraint.constant = 50
            self?.passwordLeadingConstraint.constant = 50
            self?.confirmPasswordLeadingConstraint.constant = 50
            self?.view.layoutIfNeeded()
        }, completion: nil)
    }

    // MARK: - Action
    @IBAction func cancelButtonDidTap(_ sender: Any) {
        self.listener?.didTapCancelButton()
    }

    @IBAction func signUpButtonDidTap(_ sender: Any) {
        self.didTapSignUpButtonBefore = true
        self.listener?.didTapSignUpButton()
    }

    @objc func textFieldDidChange() {
        self.listener?.didEndEditTextField(username: self.usernameTextField.text,
                                           password: self.passwordTextField.text,
                                           confirmPassword: self.confirmPasswordTextField.text,
                                           name: self.nameTextField.text,
                                           address: self.addressTextField.text,
                                           phoneNumber: self.phoneNumberTextField.text)
    }
}

// MARK: - SolarTextFieldDelegate
extension SignUpViewController: SolarTextFieldDelegate {
    func solarTextField(_ textField: SolarTextField, willChangeToText text: String) -> Bool {
        return true
    }

    func solarTextField(addTextFieldChangedValueObserverTo textField: PaddingTextField) {
        textField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
    }
}

extension SignUpViewController {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}

// MARK: - SignUpPresentable
extension SignUpViewController: SignUpPresentable {
    func bind(viewModel: SignUpViewModel) {
        self.loadViewIfNeeded()
        if self.didTapSignUpButtonBefore {
            self.emptyLabel.isHidden = !viewModel.isEmpty()
        }
    }
}
