//
//  Rule.swift
//  ValidateTextField
//
//  Created by Phu's Macbook Pro on 1/13/16.
//  Copyright © 2016 Vietphu. All rights reserved.
//

import Foundation

public protocol Rule {
    func validate(value: String) -> Bool
    func errorMessage() -> String
    func errorMessage(value: String) -> String
}
