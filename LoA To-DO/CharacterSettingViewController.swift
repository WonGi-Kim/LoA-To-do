//
//  SettingViewController.swift
//  LoA To-DO
//
//  Created by 김원기 on 2023/05/30.
//

import UIKit

class CharacterSettingViewController: UIViewController {
    
    @IBOutlet weak var characterNameField: UITextField!
    @IBOutlet weak var itemLevelField: UITextField!
    @IBOutlet weak var characterClassField: UITextField!
    
    @IBOutlet weak var characterClassPicker: UIPickerView!
    
    var dataArray: [String] = []
    weak var delegate: CharacterSettingViewController?
    
    // 유저가 화면을 터치하면 발생하는 메소드로 화면 터치시 키보드 혹은 데이터피커 같은 도구가 내려간다.
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        characterNameField.delegate = self
        itemLevelField.delegate = self
        characterClassField.delegate = self
        characterClassPicker.delegate = self
        characterClassPicker.dataSource = self
        
        characterClassField.inputView = characterClassPicker
        //characterClassField.inputView = addToolbar() // 툴바 추가
        
        characterClassPicker.isHidden = true
        
        self.loadClassNames()
        self.myPicker()
        //self.addToolbar()
        
    }
    
    func loadClassNames() {
        // plist 파일 경로 가져오기
        guard let plistPath = Bundle.main.path(forResource: "CharacterClass", ofType: "plist"),
            let dataArray = NSArray(contentsOfFile: plistPath) as? [NSDictionary] else { return }

        // className 값 추출하기
        var classNames: [String] = []
        for item in dataArray {
            if let className = item["className"] as? String {
                classNames.append(className)
            }
        }
                
        self.dataArray = classNames
    }
    
    func myPicker() {
        characterClassPicker.frame = CGRect(x: 150, y: 150, width: 200, height: 250)
        view.addSubview(characterClassPicker)
    }
    
    /**func addToolbar() -> UIToolbar {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(pickerDoneButtonTapped))
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        
        toolbar.setItems([flexSpace, doneButton], animated: false)
        
        return toolbar
    }
    
    @objc func pickerDoneButtonTapped() {
        characterClassField.resignFirstResponder() //   키보드 다운
    }*/
    
    
}



extension CharacterSettingViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    // UIPickerViewDataSource methods
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return max(dataArray.count, 1)
    }
    
    //  UIPickerViewDelegate method
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return dataArray[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let selectedOption = dataArray[row]
        characterClassField.text = selectedOption
        characterClassField.resignFirstResponder()
    }
}

extension CharacterSettingViewController: UITextFieldDelegate {
    
    //  UITextFieldDelegate method
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == characterClassField {
            characterClassPicker.isHidden = false
        } else {
            characterClassPicker.isHidden = true
        }
        
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        characterClassPicker.isHidden = true
    }
    
}
