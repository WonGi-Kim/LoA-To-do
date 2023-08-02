//
//  CharacterDetailViewController.swift
//  LoA To-DO
//
//  Created by 김원기 on 2023/07/07.
//

import Foundation
import UIKit
import SnapKit
import Firebase
import FirebaseAuth
import FirebaseFirestore
import FirebaseCore

class CharacterDetailViewController: UIViewController {
    
    var characterSetting: CharacterSetting?
    var characterToDoInto: [CharacterToDoInfo] = []
    
    let scrollView = UIScrollView()
    let contentView = UIView()
    
    var characterName: String = ""
    var isGuardianRaidDone: Bool = false
    var isChaosDungeonDone: Bool = false
    var isAbyssDungeonDone: Bool = false
    var isAbyssRaidDone: Bool = false
    var isValtanRaidDone: Bool = false
    var isViaKissRaidDone: Bool = false
    var isKoukusatonRaidDone: Bool = false
    var isAbrelshudRaidDone: Bool = false
    var isIliakanRaidDone: Bool = false
    var isKamenRaidDone: Bool = false
    
    var nameLabel = UILabel()
    var levelLabel = UILabel()
    var classLabel = UILabel()
    var dailyNoticeLabel = UILabel()
    var raidNoticeLabel = UILabel()
    var abyssNoticeLabel = UILabel()
    var characterImage = UIImageView()
    
    var dailySectionLabel = UILabel()
    var chaosDunButton = UIButton()
    var guardianRaidButton = UIButton()
    
    var raidSectionLabel = UILabel()
    var valtanButton = UIButton()
    var viakissButton = UIButton()
    var koukuButton = UIButton()
    var abrelButton = UIButton()
    var lilakanButton = UIButton()
    var kamenButtonn = UIButton()
    
    var abyssSectionLabel = UILabel()
    var abyssDunButton = UIButton()
    var abyssRaidButton = UIButton()
    
    var editButton = UIButton()
    var deleteButton = UIButton()
    
    //  리스트로 선언해서 받아내지 않으면 밑줄 뷰가 겹치는 현상 발생
    var underLines: [UIView] = []
    
    //  API 오류 메시지
    struct ErrorResponse: Codable {
        let Code: Int
        let Description: String
    }

    // MARK: - LostArk Open API
    func getProfiles(characterName: String) {
        let baseURLString = "https://developer-lostark.game.onstove.com/armories/characters/\(characterName)/profiles"

        if let url = URL(string: baseURLString) {
            var request = URLRequest(url: url)
            request.httpMethod = "GET"

            // 헤더 설정
            request.setValue("application/json", forHTTPHeaderField: "Accept")
            request.setValue("bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiIsIng1dCI6IktYMk40TkRDSTJ5NTA5NWpjTWk5TllqY2lyZyIsImtpZCI6IktYMk40TkRDSTJ5NTA5NWpjTWk5TllqY2lyZyJ9.eyJpc3MiOiJodHRwczovL2x1ZHkuZ2FtZS5vbnN0b3ZlLmNvbSIsImF1ZCI6Imh0dHBzOi8vbHVkeS5nYW1lLm9uc3RvdmUuY29tL3Jlc291cmNlcyIsImNsaWVudF9pZCI6IjEwMDAwMDAwMDAyOTM2NDEifQ.C0xcwnZTK3MwikcL9Q9zAu4wHZnKxNJgo2f3zVnR27e2gXiVvqnLVEUvj2Ns2Mj3-XNKj9F0ume1pU_EZhGFQWz6KBnHmj3dOeROn28cC21wWBWrrwnaO8ANoE5rVhBzfBaIzb_QsXTBhCEM5lPStnjbE8fVS4ihRZTOi0LLTZfgpVe0Z3zYOL5MOfDXksr2vRgMeH00USOKBeU--bgwU-hwcadcuuYngoGLOsX0zKhow8Hxdecrd4d2_svM_Wd7ju1URsL9ne88LKOemHh_VxrDzQzzGByDlPc95q3-ceBSiT0b_ICWb7leMOMkURAhsoK5J3gV4k7SaEKmdVbmcw", forHTTPHeaderField: "Authorization")

            let session = URLSession.shared
            let dataTask = session.dataTask(with: request) { data, response, error in
                if let error = error {
                    // 네트워크 에러 처리
                    print("Network Error:", error)
                    return
                }

                guard let data = data, let response = response as? HTTPURLResponse else {
                    // 데이터나 응답이 없을 경우 처리
                    print("No Data or Response")
                    return
                }

                if (200..<300).contains(response.statusCode) {
                    // JSON 데이터를 "null"을 "nil"로 대체하여 전처리
                    if let processedData = self.preprocessJSONData(data) {
                        let decoder = JSONDecoder()
                        do {
                            let characterProfiles = try decoder.decode(CharacterProfiles.self, from: processedData)
                            
                            // 성공적으로 디코딩된 데이터 처리
                            if let imageUrlString = characterProfiles.CharacterImage,
                               let imageUrl = URL(string: imageUrlString),
                               let imageData = try? Data(contentsOf: imageUrl),
                               let image = UIImage(data: imageData) {
                                DispatchQueue.main.async {
                                    self.characterImage.image = image
                                    self.classLabel.text = "직업: " + (characterProfiles.CharacterClassName ?? "")
                                    self.nameLabel.text = "캐릭터 명: " + (characterProfiles.CharacterName ?? "")
                                    self.levelLabel.text = "아이템 레벨: " + (characterProfiles.ItemAvgLevel ?? "")
                                    
                                }
                            }
                            
                            self.characterSetting?.charClass = characterProfiles.CharacterClassName ?? ""
                            self.characterSetting?.charLevel = characterProfiles.ItemAvgLevel ?? ""
                            self.characterSetting?.charName = characterProfiles.CharacterName ?? ""
                            
                        } catch {
                            // 디코딩 에러 처리
                            print("Decoding Error:", error)
                            
                            // JSON 데이터 확인
                            if let jsonString = String(data: data, encoding: .utf8) {
                                print("JSON Data:", jsonString)
                            }
                            
                        }
                    } else {
                        print("Failed to preprocess JSON data.")
                    }
                } else {
                    
                    // 서버 에러 처리
                    print("Server Error:", response.statusCode)
                    if let errorMessage = try? JSONDecoder().decode(ErrorResponse.self, from: data) {
                        print("Error Message:", errorMessage)
                    }
                    
                    // JSON 데이터 확인
                    if let jsonString = String(data: data, encoding: .utf8) {
                        print("JSON Data:", jsonString)
                    }
                }
            }
            dataTask.resume()
        }
    }

