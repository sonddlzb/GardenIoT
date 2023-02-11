//
//  DataStatisticViewController.swift
//  GardenIoT
//
//  Created by đào sơn on 09/01/2023.
//

import RIBs
import RxSwift
import UIKit
import DropDown

protocol DataStatisticPresentableListener: AnyObject {
    func didTapBackButton()
    func didChangeDateTo(date: Date, isToTextFieldFocus: Bool)
    func didTapFilterButton(fromDate: String, toDate: String)
    func didSelectGarden(at index: Int)
}

final class DataStatisticViewController: UIViewController {
    // MARK: - Outlets
    @IBOutlet private weak var toTextField: UITextField!
    @IBOutlet private weak var fromTextField: UITextField!
    @IBOutlet private weak var selectGardenButton: UIButton!
    @IBOutlet private weak var contentView: UIView!

    // MARK: - Varaibles
    weak var listener: DataStatisticPresentableListener?
    private var viewModel = DataStatisticViewModel(fromDate: Date(), toDate: Date())
    private var dropDown = DropDown()
    private var currentViewController: ViewControllable?

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.config()
    }

    // MARK: - Config
    private func config() {
        self.configDatePicker()
    }

    private func configDatePicker() {
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        datePicker.addTarget(self, action: #selector(dateChange(datePicker:)), for: .valueChanged)
        datePicker.frame.size = CGSize(width: 0, height: 300)
        if #available(iOS 14, *) {
            datePicker.preferredDatePickerStyle = .inline
        }

        datePicker.maximumDate = Date()
        self.fromTextField.inputView = datePicker
        self.toTextField.inputView = datePicker
    }

    // MARK: - Actions
    @IBAction func didTapBackButton(_ sender: TapableView) {
        self.listener?.didTapBackButton()
    }

    @objc func dateChange(datePicker: UIDatePicker) {
        self.listener?.didChangeDateTo(date: datePicker.date, isToTextFieldFocus: self.toTextField.isFirstResponder)
    }

    @IBAction func selectGardenButtonDidTap(_ sender: UIButton) {
        dropDown.dataSource = self.viewModel.listGardenName()
        dropDown.anchorView = sender
        dropDown.bottomOffset = CGPoint(x: 0, y: sender.frame.size.height)
        dropDown.show()
        dropDown.selectionAction = { [weak self] (index, item) in
            guard self != nil else { return }
            sender.setTitle(item, for: .normal)
            self?.listener?.didSelectGarden(at: index)
        }
    }

    @IBAction func filterButtonDidTap(_ sender: TapableView) {
        self.listener?.didTapFilterButton(fromDate: self.fromTextField.text ?? "",
                                          toDate: self.toTextField.text ?? "")
    }
}

extension DataStatisticViewController {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
}

// MARK: - DataStatisticPresentable
extension DataStatisticViewController: DataStatisticPresentable {
    func bind(viewModel: DataStatisticViewModel) {
        self.viewModel = viewModel
        self.loadViewIfNeeded()
        self.toTextField.text = self.viewModel.toDateToString()
        self.fromTextField.text = self.viewModel.fromDateToString()
        self.selectGardenButton.setTitle(self.viewModel.selectedGarden?.name ?? "Select Garden", for: .normal)
    }

    func bindFilterResult(isSuccess: Bool, message: String) {
        if !isSuccess {
            FailedDialog.show(title: "Failed to get data", message: message)
        }
    }
}

extension DataStatisticViewController: DataStatisticViewControllable {
    func embedViewController(_ viewController: ViewControllable) {
        self.loadViewIfNeeded()

        self.currentViewController?.uiviewController.view.removeFromSuperview()
        self.currentViewController?.uiviewController.removeFromParent()

        self.contentView.addSubview(viewController.uiviewController.view)
        viewController.uiviewController.view.fitSuperviewConstraint()

        self.addChild(viewController.uiviewController)
        self.currentViewController = viewController
    }
}
