//
//  ValidateTextField.swift
//  ValidateTextField
//
//  Created by Phu's Macbook Pro on 1/13/16.
//  Copyright © 2016 Vietphu. All rights reserved.
//

import UIKit

@IBDesignable class ValidateTextField: UIView, UITextFieldDelegate {

    let titleLabel = UILabel()
    let textField = UITextField()
    var validateLabelHightConstraint:NSLayoutConstraint!
    var heightConstraint:NSLayoutConstraint!
    var minHeightConstraint:NSLayoutConstraint!
    var maxHeightConstraint:NSLayoutConstraint!
    var defaultHeightView:CGFloat = 50.0
    
    var rules:[Rule] = []
    
    @IBInspectable var validatorTitle: String {
        get { return titleLabel.text! }
        set { titleLabel.text = newValue }
    }
    
    @IBInspectable var placeholder: String? {
        get { return textField.placeholder }
        set { textField.placeholder = newValue }
    }
    
    @IBInspectable var validatorTextColor: UIColor? {
        get { return titleLabel.textColor }
        set { titleLabel.textColor = newValue }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setupContent()
        associateConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
        setupContent()
        associateConstraints()
    }
    
    override func prepareForInterfaceBuilder() {
        if titleLabel.text == nil {
            validatorTitle = "validateを入力してください"
        }
        if textField.placeholder == nil {
            placeholder = "placeholderを入力してください"
        }
    }
    
    private func setupView() {
        addSubview(titleLabel)
        addSubview(textField)
        textField.borderStyle = .RoundedRect
        titleLabel.textAlignment = .Left
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        textField.translatesAutoresizingMaskIntoConstraints = false
        addConstraints(layoutConstraints())
        self.updateValidateDisplay("")
    }
    
    private func setupContent() {
        textField.delegate = self
    }
    
    private func $(view1: AnyObject!, attr1: NSLayoutAttribute, rel: NSLayoutRelation,
        view2: AnyObject!, attr2: NSLayoutAttribute, mul: CGFloat, constant: CGFloat) -> NSLayoutConstraint {
            return NSLayoutConstraint(item: view1, attribute: attr1, relatedBy: rel, toItem: view2, attribute: attr2, multiplier: mul, constant: constant)
    }
    
    private func layoutConstraints() -> [NSLayoutConstraint] {
        var result: [NSLayoutConstraint] = []
        validateLabelHightConstraint = $(titleLabel, attr1: .Height, rel: .Equal, view2: nil, attr2: .Height, mul: 1.0, constant: 0.0)
        result.append(validateLabelHightConstraint)
        result.append($(titleLabel, attr1: .Height, rel: .GreaterThanOrEqual, view2: nil, attr2: .Height, mul: 1.0, constant: 0.0))
        result.append($(titleLabel, attr1: .Leading, rel: .Equal, view2: self, attr2: .Leading, mul: 1.0, constant: 0.0))
        result.append($(titleLabel, attr1: .Trailing, rel: .Equal, view2: self, attr2: .Trailing, mul: 1.0, constant: 0.0))
        result.append($(titleLabel, attr1: .Top, rel: .Equal, view2: self, attr2: .Top, mul: 1.0, constant: 0.0))
        
        result.append($(textField, attr1: .Leading, rel: .Equal, view2: self, attr2: .Leading, mul: 1.0, constant: 0.0))
        result.append($(textField, attr1: .Trailing, rel: .Equal, view2: self, attr2: .Trailing, mul: 1.0, constant: 0.0))
        result.append($(textField, attr1: .Top, rel: .Equal, view2: titleLabel, attr2: .Bottom, mul: 1.0, constant: 0.0))
        result.append($(textField, attr1: .Bottom, rel: .Equal, view2: self, attr2: .Bottom, mul: 1.0, constant: 0.0))
        
        return result
    }
    
    private func checkValidate() {
        var errorMessage = ""
        for rule:Rule in self.rules{
            let validateError = rule.errorMessage(textField.text!)
            if(validateError.length>0){
                if(errorMessage.length>0){
                    errorMessage.appendContentsOf("\n")
                }
                errorMessage.appendContentsOf(validateError)
            }
        }
        self.updateValidateDisplay(errorMessage)
        self.heightConstraint.constant = validateLabelHightConstraint.constant + defaultHeightView
        self.layoutSubviews()
        self.superview?.layoutSubviews()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, defaultHeightView + validateLabelHightConstraint.constant)
    }
    
    private func updateValidateDisplay(validateText: String) {
        titleLabel.text = validateText
        titleLabel.resizeHeightToFit(validateLabelHightConstraint)
        if(titleLabel.text?.length==0){
            validateLabelHightConstraint.constant = 0.0;
            titleLabel.hidden = true
        }else{
            titleLabel.hidden = false
        }
    }
    
    func associateConstraints() {
        
        for constraint: NSLayoutConstraint in self.constraints {
            if (constraint.firstAttribute == .Height && constraint.firstItem as! NSObject==self){
                if constraint.relation == .Equal {
                    self.heightConstraint = constraint
                }
                else if constraint.relation == .LessThanOrEqual {
                    self.maxHeightConstraint = constraint
                }
                else if constraint.relation == .GreaterThanOrEqual {
                    self.minHeightConstraint = constraint
                }
            }
        }
        
        if(self.heightConstraint==nil){
            self.heightConstraint = $(self, attr1: .Height, rel: .GreaterThanOrEqual, view2: nil, attr2: .Height, mul: 1.0, constant: defaultHeightView)
            self.heightConstraint.priority = 1000
            addConstraint(self.heightConstraint)
        }
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        self.checkValidate()
    }
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        return true;
    }
    
    func textFieldShouldClear(textField: UITextField) -> Bool {
        return true;
    }
    
    func textFieldShouldEndEditing(textField: UITextField) -> Bool {
        return true;
    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        return true;
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder();
        return true;
    }
}
