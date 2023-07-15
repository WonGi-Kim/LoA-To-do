//
//  CharacterDetailViewController.swift
//  LoA To-DO
//
//  Created by 김원기 on 2023/07/07.
//

import Foundation
import UIKit
import SnapKit

class CharacterDetailViewController: UIViewController {
    var characterSetting: CharacterSetting?
    var characterToDoInto: [CharacterToDoInfo] = []
    
    let scrollView = UIScrollView()
    let contentView = UIView()
    
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
    
    
    
    //  MARK: - ViewDidLoad()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(contentView)
        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        scrollViewSetup()
        self.createCharInfo()
        if let lastBtn = createDailySection() {
            if let lastBtn = createRaidSection(topAnchor: lastBtn.snp.bottom) {
                if let lastBtn = createAbyssSection(topAnchor: lastBtn.snp.bottom) {
                    createDeleteButton(topAnchor: lastBtn.snp.bottom)
                }
            }
        }
    }
    
    //MARK: - 스크롤 뷰 설정
    func scrollViewSetup() {
        view.addSubview(scrollView)

        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        scrollView.addSubview(contentView)

        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalTo(view)
        }

        // 스크롤 가능한 영역 크기 제약조건 설정
        let contentHeightConstraint = contentView.heightAnchor.constraint(greaterThanOrEqualTo: scrollView.heightAnchor)
        contentHeightConstraint.priority = .defaultLow
        contentHeightConstraint.isActive = true

        scrollView.isScrollEnabled = true
        scrollView.contentSize = CGSize(width: scrollView.frame.width, height: 0)
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
        labels = [nameLabel, classLabel, levelLabel, dailyNoticeLabel, raidNoticeLabel,abyssNoticeLabel]
        
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
        
        return button
    }
    
    //  MARK: - 캐릭터 정보 이름, 직업, 레벨의 라벨 그리기
    func createCharInfo() {
        labelDefaults()
        
        nameLabel.text = "캐릭터 명: " + (characterSetting?.charName ?? "")
        levelLabel.text = "아이템 레벨: " + (characterSetting?.charLevel ?? "")
        classLabel.text = "직업: " + (characterSetting?.charClass ?? "")
        characterImage.image = UIImage(named: (characterSetting?.charClass) ?? "")
        
        view.addSubview(nameLabel)
        scrollView.addSubview(nameLabel)
        view.addSubview(levelLabel)
        scrollView.addSubview(levelLabel)
        view.addSubview(classLabel)
        scrollView.addSubview(classLabel)
        view.addSubview(characterImage)
        scrollView.addSubview(characterImage)
        view.addSubview(editButton)
        scrollView.addSubview(editButton)
        
        classLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(10)
            make.leading.equalToSuperview().offset(20)
            make.width.equalTo(160)
            make.height.equalTo(50)
        }
        
        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(classLabel.snp.bottom).offset(10)
            make.leading.equalToSuperview().offset(20)
            make.width.equalTo(160)
            make.height.equalTo(50)
        }
        levelLabel.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(10)
            make.leading.equalToSuperview().offset(20)
            make.width.equalTo(160)
            make.height.equalTo(50)
        }
        characterImage.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(10)
            make.trailing.equalToSuperview().offset(-20)
            make.width.equalTo(160)
            make.height.equalTo(170)
        }
        characterImage.layer.borderWidth = 1.0
        characterImage.layer.borderColor = UIColor.gray.withAlphaComponent(0.8).cgColor
        characterImage.layer.cornerRadius = 5.0
        
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
            dailyButtonData(title: "카오스 던전", selector: #selector(chaosButtonTapped), isChecked: characterSetting?.isChaosDungeonCheck ?? false),
            dailyButtonData(title: "가디언 토벌", selector: #selector(guardianButtonTapped), isChecked: characterSetting?.isGuardianRaidCheck ?? false)
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
        
        let abyssBtnData = [
            abyssButtonData(title: "어비스 레이드: 아르고스", selector: #selector(abyssContentButtonTapped), isChecked: characterSetting?.isAbyssRaidCheck ?? false),
            abyssButtonData(title: characterSetting?.isAbyssDungeonName ?? "", selector: #selector(abyssContentButtonTapped), isChecked: characterSetting?.isAbyssDungeonCheck ?? false)
        ]
        
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
    @objc func chaosButtonTapped(_ sender: UIButton) {
        sender.isSelected.toggle()
        
        if sender.isSelected {
            sender.alpha = 0.6
            sender.setTitle("카오스 던전 완료", for: .normal)
            isChaosDungeonDone = true
        } else {
            sender.alpha = 1.0
            sender.setTitle("카오스 던전", for: .normal)
            isChaosDungeonDone = false
        }
    }
    
    @objc func guardianButtonTapped(_ sender: UIButton) {
        sender.isSelected.toggle()
        
        if sender.isSelected {
            sender.alpha = 0.6
            sender.setTitle("가디언 토벌 완료", for: .normal)
            isGuardianRaidDone = true
        } else {
            sender.alpha = 1.0
            sender.setTitle("가디언 토벌", for: .normal)
            isGuardianRaidDone = false
        }
    }
    
    @objc func commendersRaidButtonTapped(_ sender: UIButton) {
        sender.isSelected.toggle()
        
        if sender.isSelected {
            sender.alpha = 0.6
            sender.setTitle(sender.accessibilityIdentifier?.appending(" 토벌 완료"), for: .normal)
            if let identifier = sender.accessibilityIdentifier {
                switch identifier {
                case "군단장 발탄":
                    isValtanRaidDone = true
                case "군단장 비아키스":
                    isViaKissRaidDone = true
                case "군단장 쿠크세이튼":
                    isKoukusatonRaidDone = true
                case "군단장 아브렐슈드":
                    isAbrelshudRaidDone = true
                case "군단장 일리아칸":
                    isIliakanRaidDone = true
                case "군단장 카멘":
                    isKamenRaidDone = true
                default:
                    break
                }
            }
        } else {
            sender.alpha = 1.0
            sender.setTitle(sender.accessibilityIdentifier, for: .normal)
            if let identifier = sender.accessibilityIdentifier {
                switch identifier {
                case "군단장 발탄":
                    isValtanRaidDone = false
                case "군단장 비아키스":
                    isViaKissRaidDone = false
                case "군단장 쿠크세이튼":
                    isKoukusatonRaidDone = false
                case "군단장 아브렐슈드":
                    isAbrelshudRaidDone = false
                case "군단장 일리아칸":
                    isIliakanRaidDone = false
                case "군단장 카멘":
                    isKamenRaidDone = false
                default:
                    break
                }
            }
        }
    }
    // 어비스 컨텐츠
    @objc func abyssContentButtonTapped(_ sender: UIButton) {
        sender.isSelected.toggle()
        
        if sender.isSelected {
            sender.alpha = 0.6
            sender.setTitle((sender.accessibilityIdentifier ?? "" ) + " 클리어", for: .normal)
            if let identifier = sender.accessibilityIdentifier {
                switch identifier {
                case "어비스 레이드: 아르고스":
                    isAbyssRaidDone = true
                case characterSetting?.isAbyssDungeonName:
                    isAbyssDungeonDone = true
                default:
                    break
                }
            }
        } else {
            sender.alpha = 1.0
            sender.setTitle((sender.accessibilityIdentifier ?? ""), for: .normal)
            if let identifier = sender.accessibilityIdentifier {
                switch identifier {
                case "어비스 레이드: 아르고스":
                    isAbyssRaidDone = false
                case characterSetting?.isAbyssDungeonName:
                    isAbyssDungeonDone = false
                default:
                    break
                }
            }
        }
    }
    
    //  MARK: - 삭제 버튼
    func createDeleteButton(topAnchor: ConstraintRelatableTarget) {
        
        view.addSubview(deleteButton)
        scrollView.addSubview(deleteButton)
        
        var lastBtn: UIView?
        
        deleteButton.snp.makeConstraints { make in
            make.top.equalTo(topAnchor).offset(200)
            make.leading.equalToSuperview().offset(80)
            make.width.equalTo(100)
            make.height.equalTo(30)
        }
        deleteButton.setTitle("삭제", for: .normal)
        deleteButton.setTitleColor(.white, for: .normal)
        deleteButton.backgroundColor = .red
        deleteButton.addTarget(self, action: #selector(deleteButtonTapped), for: .touchUpInside)
    }
    
    @objc func deleteButtonTapped() {
        guard let characterSetting = characterSetting else { return }
        
        NotificationCenter.default.post(name: Notification.Name("CharacterDeleted"), object: characterSetting)
        
        self.navigationController?.popViewController(animated: true)
    }
}
