//
//  RootViewController.swift
//  GardenIoT
//
//  Created by đào sơn on 01/11/2022.
//

import RIBs
import RxSwift
import UIKit

protocol RootPresentableListener: AnyObject {
}

final class RootViewController: UIViewController, RootPresentable, RootViewControllable {
    weak var listener: RootPresentableListener?
}
