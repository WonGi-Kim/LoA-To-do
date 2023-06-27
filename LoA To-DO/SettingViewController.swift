//
//  SettingViewController.swift
//  LoA To-DO
//
//  Created by 김원기 on 2023/05/30.
//

import UIKit

class SettingViewController: UIViewController {
    
    @IBOutlet weak var characterNameField: UITextField!
    @IBOutlet weak var itemLevelField: UITextField!
    @IBOutlet weak var characterClassField: UITextField!
    
    @IBOutlet weak var characterClassPicker: UIPickerView!
    
    let options = ["리퍼", "창술사", "아르카나", "소울이터"]
    
    weak var delegate: SettingViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        characterNameField.delegate = self
        itemLevelField.delegate = self
        characterClassField.delegate = self
        characterClassPicker.delegate = self
        characterClassPicker.dataSource = self
        
        characterClassField.inputView = characterClassPicker
    }
    
}

extension SettingViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    // UIPickerViewDataSource methods
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return options.count
    }
    
    //  UIPickerViewDelegate method
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return options[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let selectedOption = options[row]
        characterClassField.text = selectedOption
        characterClassField.resignFirstResponder()
    }
}

extension SettingViewController: UITextFieldDelegate {
    
    //  UITextFieldDelegate method
    func textFieldDidBeginEditing(_ textField: UITextField) {
        characterClassPicker.isHidden = false
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        characterClassPicker.isHidden = true
    }
    
}
