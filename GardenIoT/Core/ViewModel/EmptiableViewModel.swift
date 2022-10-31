//
//  EmptiableViewModel.swift
//  Core
//
//  Created by Thanh Vu on 18/2/2021.
//

import Foundation

public protocol EmptiableViewModel {
    static func makeEmpty() -> Self
}
