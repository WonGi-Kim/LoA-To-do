//
//  SettingViewController.swift
//  LoA To-DO
//
//  Created by 김원기 on 2023/05/30.
//

import UIKit

//  CharacterMainViewController로 데이터를 전달하기 위해 delegate 속성을 추가하기 위한 프로토콜 작성
protocol CharacterSettingViewControllerDelgate: AnyObject {
    func didSelectCharacter(name: String, level: String, playerClass: String)
}

class CharacterSettingViewController: UIViewController {
    
    //  MARK: - Outlet 선언
    //  delegate 속성 추가
    weak var delegate: CharacterSettingViewControllerDelgate?
    
    @IBOutlet weak var characterNameField: UITextField!
    @IBOutlet weak var itemLevelField: UITextField!
    @IBOutlet weak var characterClassField: UITextField!
    @IBOutlet weak var characterClassPicker: UIPickerView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var confirmBarButton: UIBarButtonItem!
    
    var dataArray: [String] = []
    
    //weak var delegate: CharacterSettingViewController?

    //  MARK: - ViewDidLoad()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        characterNameField.delegate = self
        itemLevelField.delegate = self
        characterClassField.delegate = self
        characterClassPicker.delegate = self
        characterClassPicker.dataSource = self
        
        characterClassField.inputView = characterClassPicker
        
        characterClassPicker.isHidden = true
        
        self.loadClassNames()
        self.myPicker()
        
        self.confirmBarButton.isEnabled = false
        
        //  ScrollView에서 필요한 부분 구현
        let singleTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tappedMethod))
        singleTapGestureRecognizer.numberOfTapsRequired = 1
        singleTapGestureRecognizer.isEnabled = true
        singleTapGestureRecognizer.cancelsTouchesInView = false
        
        scrollView.addGestureRecognizer(singleTapGestureRecognizer)
        
        self.validateInputField()
    }
    
    //  singleTapGestureRecognizer의 selector 구현
    @objc func tappedMethod(sender: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
    
    // 유저가 화면을 터치하면 발생하는 메소드로 화면 터치시 키보드 혹은 데이터피커 같은 도구가 내려간다.
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    //  plist에서 class 이름 가져오는 함수
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
    
    @IBAction func confirmBarButton(_ sender: UIBarButtonItem) {
        guard let name = self.characterNameField.text else { return }
        guard let level = self.itemLevelField.text else { return }
        guard let playerClass = self.characterClassField.text else { return }
        
        print("barButton tapped")
        
        //  delegate 메소드 호출 후 데이터 전달
        self.delegate?.didSelectCharacter(name: name, level: level, playerClass: playerClass)
        navigationController?.popViewController(animated: true)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "CharacterMainViewController" {
            if let mainViewController = segue.destination as? CharacterMainViewController {
                guard let name = self.characterNameField.text else { return }
                guard let level = self.itemLevelField.text else { return }
                
                mainViewController.characterName = name
                mainViewController.characterLevel = level
            }
        }
    }
    
    private func validateInputField() {
        self.confirmBarButton.isEnabled = !(self.characterNameField.text?.isEmpty ?? true) && !(self.itemLevelField.text?.isEmpty ?? true) && !(self.characterClassField.text?.isEmpty ?? true)
    }
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
        self.validateInputField()
    }
    
}

extension CharacterSettingViewController: UIScrollViewDelegate {
    
    //  ScrollView에서 scroll진행 시 키 다운
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self.view.endEditing(true)
        self.validateInputField()
    }
}
