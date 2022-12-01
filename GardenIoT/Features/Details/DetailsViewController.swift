//
//  DetailsViewController.swift
//  GardenIoT
//
//  Created by đào sơn on 22/11/2022.
//

import RIBs
import RxSwift
import UIKit

protocol DetailsPresentableListener: AnyObject {
    func didEndEditTextField(name: String, address: String, phoneNumber: String)
    func didFinishUpdateAccount(isSaved: Bool)
    func didTapCancelToExit()
}

final class DetailsViewController: BaseViewControler, DetailsViewControllable {
    // MARK: - Outlets
    @IBOutlet private weak var editButton: TapableView!
    @IBOutlet private weak var cancelButton: UILabel!
    @IBOutlet private weak var nameTextField: SolarTextField!
    @IBOutlet private weak var addressTextField: SolarTextField!
    @IBOutlet private weak var phoneTextField: SolarTextField!
    @IBOutlet private weak var editLabel: UILabel!

    // MARK: - Variables
    weak var listener: DetailsPresentableListener?
    private var isOnEditMode = false {
        didSet {
            self.nameTextField.isUserInteractionEnabled = isOnEditMode
            self.phoneTextField.isUserInteractionEnabled = isOnEditMode
            self.addressTextField.isUserInteractionEnabled = isOnEditMode
        }
    }

    private var viewModel = DetailsViewModel.makeEmpty()

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.config()
    }

    // MARK: - Config
    private func config() {
        self.configUI()
        self.configNameTextField()
        self.configAddressTextField()
        self.configPhoneTextField()
    }

    private func configUI() {
    }

    private func configNameTextField() {
        self.nameTextField.isHighlightedWhenEditting = true
        self.nameTextField.backgroundColor = UIColor(rgb: 0xF7F7F7)
        self.nameTextField.borderColor = UIColor(rgb: 0x575FCC)
        self.nameTextField.placeholder = "Name"
        self.nameTextField.paddingLeft = 10
        self.nameTextField.text = self.viewModel.account.name
        self.nameTextField.isUserInteractionEnabled = false
        self.nameTextField.delegate = self
    }

    private func configAddressTextField() {
        self.addressTextField.isHighlightedWhenEditting = true
        self.addressTextField.backgroundColor = UIColor(rgb: 0xF7F7F7)
        self.addressTextField.borderColor = UIColor(rgb: 0x575FCC)
        self.addressTextField.placeholder = "Ađdress"
        self.addressTextField.paddingLeft = 10
        self.addressTextField.text = self.viewModel.account.address
        self.addressTextField.isUserInteractionEnabled = false
        self.addressTextField.delegate = self
    }

    private func configPhoneTextField() {
        self.phoneTextField.isHighlightedWhenEditting = true
        self.phoneTextField.backgroundColor = UIColor(rgb: 0xF7F7F7)
        self.phoneTextField.borderColor = UIColor(rgb: 0x575FCC)
        self.phoneTextField.placeholder = "Phone Number"
        self.phoneTextField.paddingLeft = 10
        self.phoneTextField.text = self.viewModel.account.phoneNumber
        self.phoneTextField.isUserInteractionEnabled = false
        self.phoneTextField.delegate = self
    }

    // MARK: - Action
    @IBAction func editButtonDidTap(_ sender: TapableView) {
        if isOnEditMode {
            editLabel.text = "Edit"
            self.listener?.didFinishUpdateAccount(isSaved: true)
        } else {
            editLabel.text = "Save"
            nameTextField.becomeFirstResponder()
        }

        self.isOnEditMode = !self.isOnEditMode
    }

    @IBAction func cancelButtonDidTap(_ sender: TapableView) {
        if isOnEditMode {
            self.isOnEditMode = !self.isOnEditMode
        } else {
            self.listener?.didTapCancelToExit()
        }
    }

    @objc func textFieldDidChange() {
        self.listener?.didEndEditTextField(name: nameTextField.text, address: addressTextField.text, phoneNumber: phoneTextField.text)
    }
}

extension DetailsViewController {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}

// MARK: - SolarTextFieldDelegate
extension DetailsViewController: SolarTextFieldDelegate {
    func solarTextField(_ textField: SolarTextField, willChangeToText text: String) -> Bool {
        return true
    }

    func solarTextField(addTextFieldChangedValueObserverTo textField: PaddingTextField) {
        textField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
    }
}

// MARK: - DetailsPresentable
extension DetailsViewController: DetailsPresentable {
    func didUpdateAccount(isSuccess: Bool, message: String) {
        let alertViewController = UIAlertController(title: "Update information", message: isSuccess ? "Your information was updated successfully!" : "Something went wrong. Try again!", preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "Ok", style: .cancel)
        alertViewController.addAction(alertAction)
        self.present(alertViewController, animated: true)
    }

    func bind(viewModel: DetailsViewModel) {
        self.loadViewIfNeeded()
        self.viewModel = viewModel
        if self.isOnEditMode {
            self.editButton.isEnabled = self.viewModel.isSaveEnable()
            self.editLabel.textColor = self.viewModel.isSaveEnable() ? UIColor(rgb: 0x3B00FF) : UIColor(rgb: 0xDDDDDD)
        }

        self.nameTextField.text = self.viewModel.account.name
        self.addressTextField.text = self.viewModel.account.address
        self.phoneTextField.text = self.viewModel.account.phoneNumber
    }
}