    // "null"을 "nil"로 대체하여 JSON 데이터를 전처리
    func preprocessJSONData(_ data: Data) -> Data? {
        do {
            let jsonObject = try JSONSerialization.jsonObject(with: data, options: [])
            
            if var processedObject = preprocessJSONObject(jsonObject) {
                return try JSONSerialization.data(withJSONObject: processedObject)
            } else {
                return nil
            }
        } catch {
            print("JSON Preprocessing Error:", error)
            return nil
        }
    }

    // JSON 오브젝트를 재귀적으로 탐색하며 "null"을 "nil"로 대체
    func preprocessJSONObject(_ jsonObject: Any) -> Any? {
        if let array = jsonObject as? [Any] {
            return array.map { preprocessJSONObject($0) ?? NSNull() }
        } else if let dictionary = jsonObject as? [String: Any] {
            var processedDictionary = [String: Any]()
            dictionary.forEach { key, value in
                if let processedValue = preprocessJSONObject(value) {
                    processedDictionary[key] = processedValue
                }
            }
            return processedDictionary
        } else if jsonObject is NSNull {
            return nil
        } else {
            return jsonObject
        }
    }

    //  MARK: - ViewDidLoad()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(scrollView)
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        scrollView.addSubview(contentView)
        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalTo(view)
            make.height.greaterThanOrEqualToSuperview()
        }
        
        //scrollViewSetup()
        setupUI()

        
        // CharacterUpdated 노티피케이션을 수신하고, 데이터를 업데이트하는 메서드를 등록합니다.
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleCharacterUpdatedNotification(_:)),
            name: Notification.Name("CharacterUpdated"),
            object: nil
        )
        //updateUI()
        
        loadDataFromFireStore()
        
        if let characterName = characterSetting?.charName{
            if let encodingName = characterName.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) {
                getProfiles(characterName: encodingName)
            } else {
                return
            }
        }
    }
    
    
    
    //  MARK: - setupUI
    func setupUI() {
        self.createCharInfo()

        var topAnchor: ConstraintRelatableTarget = levelLabel.snp.bottom // 최상단 버튼의 topAnchor를 변경

        if let dailySection = createDailySection() {
            topAnchor = dailySection.snp.bottom // 최상단 버튼의 topAnchor를 변경
        }

        if let raidSection = createRaidSection(topAnchor: topAnchor) {
            topAnchor = raidSection.snp.bottom // 최상단 버튼의 topAnchor를 변경
        }

        if let abyssSection = createAbyssSection(topAnchor: topAnchor) {
            topAnchor = abyssSection.snp.bottom // 최상단 버튼의 topAnchor를 변경
            createEditButton(topAnchor: topAnchor)
            createDeleteButton(topAnchor: topAnchor)
        }

        // contentView의 크기를 설정합니다.
        contentView.snp.remakeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalTo(view)
            make.bottom.equalTo(deleteButton.snp.bottom).offset(20) // contentView의 하단을 삭제 버튼의 하단으로 설정.
        }

        // scrollView의 contentSize를 contentView의 크기와 동일하게
        scrollView.contentSize = contentView.bounds.size
        scrollView.contentInset = ConstraintInsets(top: 0, left: 0, bottom: 0, right: 0)
        //print("setupUI에서 스크롤뷰의 컨텐트 사이즈: \(scrollView.contentSize)")
        
    }


    // MARK: - Firebase/Firestore
    let db = Firestore.firestore()
    
    var toDoInfo = CharacterToDoInfo(
        characterName: "",
        isGuardianRaidDone: false,
        isChaosDungeonDone: false,
        isAbyssDungeonDone: false,
        isAbyssRaidDone: false,
        isValtanRaidDone: false,
        isViaKissRaidDone: false,
        isKoukusatonRaidDone: false,
        isAbrelshudRaidDone: false,
        isIliakanRaidDone: false,
        isKamenRaidDone: false,
        isAbyssDungeonName: ""
    )
    
    // MARK: 데이터를 Firestore에 저장하는 메서드
    func saveDataToFireStore() {
        guard let characterName = characterSetting?.charName else { return }
        
        let dataToUpdateAndSave: [String: Any] = [
            "charName": characterSetting?.charName ?? "",
            "charLevel": characterSetting?.charLevel ?? "",
            "charClass": characterSetting?.charClass ?? "",
            "isChaosDungeonDone": toDoInfo.isChaosDungeonDone,
            "isGuardianRaidDone": toDoInfo.isGuardianRaidDone,
            "isAbyssDungeonDone": toDoInfo.isAbyssDungeonDone,
            "isAbyssDungeonName": characterSetting?.isAbyssDungeonName ?? "",
            "isAbyssRaidDone": toDoInfo.isAbyssRaidDone,
            "isValtanRaidDone": toDoInfo.isValtanRaidDone,
            "isViaKissRaidDone": toDoInfo.isViaKissRaidDone,
            "isKoukusatonRaidDone": toDoInfo.isKoukusatonRaidDone,
            "isAbrelshudRaidDone": toDoInfo.isAbrelshudRaidDone,
            "isIliakanRaidDone": toDoInfo.isIliakanRaidDone,
            "isKamenRaidDone": toDoInfo.isKamenRaidDone
        ]
        
        let characterCollection = db.collection("characters")
        let documentRef = characterCollection.document(characterName)
        
        documentRef.getDocument{ (document, error) in
            if let document = document, document.exists {
                // characterName이 같은 문서가 있는지 확인 후 업데이트
                documentRef.setData(dataToUpdateAndSave) { error in
                    if let error {
                        print("Error updating document: \(error)")
                    } else {
                        print("Document updated successfully!")
                    }
                }
            } else {
                // 해당 캐릭터 이름을 가진 문서가 존재하지 않는 경우 생성
                documentRef.setData(dataToUpdateAndSave) { error in
                    if let error = error {
                        print("Error adding document: \(error)")
                    } else {
                        print("Document added successfully!")
                    }
                }
            }
        }
    }
    
    // MARK: 데이터를 가져오는 메서드
    func loadDataFromFireStore() {
        // firestore 콜렉션 레퍼런스 생성
        let characterCollection = db.collection("characters")
        
        // 특정 캐릭터 데이터 가져오기
        let characterID = characterSetting?.charName ?? ""
        characterCollection.document(characterID).getDocument { (snapshot, error) in
            if let error = error {
                print("Error fetching document: \(error)")
                return
            }
            guard let document = snapshot else {
                print("Document does not exist")
                return
            }
            if document.exists {
                // Document 데이터를 파싱하고 활용
                if let data = document.data() {
                    // Firestore 데이터를 사용하는 코드
                    self.toDoInfo.isChaosDungeonDone = data["isChaosDungeonDone"] as? Bool ?? false
                    self.toDoInfo.isGuardianRaidDone = data["isGuardianRaidDone"] as? Bool ?? false
                    self.toDoInfo.isValtanRaidDone = data["isValtanRaidDone"] as? Bool ?? false
                    self.toDoInfo.isViaKissRaidDone = data["isViaKissRaidDone"] as? Bool ?? false
                    self.toDoInfo.isKoukusatonRaidDone = data["isKoukusatonRaidDone"] as? Bool ?? false
                    self.toDoInfo.isAbrelshudRaidDone = data["isAbrelshudRaidDone"] as? Bool ?? false
                    self.toDoInfo.isIliakanRaidDone = data["isIliakanRaidDone"] as? Bool ?? false
                    self.toDoInfo.isKamenRaidDone = data["isKamenRaidDone"] as? Bool ?? false
                    self.toDoInfo.isAbyssRaidDone = data["isAbyssRaidDone"] as? Bool ?? false
                    self.toDoInfo.isAbyssDungeonDone = data["isAbyssDungeonDone"] as? Bool ?? false
                    self.toDoInfo.isAbyssDungeonName = data["isAbyssDungeonName"] as? String ?? ""
                    
                    self.setButtonStates()
                }
            } else {
                print("Document does not exist")
            }
        }
    }
    
    // MARK: firestore 데이터를 초기값으로 수정
    func updateFirestoreDataWithInitialValues(character: CharacterSetting) {
        guard let characterName = characterSetting?.charName else { return }
        
        let dataToUpdate: [String: Any] = [
            "charName": characterSetting?.charName ?? "",
            "charLevel": characterSetting?.charLevel ?? "",
            "charClass": characterSetting?.charClass ?? "",
            "isChaosDungeonDone": toDoInfo.isChaosDungeonDone,
            "isGuardianRaidDone": toDoInfo.isGuardianRaidDone,
            "isAbyssDungeonDone": toDoInfo.isAbyssDungeonDone,
            "isAbyssDungeonName": characterSetting?.isAbyssDungeonName ?? "",
            "isAbyssRaidDone": toDoInfo.isAbyssRaidDone,
            "isValtanRaidDone": toDoInfo.isValtanRaidDone,
            "isViaKissRaidDone": toDoInfo.isViaKissRaidDone,
            "isKoukusatonRaidDone": toDoInfo.isKoukusatonRaidDone,
            "isAbrelshudRaidDone": toDoInfo.isAbrelshudRaidDone,
            "isIliakanRaidDone": toDoInfo.isIliakanRaidDone,
            "isKamenRaidDone": toDoInfo.isKamenRaidDone
        ]
        
        let characterCollection = db.collection("characters")
        let documentRef = characterCollection.document(characterName)
        
        documentRef.updateData(dataToUpdate) { error in
            if let error = error {
                print("Error updating document: \(error)")
            } else {
                print("Document updated successfully!")
            }
        }
    }

    
    // MARK: - 버튼 상태 변경
    func setButtonStates() {
        chaosDunButton.isSelected = toDoInfo.isChaosDungeonDone
        updateButtonAppearence(button: chaosDunButton, isChecked: toDoInfo.isChaosDungeonDone)
        guardianRaidButton.isSelected = toDoInfo.isGuardianRaidDone
        updateButtonAppearence(button: guardianRaidButton, isChecked: toDoInfo.isGuardianRaidDone)
        
        valtanButton.isSelected = toDoInfo.isValtanRaidDone
        updateButtonAppearence(button: valtanButton, isChecked: toDoInfo.isValtanRaidDone)
        viakissButton.isSelected = toDoInfo.isViaKissRaidDone
        updateButtonAppearence(button: viakissButton, isChecked: toDoInfo.isViaKissRaidDone)
        koukuButton.isSelected = toDoInfo.isKoukusatonRaidDone
        updateButtonAppearence(button: koukuButton, isChecked: toDoInfo.isKoukusatonRaidDone)
        abrelButton.isSelected = toDoInfo.isAbrelshudRaidDone
        updateButtonAppearence(button: abrelButton, isChecked: toDoInfo.isAbrelshudRaidDone)
        lilakanButton.isSelected = toDoInfo.isIliakanRaidDone
        updateButtonAppearence(button: lilakanButton, isChecked: toDoInfo.isIliakanRaidDone)
        kamenButtonn.isSelected = toDoInfo.isKamenRaidDone
        updateButtonAppearence(button: kamenButtonn, isChecked: toDoInfo.isKamenRaidDone)
        
        abyssRaidButton.isSelected = toDoInfo.isAbyssRaidDone
        updateButtonAppearence(button: abyssRaidButton, isChecked: toDoInfo.isAbyssRaidDone)
        abyssDunButton.isSelected = toDoInfo.isAbyssDungeonDone
        updateButtonAppearence(button: abyssDunButton, isChecked: toDoInfo.isAbyssDungeonDone)
    }
    
    // MARK: - 섹션 구분 밑줄
    func drawUnderLine(destination: UILabel) ->UIView {
        let underLine = UIView()
        view.addSubview(underLine)
        contentView.addSubview(underLine)
        underLine.backgroundColor = .white
        
        underLine.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(20)
            make.top.equalTo(destination.snp.bottom).offset(5)
            make.height.equalTo(1)
        }
        underLines.append(underLine)
        
        return underLine
    }
    
    //  MARK: - 기본 정보 라벨의 초기값 설정
    func labelDefaults() {
        var labels: [UILabel] = []
        labels = [dailyNoticeLabel, raidNoticeLabel,abyssNoticeLabel]
        //labels = [nameLabel, classLabel, levelLabel, dailyNoticeLabel, raidNoticeLabel,abyssNoticeLabel]
        
        labels.forEach { label in
            label.layer.borderWidth = 1.0
            label.layer.borderColor = UIColor.gray.withAlphaComponent(0.8).cgColor
            label.layer.cornerRadius = 5.0
            label.textAlignment = .center
        }
    }
    
    // MARK: - 버튼의 초기값 설정
    func createButtons(title: String, selector: Selector, isChecked: Bool, topAnchor: ConstraintRelatableTarget) -> UIButton {
        let button = UIButton()
        button.setTitle(title, for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .gray
        button.addTarget(self, action:selector, for: .touchUpInside)
        scrollView.addSubview(button)
        contentView.addSubview(button)
        
        button.snp.makeConstraints { make in
            make.top.equalTo(topAnchor).offset(20)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(50)
        }
        
        //버튼 상태 관리를 위해 인스턴스 변수 선언 후 관리
        switch title {
        case "카오스 던전":
            chaosDunButton = button
        case "가디언 토벌":
            guardianRaidButton = button
        case "군단장 발탄":
            valtanButton = button
        case "군단장 비아키스":
            viakissButton = button
        case "군단장 쿠크세이튼":
            koukuButton = button
        case "군단장 아브렐슈드":
            abrelButton = button
        case "군단장 일리아칸":
            lilakanButton = button
        case "군단장 카멘":
            kamenButtonn = button
        case "어비스 레이드: 아르고스":
            abyssRaidButton = button
        case characterSetting?.isAbyssDungeonName:
            abyssDunButton = button
            
        default:
            break
        }
        
        return button
    }
    
    //  MARK: - 캐릭터 정보 이름, 직업, 레벨의 라벨 그리기
    func createCharInfo() {
        labelDefaults()

        nameLabel.text = "캐릭터 명: " + (characterSetting?.charName ?? "")
        levelLabel.text = "아이템 레벨: " + (characterSetting?.charLevel ?? "")
        classLabel.text = "직업: " + (characterSetting?.charClass ?? "")

        view.addSubview(characterImage)
        scrollView.addSubview(characterImage)

        characterImage.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(10)
            make.leading.equalToSuperview().offset(10)
            make.trailing.equalToSuperview().offset(-10)
            make.height.equalTo(characterImage.snp.width).multipliedBy(1.5) // 이미지의 가로 너비에 대해 세로 높이를 1.5 배로 설정
        }
        characterImage.layer.borderWidth = 1.0
        characterImage.layer.borderColor = UIColor.gray.withAlphaComponent(0.8).cgColor
        characterImage.layer.cornerRadius = 5.0

        view.addSubview(classLabel)
        scrollView.addSubview(classLabel)

        classLabel.snp.makeConstraints { make in
            make.top.equalTo(characterImage.snp.bottom).offset(10)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
        }

        view.addSubview(nameLabel)
        scrollView.addSubview(nameLabel)

        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(classLabel.snp.bottom).offset(5)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
        }

        view.addSubview(levelLabel)
        scrollView.addSubview(levelLabel)

        levelLabel.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(5)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
        }
    }
    
    //  MARK: - 일일 컨텐츠 생성
    func createDailySection() -> UIView? {
        view.addSubview(dailySectionLabel)
        scrollView.addSubview(dailySectionLabel)
        
        dailySectionLabel.text = "일일 컨텐츠"
        dailySectionLabel.snp.makeConstraints { make in
            make.top.equalTo(levelLabel.snp.bottom).offset(30)
            make.leading.equalToSuperview().offset(20)
            make.width.equalTo(150)
            make.height.equalTo(30)
        }
        drawUnderLine(destination: dailySectionLabel)
        
        struct dailyButtonData {
            let title: String
            let selector: Selector
            var isChecked: Bool
        }
    
        var dailyBtnData = [
            dailyButtonData(title: "카오스 던전", selector: #selector(dailyButtonTapped), isChecked: characterSetting?.isChaosDungeonCheck ?? false),
            dailyButtonData(title: "가디언 토벌", selector: #selector(dailyButtonTapped), isChecked: characterSetting?.isGuardianRaidCheck ?? false)
        ]
        
        //마지막 버튼을 저장하는 변수
        var lastBtn: UIView?
        var topAnchor = dailySectionLabel.snp.bottom
        var buttons: [UIButton] = []
        
        //  일일컨텐츠를 하나라도 설정하지 않았을 시 다른 레이아웃을 호출하기 위해
        var isCheckedCount = 0
        
        for data in dailyBtnData {
            if data.isChecked {
                let button = createButtons(title: data.title, selector: data.selector, isChecked: data.isChecked, topAnchor: topAnchor)
                isCheckedCount += 1
                topAnchor = button.snp.bottom
                button.accessibilityIdentifier = data.title
                lastBtn = button
                buttons.append(button)
            }
        }
        
        if isCheckedCount == 0 {
            labelDefaults()
            dailyNoticeLabel.text = "일일 컨텐츠 없음"
            scrollView.addSubview(dailyNoticeLabel)
            contentView.addSubview(dailyNoticeLabel)
            
            dailyNoticeLabel.snp.makeConstraints{ make in
                make.top.equalTo(topAnchor).offset(20)
                make.leading.trailing.equalToSuperview().inset(20)
                make.height.equalTo(50)
            }
            lastBtn = dailyNoticeLabel
        }
        
        for button in buttons {
            button.isSelected = false
        }
        
        return lastBtn
    }

    //  MARK: - 레이드 버튼 생성
    func createRaidSection(topAnchor: ConstraintRelatableTarget) -> UIView? {
        view.addSubview(raidSectionLabel)
        scrollView.addSubview(raidSectionLabel)
        
        drawUnderLine(destination: raidSectionLabel)
        
        raidSectionLabel.text = "군단장 토벌"
        raidSectionLabel.snp.makeConstraints { make in
            make.top.equalTo(topAnchor).offset(20)
            make.leading.equalToSuperview().offset(20)
            make.width.equalTo(150)
            make.height.equalTo(30)
        }
        
        // 튜플의 데이터가 많아져서 구조체로 변경
        struct CommenderButtonData {
            let title: String
            let selector: Selector
            var isChecked: Bool
        }
        
        var commendersBtnData = [
            CommenderButtonData(title: "군단장 발탄", selector: #selector(commendersRaidButtonTapped), isChecked: characterSetting?.isValtanRaidCheck ?? false),
            CommenderButtonData(title: "군단장 비아키스", selector: #selector(commendersRaidButtonTapped), isChecked: characterSetting?.isViaKissRaidCheck ?? false),
            CommenderButtonData(title: "군단장 쿠크세이튼", selector: #selector(commendersRaidButtonTapped), isChecked: characterSetting?.isKoukusatonCheck ?? false),
            CommenderButtonData(title: "군단장 아브렐슈드", selector: #selector(commendersRaidButtonTapped), isChecked: characterSetting?.isAbrelshudRaidCheck ?? false),
            CommenderButtonData(title: "군단장 일리아칸", selector: #selector(commendersRaidButtonTapped), isChecked: characterSetting?.isIliakanRaidCheck ?? false),
            CommenderButtonData(title: "군단장 카멘", selector: #selector(commendersRaidButtonTapped), isChecked: characterSetting?.isKamenRaidCheck ?? false),
        ]
        
        // 버튼 레이아웃의 기준값을 잡아주는 변수
        var topAnchor = raidSectionLabel.snp.bottom
        //마지막 버튼을 저장하는 변수
        var lastBtn: UIView?
        var buttons: [UIButton] = []
        
        var isCheckedCount = 0
        
        for data in commendersBtnData {
            if data.isChecked {
                let button = createButtons(title: data.title, selector: data.selector, isChecked: data.isChecked, topAnchor: topAnchor)
                isCheckedCount += 1
                topAnchor = button.snp.bottom
                button.accessibilityIdentifier = data.title
                lastBtn = button
                buttons.append(button)
            }
        }
        
        if isCheckedCount == 0 {
            labelDefaults()
            raidNoticeLabel.text = "선택한 군단장 토벌 없음"
            scrollView.addSubview(raidNoticeLabel)
            contentView.addSubview(raidNoticeLabel)
            
            raidNoticeLabel.snp.makeConstraints{ make in
                make.top.equalTo(topAnchor).offset(20)
                make.leading.trailing.equalToSuperview().inset(20)
                make.height.equalTo(50)
            }
            lastBtn = raidNoticeLabel
        }
        
        for button in buttons {
            button.isSelected = false
        }
        
        return lastBtn
    }
    
    // MARK: - 어비스 버튼 생성
    func createAbyssSection(topAnchor: ConstraintRelatableTarget) -> UIView? {
        view.addSubview(abyssSectionLabel)
        scrollView.addSubview(abyssSectionLabel)
        
        drawUnderLine(destination: abyssSectionLabel)
        
        abyssSectionLabel.text = "어비스 컨텐츠"
        abyssSectionLabel.snp.makeConstraints { make in
            make.top.equalTo(topAnchor).offset(20)
            make.leading.equalToSuperview().offset(20)
            make.width.equalTo(150)
            make.height.equalTo(30)
        }
        
        struct abyssButtonData {
            let title: String
            let selector: Selector
            var isChecked: Bool
        }
        let abyssBtnData: [abyssButtonData]
        
        if let abyssDungeonName = characterSetting?.isAbyssDungeonName, abyssDungeonName != "--선택안함--" {
            abyssBtnData = [
                abyssButtonData(title: "어비스 레이드: 아르고스", selector: #selector(abyssContentButtonTapped), isChecked: characterSetting?.isAbyssRaidCheck ?? false),
                abyssButtonData(title: characterSetting?.isAbyssDungeonName ?? "", selector: #selector(abyssContentButtonTapped), isChecked: characterSetting?.isAbyssDungeonCheck ?? false)
            ]
        } else {
            abyssBtnData = [
                abyssButtonData(title: "어비스 레이드: 아르고스", selector: #selector(abyssContentButtonTapped), isChecked: characterSetting?.isAbyssRaidCheck ?? false)
            ]
        }
        
        var topAnchor = abyssSectionLabel.snp.bottom
        var lastBtn: UIView?
        var buttons: [UIButton] = []
        var isCheckedCount = 0
        
        for data in abyssBtnData {
            if data.isChecked {
                let button = createButtons(title: data.title, selector: data.selector, isChecked: data.isChecked, topAnchor: topAnchor)
                topAnchor = button.snp.bottom
                isCheckedCount += 1
                button.accessibilityIdentifier = data.title
                lastBtn = button
                buttons.append(button)
            }
        }
        
        if isCheckedCount == 0 {
            labelDefaults()
            abyssNoticeLabel.text = "선택한 어비스 컨텐츠 없음"
            scrollView.addSubview(abyssNoticeLabel)
            contentView.addSubview(abyssNoticeLabel)
            
            abyssNoticeLabel.snp.makeConstraints{ make in
                make.top.equalTo(topAnchor).offset(20)
                make.leading.trailing.equalToSuperview().inset(20)
                make.height.equalTo(50)
            }
            lastBtn = abyssNoticeLabel
        }
        
        for button in buttons {
            button.isSelected = false
        }
        
        return lastBtn
    }
    
    // MARK: - 버튼 objc
    // MARK: 버튼 외형 변경(위의 기본값과 다름 -> 버튼 작동을 보여주는 것)
    func updateButtonAppearence(button: UIButton, isChecked: Bool) {
        button.isSelected = isChecked
        if isChecked {
            button.alpha = 0.6
            button.setTitle(button.accessibilityIdentifier?.appending(" 완료"), for: .normal)
        } else {
            button.alpha = 1.0
            button.setTitle(button.accessibilityIdentifier, for: .normal)
        }
    }
    
    
    // MARK: 일일컨텐츠 버튼 작동
    @objc func dailyButtonTapped(_ sender: UIButton) {
        sender.isSelected.toggle()
        updateButtonAppearence(button: sender, isChecked: sender.isSelected)
        
        if let identifier = sender.accessibilityIdentifier {
            switch identifier {
            case "카오스 던전":
                toDoInfo.isChaosDungeonDone = sender.isSelected
            case "가디언 토벌":
                toDoInfo.isGuardianRaidDone = sender.isSelected
            default:
                break
            }
        }
        saveDataToFireStore()
        //print("버튼이 눌렸을때의 toDoInfo: ",toDoInfo)
    
    }
    
    // MARK: 군단장 컨텐츠 버튼 작동
    @objc func commendersRaidButtonTapped(_ sender: UIButton) {
        sender.isSelected.toggle()
        updateButtonAppearence(button: sender, isChecked: sender.isSelected)

        if let identifier = sender.accessibilityIdentifier {
            switch identifier {
            case "군단장 발탄":
                toDoInfo.isValtanRaidDone = sender.isSelected
            case "군단장 비아키스":
                toDoInfo.isViaKissRaidDone = sender.isSelected
            case "군단장 쿠크세이튼":
                toDoInfo.isKoukusatonRaidDone = sender.isSelected
            case "군단장 아브렐슈드":
                toDoInfo.isAbrelshudRaidDone = sender.isSelected
            case "군단장 일리아칸":
                toDoInfo.isIliakanRaidDone = sender.isSelected
            case "군단장 카멘":
                toDoInfo.isKamenRaidDone = sender.isSelected
            default:
                break
            }
        }
        saveDataToFireStore()
        //print("버튼이 눌렸을때의 toDoInfo: ",toDoInfo)
    }
    
    // MARK: 어비스 컨텐츠 버튼 작동
    @objc func abyssContentButtonTapped(_ sender: UIButton) {
        sender.isSelected.toggle()
        updateButtonAppearence(button: sender, isChecked: sender.isSelected)
        
        if let identifier = sender.accessibilityIdentifier {
            switch identifier {
            case "어비스 레이드: 아르고스":
                toDoInfo.isAbyssRaidDone = sender.isSelected
            case characterSetting?.isAbyssDungeonName:
                toDoInfo.isAbyssDungeonDone = sender.isSelected
            default:
                break
            }
        }
        saveDataToFireStore()
        //print("버튼이 눌렸을때의 toDoInfo: ",toDoInfo)
    }
    
    //  MARK: - 삭제 버튼
    func createDeleteButton(topAnchor: ConstraintRelatableTarget) -> UIView {
        
        view.addSubview(deleteButton)
        scrollView.addSubview(deleteButton)
        
        var lastBtn: UIView?
        
        deleteButton.snp.makeConstraints { make in
            make.top.equalTo(topAnchor).offset(20)
            make.leading.equalToSuperview().offset(80)
            make.width.equalTo(100)
            make.height.equalTo(30)
        }
        deleteButton.setTitle("삭제", for: .normal)
        deleteButton.setTitleColor(.white, for: .normal)
        deleteButton.backgroundColor = .red
        deleteButton.layer.cornerRadius = 10
        deleteButton.layer.borderColor = UIColor.gray.cgColor
        deleteButton.layer.borderWidth = 3
        deleteButton.addTarget(self, action: #selector(deleteButtonTapped), for: .touchUpInside)
        
        return deleteButton
    }
    
    @objc func deleteButtonTapped() {
        // firestore 에서 삭제
        guard let characterName = characterSetting?.charName else { return }
        
        let characterCollection = db.collection("characters")
        let documentRef = characterCollection.document(characterName)
        
        documentRef.delete { error in
            if let error = error {
                print("Error deleting document: \(error)")
            } else {
                print("Document deleted successfully!")
            }
        }
        // CharacterMainViewController에 CharacterSetting을 삭제한 것을 알리기 위해 노티피케이션 전송
        guard let characterSetting = characterSetting else { return }
        NotificationCenter.default.post(name: Notification.Name("CharacterDeleted"), object: characterSetting)
        self.navigationController?.popViewController(animated: true)
    }
    
    //  MARK: - 수정 버튼
    func createEditButton(topAnchor: ConstraintRelatableTarget) -> UIView {
        view.addSubview(editButton)
        scrollView.addSubview(editButton)
        
        var lastBtn: UIView?
        
        editButton.snp.makeConstraints { make in
            make.top.equalTo(topAnchor).offset(20)
            make.trailing.equalToSuperview().inset(80)
            make.width.equalTo(100)
            make.height.equalTo(30)
        }
        editButton.setTitle("수정", for: .normal)
        editButton.setTitleColor(.white, for: .normal)
        editButton.backgroundColor = .blue
        editButton.layer.cornerRadius = 10
        editButton.layer.borderColor = UIColor.gray.cgColor
        editButton.layer.borderWidth = 3
        editButton.addTarget(self, action: #selector(editButtonTapped), for: .touchUpInside)
        
        return editButton
    }
    
    @objc func editButtonTapped() {
        
        if let selectedCharacter = characterSetting {
            updateFirestoreDataWithInitialValues(character: selectedCharacter)
            let notification = Notification(name: Notification.Name("EditCharacter"), object: selectedCharacter)
            handleEditCharacterNotification(notification)
        }
    }

    // EditCharacter라는 이름의 Notification을 처리하는 메서드
    func handleEditCharacterNotification(_ notification: Notification) {
        guard let selectedCharacter = notification.object as? CharacterSetting else { return }
        
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            guard let settingViewController = storyboard.instantiateViewController(withIdentifier: "CharacterSettingViewController") as? CharacterSettingViewController else { return }
            
            settingViewController.characterSetting = selectedCharacter
            settingViewController.editMode = true
            //self.navigationController?.pushViewController(settingViewController, animated: true)
            self.navigationController?.show(settingViewController, sender: self)
        }
    }
    
    // MARK: - CharacterUpdated 노티피케이션 처리
        
    @objc func handleCharacterUpdatedNotification(_ notification: Notification) {
        print("handleCharacterUpdatedNotification called")
        if let updatedCharacter = notification.object as? CharacterSetting {
            // 노티피케이션으로 전달된 수정된 데이터를 반영하여 화면을 업데이트합니다.
            self.characterSetting = updatedCharacter
            updateUI()
        }
    }
    
    //  MARK: - updateUI
    func updateUI() {
        print("updateUI Called")
        print("Delete Before Views..")
        for subview in contentView.subviews {
            subview.removeFromSuperview()
        }
        print("re Generate UI..")
        self.createCharInfo()

        var topAnchor: ConstraintRelatableTarget = levelLabel.snp.bottom // 최상단 버튼의 topAnchor를 변경

        if let dailySection = createDailySection() {
            topAnchor = dailySection.snp.bottom // 최상단 버튼의 topAnchor를 변경
        }

        if let raidSection = createRaidSection(topAnchor: topAnchor) {
            topAnchor = raidSection.snp.bottom // 최상단 버튼의 topAnchor를 변경
        }

        if let abyssSection = createAbyssSection(topAnchor: topAnchor) {
            topAnchor = abyssSection.snp.bottom // 최상단 버튼의 topAnchor를 변경
            createEditButton(topAnchor: topAnchor)
            createDeleteButton(topAnchor: topAnchor)
        }

        // contentView의 크기를 설정합니다.
        contentView.snp.remakeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalTo(view)
            make.bottom.equalTo(deleteButton.snp.bottom).offset(20) // contentView의 하단을 삭제 버튼의 하단으로 설정.
        }

        // scrollView의 contentSize를 contentView의 크기와 동일하게
        scrollView.contentSize = contentView.bounds.size
        
        self.setButtonStates()
        
    }

    deinit {
        // 노티피케이션 관련 처리를 위해 등록된 옵저버를 해제합니다.
        NotificationCenter.default.removeObserver(self)
    }

}
