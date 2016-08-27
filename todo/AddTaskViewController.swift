//
//  AddTaskViewController.swift
//  testapp3
//
//  Created by Sankalp Agarwal on 11/08/16.
//  Copyright © 2016 Sankalp Agarwal. All rights reserved.
//

import Foundation
import UIKit

class AddTaskViewController: UIViewController, UITextFieldDelegate, UIPickerViewDelegate {
    
    var usersFromJson: [AnyObject]? = [["name": "waiting for list"]]
    
    // Creates a text Field
    var inputTaskField: UITextField = {
        let sampleTextField = UITextField(frame: CGRectMake(20, 80, 280, 36))
        sampleTextField.placeholder = "What needs to be done"
        sampleTextField.font = UIFont.systemFontOfSize(15)
        sampleTextField.borderStyle = UITextBorderStyle.RoundedRect
        sampleTextField.autocorrectionType = UITextAutocorrectionType.No
        sampleTextField.keyboardType = UIKeyboardType.Default
        sampleTextField.returnKeyType = UIReturnKeyType.Done
        sampleTextField.clearButtonMode = UITextFieldViewMode.WhileEditing;
        sampleTextField.contentVerticalAlignment = UIControlContentVerticalAlignment.Center
        return sampleTextField
    }()
    
    //create a button
    var addTaskButton: UIButton = {
        let button = UIButton(frame: CGRectMake(100, 300, 120, 40))
        button.backgroundColor = UIColor(red:0.00, green:0.48, blue:1.00, alpha:1.0)
        button.setTitle("Add task", forState: UIControlState.Normal)
        button.addTarget(nil, action: #selector(AddTaskViewController.buttonAction), forControlEvents: UIControlEvents.TouchUpInside)
        button.tag = 1
        return button
    }()
    
    // create a text field for date input
    var dateField: UITextField = {
        let myField = UITextField(frame: CGRectMake(20, 130, 280, 36))
        myField.placeholder = "Date & Time"
        myField.font = UIFont.systemFontOfSize(15)
        myField.borderStyle = UITextBorderStyle.RoundedRect
        myField.autocorrectionType = UITextAutocorrectionType.No
        myField.keyboardType = UIKeyboardType.Default
        myField.returnKeyType = UIReturnKeyType.Done
        myField.clearButtonMode = UITextFieldViewMode.WhileEditing;
        myField.contentVerticalAlignment = UIControlContentVerticalAlignment.Center
        return myField
    }()
    
    // create a text field for assignee input
    var assigneeField: UITextField = {
        let myField = UITextField(frame: CGRectMake(20, 180, 280, 36))
        myField.placeholder = "Assign task to"
        myField.font = UIFont.systemFontOfSize(15)
        myField.borderStyle = UITextBorderStyle.RoundedRect
        myField.autocorrectionType = UITextAutocorrectionType.No
        myField.keyboardType = UIKeyboardType.Default
        myField.returnKeyType = UIReturnKeyType.Done
        myField.clearButtonMode = UITextFieldViewMode.WhileEditing;
        myField.contentVerticalAlignment = UIControlContentVerticalAlignment.Center
        return myField
    }()
    
    // defining the assignee picker
    let namePicker = UIPickerView()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.whiteColor();
        
        // Adds text field to the view
        self.inputTaskField.delegate = self
        self.view.addSubview(inputTaskField)
        
        // Adds button to the view
        self.view.addSubview(addTaskButton)
        
        // Adds date field to the view
        self.dateField.delegate = self
        self.view.addSubview(dateField)
        
        // Add assignee field to the view
        self.assigneeField.delegate = self
        self.view.addSubview(assigneeField)
        
        //assignee picker
        self.namePicker.delegate = self
        assigneeField.inputView = namePicker
        
    }
    
    override func viewWillAppear(animated: Bool) {
        HTTPGetJSONArray("https://frozen-plains-62045.herokuapp.com/api/users/+918281663438") {
            (data: [AnyObject], error: String?) -> Void in
            if error != nil {
                print(error)
            } else {
                self.usersFromJson = data
                dispatch_async(dispatch_get_main_queue(), {
                    self.namePicker.reloadAllComponents()
                })
            }
        }
    }
    
    
    
    func buttonAction() {
        
        // save the data in the input field
        let defaults = NSUserDefaults.standardUserDefaults()
        var array = defaults.objectForKey("Key1") as? [String] ?? [String]()
        array.append(self.inputTaskField.text!)
        defaults.setObject(array, forKey: "Key1")
        
        //navigate to the previous view
        self.navigationController?.popViewControllerAnimated(true)
        
    }
    
    
    func textFieldDidEndEditing(textField: UITextField){
        textField.resignFirstResponder()
    }
    
    
    func textFieldDidBeginEditing(textField: UITextField) {
        let datePicker = UIDatePicker()
        dateField.inputView = datePicker
        datePicker.minuteInterval = 15
        datePicker.addTarget(self, action: #selector(AddTaskViewController.datePickerChanged), forControlEvents: .ValueChanged)
    }
    
    
    func datePickerChanged(sender: UIDatePicker){
        let formatter = NSDateFormatter()
        formatter.dateStyle = .LongStyle
        formatter.timeStyle = .ShortStyle
        dateField.text = formatter.stringFromDate(sender.date)
    }
    
    // assignee picker functions
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return usersFromJson!.count
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let nameOfUser:String = usersFromJson![row]["name"] as! String
        return nameOfUser
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let nameOfUser:String = usersFromJson![row]["name"] as! String
        assigneeField.text = nameOfUser
    }
    
}