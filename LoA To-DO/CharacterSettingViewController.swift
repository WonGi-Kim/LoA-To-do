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
    
    @IBOutlet weak var valtanRaidButton: UIButton!
    @IBOutlet weak var viaKissRaidButton: UIButton!
    @IBOutlet weak var koukusatonRaidButton: UIButton!
    @IBOutlet weak var abrelshudRaidButton: UIButton!
    @IBOutlet weak var iliakanRaidButton: UIButton!
    @IBOutlet weak var kamenRaidButton: UIButton!
    @IBOutlet weak var abyssRaidButton: UIButton!
    @IBOutlet weak var abyssDunField: UITextField!
    
    
    var classArray: [String] = []
    var characterClassPicker: UIPickerView!
    var abyssArray: [String] = []
    var abyssDunPicker: UIPickerView!
    
    var characterSetting: [CharacterSetting] = []
    var isGuardianRaidCheck: Bool = false //   일일 가디언 토벌 여부
    var isChaosDungeonCheck: Bool = false //   일일 카오스 던전 여부
    var isAbyssDungeonName: String = ""
    var isAbyssDungeonCheck: Bool = false //   어비스 던전 여부
    var isAbyssRaidCheck: Bool = false //   어비스 레이드 여부
    var isValtanRaidCheck: Bool = false //   발탄
    var isViaKissRaidCheck: Bool = false //   비아키스
    var isKoukusatonCheck: Bool = false //   쿠크세이튼
    var isAbrelshudRaidCheck: Bool = false //   아브렐슈드
    var isIliakanRaidCheck: Bool = false // 일리아칸
    var isKamenRaidCheck: Bool = false //  카멘
    
    var goldButtonTappedCount = 0 // 레이드 버튼 갯수를 3개
    
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
        characterClassField.inputAccessoryView = toolBar(for: characterClassPicker)
        characterClassPicker.isHidden = true
        
        abyssDunField.delegate = self
        abyssDunPicker = UIPickerView()
        abyssDunPicker.delegate = self
        abyssDunPicker.dataSource = self
        abyssDunField.inputView = abyssDunPicker
        abyssDunField.inputAccessoryView = toolBar(for: abyssDunPicker)
        abyssDunPicker.isHidden = true
        
        self.confirmBarButton.isEnabled = false
        
        
        //  ScrollView에서 필요한 부분 구현
        let singleTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tappedMethod))
        singleTapGestureRecognizer.numberOfTapsRequired = 1
        singleTapGestureRecognizer.isEnabled = true
        singleTapGestureRecognizer.cancelsTouchesInView = false
        
        scrollView.addGestureRecognizer(singleTapGestureRecognizer)
        
        self.loadClassNames()
        self.loadAbyssDun()
        self.myPicker()
        self.validateInputField()
        self.checkBoxButtonLayout()
        self.abyssDunSelectedCheck()
        
        //  카멘레이드 설정은 불가
        kamenRaidButton.isEnabled = true
        kamenRaidButton.alpha = 0.4
        
        
    }
    
    //  MARK: - endEditing
    //  singleTapGestureRecognizer의 selector 구현
    @objc func tappedMethod(sender: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
    
    // 유저가 화면을 터치하면 발생하는 메소드로 화면 터치시 키보드 혹은 데이터피커 같은 도구가 내려간다.
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    //  MARK: - plistControl
    //  plist에서 class 이름 가져오는 함수
    func loadClassNames() {
        // plist 파일 경로 가져오기
        guard let plistPath = Bundle.main.path(forResource: "CharacterClass", ofType: "plist"),
            let classArray = NSArray(contentsOfFile: plistPath) as? [NSDictionary] else { return }

        // className 값 추출하기
        var classNames: [String] = []
        for item in classArray {
            if let className = item["className"] as? String {
                classNames.append(className)
            }
        }
                
        self.classArray = classNames
    }
    
    func loadAbyssDun() {
        guard let plistPath = Bundle.main.path(forResource: "AbyssList", ofType: "plist"),
            let abyssArray = NSArray(contentsOfFile: plistPath) as? [NSDictionary] else { return }
        
        var abyssLists: [String] = []
        for item in abyssArray {
            if let abyssList = item["dunName"] as? String {
                abyssLists.append(abyssList)
            }
        }
        self.abyssArray = abyssLists
    }
    
    //  MARK: - pickerView
    func myPicker() {
        characterClassPicker.frame = CGRect(x: 150, y: 150, width: 200, height: 250)
        abyssDunPicker.frame = CGRect(x: 150, y: 150, width: 200, height: 250)
        view.addSubview(characterClassPicker)
        view.addSubview(abyssDunPicker)
    }
    
    //  MARK: - Using BarButton for DataTransfer
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
            isAbyssDungeonName: isAbyssDungeonName,
            isAbyssRaidCheck: isAbyssRaidCheck,
            isValtanRaidCheck: isValtanRaidCheck,
            isViaKissRaidCheck: isViaKissRaidCheck,
            isKoukusatonCheck: isKoukusatonCheck,
            isAbrelshudRaidCheck: isAbrelshudRaidCheck,
            isIliakanRaidCheck: isIliakanRaidCheck,
            isKamenRaidCheck: isKamenRaidCheck
        )
        
        print("barButton tapped")
        
        //  delegate 메소드 호출 후 데이터 전달
        //self.delegate?.didSelectCharacter(name: name, level: level, playerClass: playerClass)
        self.delegate?.didSelectCharacter(characterSetting: characterSetting)
        navigationController?.popViewController(animated: true)
    }
    
    //  MARK: - Using Segue for DataTransper
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
    
    //  MARK: - validata
    private func validateInputField() {
        self.confirmBarButton.isEnabled = !(self.characterNameField.text?.isEmpty ?? true) && !(self.itemLevelField.text?.isEmpty ?? true) && !(self.characterClassField.text?.isEmpty ?? true)
    }
    
    //  MARK: - CheckBoxButton UI 관리
    func checkBoxButtonLayout() {
        for button in checkBoxButtons {
            button.layer.cornerRadius = 7
            button.layer.backgroundColor = UIColor.systemBackground.cgColor
            button.layer.borderColor = UIColor.gray.cgColor
            button.layer.borderWidth = 1.5
        }
    }
    
    //  MARK: - 주간 골드 횟수를 초과하게된다면 알럿 호출
    func showAlert() {
        let alert = UIAlertController(title: "확인해주세요", message: "더이상 골드를 획득할 수 없습니다.", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "확인", style: .default, handler: nil)
        alert.addAction(okAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    //  MARK: - 카오스던전 버튼 관리
    @IBAction func chaosDunButton(_ sender: UIButton) {
        sender.isSelected.toggle()
        isChaosDungeonCheck = true
    }
    
    //  MARK: - 가디언 토벌 버튼 관리
    @IBAction func guardianRaidButton(_ sender: UIButton) {
        sender.isSelected.toggle()
        isGuardianRaidCheck = true
    }
    
    //  MARK: - 군단장 레이드 버튼
    @IBAction func valtanRaidButton(_ sender: UIButton) {
        sender.isSelected.toggle()
        
        if sender.isSelected {
            goldButtonTappedCount += 1
            isValtanRaidCheck = true
        } else {
            goldButtonTappedCount -= 1
            isValtanRaidCheck = false
        }
        
        if goldButtonTappedCount > 3 {
            showAlert()
        }
    }
    @IBAction func viakissRaidButton(_ sender: UIButton) {
        sender.isSelected.toggle()
        
        if sender.isSelected {
            goldButtonTappedCount += 1
            isViaKissRaidCheck = true
        } else {
            goldButtonTappedCount -= 1
            isViaKissRaidCheck = false
        }
        
        if goldButtonTappedCount > 3 {
            showAlert()
        }
    }
    @IBAction func koukusatonRaidButton(_ sender: UIButton) {
        sender.isSelected.toggle()
        
        if sender.isSelected {
            goldButtonTappedCount += 1
            isKoukusatonCheck = true
        } else {
            goldButtonTappedCount -= 1
            isKoukusatonCheck = false
        }
        
        if goldButtonTappedCount > 3 {
            showAlert()
        }
    }
    @IBAction func abrelshudRaidButton(_ sender: UIButton) {
        sender.isSelected.toggle()
        
        if sender.isSelected {
            goldButtonTappedCount += 1
            isAbrelshudRaidCheck = true
        } else {
            goldButtonTappedCount -= 1
            isAbrelshudRaidCheck = false
        }
        
        if goldButtonTappedCount > 3 {
            showAlert()
        }
    }
    @IBAction func iliakanRaidButton(_ sender: UIButton) {
        sender.isSelected.toggle()
        
        if sender.isSelected {
            goldButtonTappedCount += 1
            isIliakanRaidCheck = true
        } else {
            goldButtonTappedCount -= 1
            isIliakanRaidCheck = false
        }
        
        if goldButtonTappedCount > 3 {
            showAlert()
        }
    }
    @IBAction func kamenRaidButton(_ sender: UIButton) {
        // 카멘레이드는 아직 선택할 수 없게 설정
        /**
        sender.isSelected.toggle()
        
        if sender.isSelected {
            goldButtonTappedCount += 1
            isKamenRaidCheck = true
        } else {
            goldButtonTappedCount -= 1
            isKamenRaidCheck = false
        }
        
        if goldButtonTappedCount > 3 {
            showAlert()
        }
         */
    }
    
    //  MARK: - Abyss관련
    @IBAction func abyssRaidButton(_ sender: UIButton) {
        sender.isSelected.toggle()
        
        if sender.isSelected {
            goldButtonTappedCount += 1
            isAbyssRaidCheck = true
        } else {
            goldButtonTappedCount -= 1
            isAbyssRaidCheck = false
        }
        
        if goldButtonTappedCount > 3 {
            showAlert()
        }
    }
    
    func abyssDunSelectedCheck() {
        if abyssDunField.text?.isEmpty == false {
            isAbyssDungeonCheck = true
            isAbyssDungeonName = abyssDunField.text ?? ""
            goldButtonTappedCount += 1
        } else {
            isAbyssDungeonCheck = false
        }
        
        if goldButtonTappedCount > 3 {
            showAlert()
        }
    }
    
    // MARK: - Picker toolbar
    func toolBar(for picker: UIPickerView) -> UIToolbar {
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        
        let doneBtn = UIBarButtonItem(title: "확인", style: .plain, target: self, action: #selector(doneButtonTapped))
        toolBar.setItems([UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil), doneBtn], animated: true)

        return toolBar
    }

    @objc func doneButtonTapped() {
        // 피커 내용 선택 완료 후 동작할 코드 작성
        characterClassField.resignFirstResponder()
        abyssDunField.resignFirstResponder()
        
    }

    
}


// MARK: - UIPickerView에 대한 extension
extension CharacterSettingViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    // UIPickerViewDataSource methods
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == characterClassPicker {
            return max(classArray.count, 1)
        } else if pickerView == abyssDunPicker {
            return max(abyssArray.count, 1)
        }
        return 0
        // return max(classArray.count, 1)
    }
    
    //  UIPickerViewDelegate method
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == characterClassPicker {
            return classArray[row]
        } else if pickerView == abyssDunPicker {
            return abyssArray[row]
        }
        return nil
        // return classArray[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == characterClassPicker {
            let selectedOption = classArray[row]
            characterClassField.text = selectedOption
        } else if pickerView == abyssDunPicker {
            let selectedOption = abyssArray[row]
            abyssDunField.text = selectedOption
        }
    }
    
}

// MARK: - UITextField
extension CharacterSettingViewController: UITextFieldDelegate {
    
    //  UITextFieldDelegate method
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == characterClassField {
            characterClassPicker.isHidden = false
        } else {
            characterClassPicker.isHidden = true
        }
        
        if textField == abyssDunField {
            abyssDunPicker.isHidden = false
        } else {
            abyssDunPicker.isHidden = true
        }
        
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        characterClassPicker.isHidden = true
        
        if textField == abyssDunField {
            abyssDunSelectedCheck()
        }
        
        self.validateInputField()
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        return true
    }

    
}
// MARK: - UIScrollView
extension CharacterSettingViewController: UIScrollViewDelegate {
    
    //  ScrollView에서 scroll진행 시 키 다운
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self.view.endEditing(true)
        self.validateInputField()
    }
}
