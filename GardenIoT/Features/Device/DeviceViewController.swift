//
//  DeviceViewController.swift
//  GardenIoT
//
//  Created by đào sơn on 24/11/2022.
//

import RIBs
import RxSwift
import UIKit

protocol DevicePresentableListener: AnyObject {
}

final class DeviceViewController: UIViewController, DevicePresentable, DeviceViewControllable {
    weak var listener: DevicePresentableListener?
}
