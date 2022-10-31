//
//  PresentableExtensions.swift
//  ColoringByPixel
//
//  Created by Linh Nguyen Duc on 11/10/2022.
//

import UIKit
import RIBs

public extension Presentable {
    func showNoInternet(retryAction: (() -> Void)? = nil) {
        NoInternetView.show(retryAction: retryAction)
    }

    func showNoInternetBanner() {
        NoInternetBannerView.show()
    }

    func dismissInternetBanner() {
        NoInternetBannerView.dismiss()
    }

    func showSomethingWrongError() {
        TimeoutDialog.show()
    }
}
