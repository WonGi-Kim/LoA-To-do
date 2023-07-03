//
//  SettingViewController.swift
//  LoA To-DO
//
//  Created by 김원기 on 2023/05/30.
//

import UIKit

//  CharacterMainViewController로 데이터를 전달하기 위해 delegate 속성을 추가하기 위한 프로토콜 작성
protocol CharacterSettingViewControllerDelgate: AnyObject {
    //func didSelectCharacter(name: String, level: String, playerClass: String)
    //  CharacterDetailViewController를 위한 protocol 작성
    func didSelectCharacter(characterSetting: CharacterSetting)
}



class CharacterSettingViewController: UIViewController {
    
    //  MARK: - Declare Outlet and Variaus
    //  delegate 속성 추가
    weak var delegate: CharacterSettingViewControllerDelgate?
    
    @IBOutlet weak var characterNameField: UITextField!
    @IBOutlet weak var itemLevelField: UITextField!
    @IBOutlet weak var characterClassField: UITextField!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var confirmBarButton: UIBarButtonItem!
    
    @IBOutlet weak var chaosDunButton: UIButton!
    @IBOutlet weak var guardianRaidButton: UIButton!
    
    @IBOutlet var checkBoxButtons: [UIButton]!
    
    
    
    var dataArray: [String] = []
    var characterClassPicker: UIPickerView!
    
    var characterSetting: [CharacterSetting] = []
    var isGuardianRaidCheck: Bool = false//   일일 가디언 토벌 여부
    var isChaosDungeonCheck: Bool = false //   일일 카오스 던전 여부
    var isAbyssDungeonCheck: Bool = false //   어비스 던전 여부
    var isCommander0Check: Bool = false //   첫번째 군단장 여부
    var isCommander1Check: Bool = false //   두번째 군단장 여부
    var isCommender2Check: Bool = false //   세번째 군단장 여부
    
    //  MARK: - ViewDidLoad()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        characterNameField.delegate = self
        itemLevelField.delegate = self
        characterClassField.delegate = self
        
        characterClassPicker = UIPickerView()
        characterClassPicker.delegate = self
        characterClassPicker.dataSource = self
        
        characterClassField.inputView = characterClassPicker
        characterClassPicker.isHidden = true
        
        self.confirmBarButton.isEnabled = false
        
        
        //  ScrollView에서 필요한 부분 구현
        let singleTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tappedMethod))
        singleTapGestureRecognizer.numberOfTapsRequired = 1
        singleTapGestureRecognizer.isEnabled = true
        singleTapGestureRecognizer.cancelsTouchesInView = false
        
        scrollView.addGestureRecognizer(singleTapGestureRecognizer)
        
        self.loadClassNames()
        self.myPicker()
        self.validateInputField()
        self.checkBoxButtonLayout()
        
        
    }
    
    // MARK: - endEditing
    //  singleTapGestureRecognizer의 selector 구현
    @objc func tappedMethod(sender: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
    
    // 유저가 화면을 터치하면 발생하는 메소드로 화면 터치시 키보드 혹은 데이터피커 같은 도구가 내려간다.
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    // MARK: - plistControl
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
    
    
    
    // MARK: - pickerView
    func myPicker() {
        characterClassPicker.frame = CGRect(x: 150, y: 150, width: 200, height: 250)
        view.addSubview(characterClassPicker)
    }
    
    // MARK: - Using BarButton for DataTransfer
    @IBAction func confirmBarButton(_ sender: UIBarButtonItem) {
        guard let name = self.characterNameField.text else { return }
        guard let level = self.itemLevelField.text else { return }
        guard let playerClass = self.characterClassField.text else { return }
        
        let characterSetting = CharacterSetting(
            charName: name,
            charLevel: level,
            charClass: playerClass,
            isGuardianRaidCheck: isGuardianRaidCheck,
            isChaosDungeonCheck: isChaosDungeonCheck,
            isAbyssDungeonCheck: isAbyssDungeonCheck,
            isCommander0Check: isCommander0Check,
            isCommander1Check: isCommander1Check,
            isCommender2Check: isCommender2Check
        )
        
        print("barButton tapped")
        print(isChaosDungeonCheck)
        
        //  delegate 메소드 호출 후 데이터 전달
        //self.delegate?.didSelectCharacter(name: name, level: level, playerClass: playerClass)
        self.delegate?.didSelectCharacter(characterSetting: characterSetting)
        navigationController?.popViewController(animated: true)
    }
    
    // MARK: - Using Segue for DataTransper
    /**
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let mainViewController = segue.destination as? CharacterMainViewController {
            guard let name = self.characterNameField.text else { return }
            guard let level = self.itemLevelField.text else { return }
            guard let playerClass = self.characterClassField.text else { return }
            
            mainViewController.charName = name
            mainViewController.charLevel = level
            mainViewController.charClass = playerClass
            }
    }*/
    
    // MARK: - validata
    private func validateInputField() {
        self.confirmBarButton.isEnabled = !(self.characterNameField.text?.isEmpty ?? true) && !(self.itemLevelField.text?.isEmpty ?? true) && !(self.characterClassField.text?.isEmpty ?? true)
    }
    
    // MARK: - CheckBoxButton UI 관리
    func checkBoxButtonLayout() {
        for button in checkBoxButtons {
            button.layer.cornerRadius = 7
            button.layer.backgroundColor = UIColor.systemBackground.cgColor
            button.layer.borderColor = UIColor.gray.cgColor
            button.layer.borderWidth = 1.5
        }
    }
    
    // MARK: - 카오스던전 버튼 관리
    @IBAction func chaosDunButton(_ sender: UIButton) {
        sender.isSelected.toggle()
        isChaosDungeonCheck = true
    }
    
    //  MARK: - 가디언 토벌 버튼 관리
    @IBAction func guardianRaidButton(_ sender: UIButton) {
        sender.isSelected.toggle()
        isGuardianRaidCheck = true
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
