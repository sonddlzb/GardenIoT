//
//  LoginViewController.swift
//  GardenIoT
//
//  Created by đào sơn on 05/11/2022.
//

import RIBs
import RxSwift
import UIKit

protocol LoginPresentableListener: AnyObject {
    func didTapSignUp()
    func didTapSignIn()
    func didEndEditTextField(username: String, password: String)
}

final class LoginViewController: UIViewController, LoginViewControllable {
    // MARK: - Outlets
    @IBOutlet private weak var usernameTextField: SolarTextField!
    @IBOutlet private weak var passwordTextField: PasswordTextField!
    @IBOutlet private weak var loginButton: TapableView!
    @IBOutlet weak var emptyLabel: UILabel!

    // MARK: - Variables
    weak var listener: LoginPresentableListener?
    private var didTapSignInButtonBefore = false

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.config()
    }

    // MARK: - Config
    private func config() {
        self.configUsernameTextField()
        self.configPasswordTextField()
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

    // MARK: - Action
    @IBAction func signUpButtonDidTap(_ sender: Any) {
        self.listener?.didTapSignUp()
    }

    @IBAction func signInButtonDidTap(_ sender: Any) {
        self.listener?.didTapSignIn()
        self.didTapSignInButtonBefore = true
    }

    @objc func textFieldDidChange() {
        self.listener?.didEndEditTextField(username: self.usernameTextField.text,
                                           password: self.passwordTextField.text)
    }
}

// MARK: - SolarTextFieldDelegate
extension LoginViewController: SolarTextFieldDelegate {
    func solarTextField(_ textField: SolarTextField, willChangeToText text: String) -> Bool {
        return true
    }

    func solarTextField(addTextFieldChangedValueObserverTo textField: PaddingTextField) {
        textField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
    }
}

extension LoginViewController {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}

// MARK: - LoginPresentable
extension LoginViewController: LoginPresentable {
    func bind(viewModel: LoginViewModel) {
        self.loadViewIfNeeded()
        if self.didTapSignInButtonBefore {
            self.emptyLabel.isHidden = !viewModel.checkEmpty()
        }
    }
}
