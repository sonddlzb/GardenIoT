//
//  AddDeviceView.swift
//  GardenIoT
//
//  Created by đào sơn on 06/12/2022.
//

import Foundation
import UIKit
import RxSwift
import DropDown

protocol AddDeviceViewDelegate: AnyObject {
    func addDeviceViewDidTapConfirm(_ addDeviceView: AddDeviceView, name: String, description: String, gardenId: String)
}

class AddDeviceView: UIView {
    static var shared = AddDeviceView.loadView()
    private var viewModel = AddDeviceViewModel.makeEmpty()
    private var disposeBag = DisposeBag()
    private var dropDown = DropDown()
    @DIInjected var networkService: NetworkService

    // MARK: - Outlets
    @IBOutlet private weak var nameTextField: SolarTextField!
    @IBOutlet private weak var descriptionTextField: SolarTextField!
    @IBOutlet private weak var confirmButton: TapableView!
    @IBOutlet private weak var backgroundView: UIView!
    @IBOutlet private weak var emptyLabel: UILabel!

    // MARK: - Variables
    private var isDeviceInformationValid = false {
        didSet {
            self.confirmButton.isUserInteractionEnabled = isDeviceInformationValid
            self.confirmButton.backgroundColor = isDeviceInformationValid ? UIColor(rgb: 0xFF6C39) : UIColor(rgb: 0xDDDDDD)
        }
    }

    weak var delegate: AddDeviceViewDelegate?

    // MARK: - Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        self.config()
        self.loadListGardens()
    }

    private func config() {
        configNameTextField()
        configDescriptionTextField()
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

    private func configDescriptionTextField() {
        self.descriptionTextField.isHighlightedWhenEditting = true
        self.descriptionTextField.backgroundColor = UIColor(rgb: 0xF7F7F7)
        self.descriptionTextField.borderColor = UIColor(rgb: 0x575FCC)
        self.descriptionTextField.placeholder = "Description"
        self.descriptionTextField.paddingLeft = 10
        self.descriptionTextField.delegate = self
    }

    private func loadListGardens() {
        if let accessToken = AuthorizationHelper.shared.getToken() {
            networkService.getAllGardens(accessToken: accessToken).subscribe(onNext: { listGardens in
                print("number of garden:  \(listGardens.count)")
                self.viewModel = AddDeviceViewModel(listGardens: listGardens)
            }, onError: { error in
                print("Failed to get gardens infor with error \(error)")
            }).disposed(by: self.disposeBag)
        }
    }

    private func refreshUI() {
        self.emptyLabel.isHidden = self.viewModel.isEmptyWarningHidden()
    }

    // MARK: - Action
    @IBAction func confirmButtonDidTap(_ sender: Any) {
        if let gardenId = self.viewModel.selectedGarden?.id {
        self.delegate?.addDeviceViewDidTapConfirm(self, name: self.nameTextField.text, description: self.descriptionTextField.text, gardenId: gardenId)
            self.dismiss()
        } else {
            self.refreshUI()
        }
    }

    @objc func textFieldDidChange() {
        self.isDeviceInformationValid = !(self.nameTextField.text.isEmpty || self.descriptionTextField.text.isEmpty)
    }

    @IBAction func selectGardenButtonDidTap(_ sender: UIButton) {
        dropDown.dataSource = self.viewModel.listGardenName()
        dropDown.anchorView = sender
        dropDown.bottomOffset = CGPoint(x: 0, y: sender.frame.size.height)
        dropDown.show()
        dropDown.selectionAction = { [weak self] (index, item) in
            guard self != nil else { return }
            sender.setTitle(item, for: .normal)
            self?.viewModel.selectItem(at: index)
            self?.refreshUI()
        }
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

    static func loadView() -> AddDeviceView {
        return AddDeviceView.loadView(fromNib: "AddDeviceView")!
    }
}

// MARK: - SolarTextFieldDelegate
extension AddDeviceView: SolarTextFieldDelegate {
    func solarTextField(_ textField: SolarTextField, willChangeToText text: String) -> Bool {
        return true
    }

    func solarTextField(addTextFieldChangedValueObserverTo textField: PaddingTextField) {
        textField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
    }
}

extension AddDeviceView {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        if touches.first?.view == self.backgroundView {
            self.dismiss()
        }
    }
}
