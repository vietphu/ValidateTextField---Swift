//
//  RequiredRule.swift
//  ValidateTextField
//
//  Created by Phu's Macbook Pro on 1/13/16.
//  Copyright © 2016 Vietphu. All rights reserved.
//

import UIKit

import Foundation

public class RequiredRule: Rule {
    
    private var message : String
    
    public init(message : String = "※ 入力されていません。"){
        self.message = message
    }
    
    public func validate(value: String) -> Bool {
        return !value.isEmpty
    }
    
    public func errorMessage() -> String {
        return message
    }
    
    public func errorMessage(value: String) -> String {
        if(self.validate(value)){
            return ""
        }else{
            return message
        }
    }
}
