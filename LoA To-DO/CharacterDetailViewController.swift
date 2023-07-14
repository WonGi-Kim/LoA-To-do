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
                createDeleteButton(topAnchor: lastBtn.snp.bottom)
            }
        }
        
        
        
    }
    
    //MARK: - 스크롤 뷰 설정
    func scrollViewSetup() {
        view.addSubview(scrollView)

        contentView.snp.makeConstraints { make in
            make.width.equalTo(view)
        }

        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        scrollView.addSubview(contentView)
        
        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        var contentHeight: CGFloat = 20
        for subview in contentView.subviews {
            contentHeight += subview.frame.height
        }

        contentView.snp.makeConstraints { make in
            make.height.equalTo(contentHeight)
        }

        scrollView.contentSize = CGSize(width: scrollView.frame.width, height: contentHeight + 20)
        scrollView.isScrollEnabled = true
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
        labels = [nameLabel, classLabel, levelLabel]
        
        labels.forEach { label in
            label.layer.borderWidth = 1.0
            label.layer.borderColor = UIColor.gray.withAlphaComponent(0.8).cgColor
            label.layer.cornerRadius = 5.0
            label.textAlignment = .center
        }
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
    
    //  MARK: - 일일컨텐츠 그리기
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
    
        let dailyBtnData = [
            ("카오스 던전", #selector(chaosButtonTapped)),
            ("가디언 토벌", #selector(guardianButtonTapped))
        ]
        
        //마지막 버튼을 저장하는 변수
        var lastBtn: UIView?
        var topAnchor = dailySectionLabel.snp.bottom
        var buttons: [UIButton] = []
        
        for (index, data) in dailyBtnData.enumerated() {
            let button = UIButton()
            button.setTitle(data.0, for: .normal)
            button.setTitleColor(.white, for: .normal)
            button.backgroundColor = .gray
            button.addTarget(self, action: data.1, for: .touchUpInside)
            scrollView.addSubview(button)
            contentView.addSubview(button)
            
            button.snp.makeConstraints { make in
                make.top.equalTo(topAnchor).offset(20 + (60 * index))
                make.leading.trailing.equalToSuperview().inset(20)
                make.height.equalTo(50)
            }
            lastBtn = button
            buttons.append(button)
        }
        for button in buttons {
            button.isSelected = false
        }
        
        return lastBtn
    }

    //  MARK: - 레이드 버튼
    func createRaidSection(topAnchor: ConstraintRelatableTarget) -> UIView? {
        view.addSubview(raidSectionLabel)
        scrollView.addSubview(raidSectionLabel)
        
        view.addSubview(viakissButton)
        view.addSubview(koukuButton)
        view.addSubview(abrelButton)
        view.addSubview(lilakanButton)
        
        self.drawUnderLine(destination: raidSectionLabel)
        raidSectionLabel.text = "군단장 토벌"
        raidSectionLabel.snp.makeConstraints { make in
            make.top.equalTo(topAnchor).offset(20)
            make.leading.equalToSuperview().offset(20)
            make.width.equalTo(150)
            make.height.equalTo(30)
        }
        
        let commendersBtnData = [
            ("군단장 발탄", #selector(valtanBtnTapped), characterSetting?.isValtanRaidCheck ?? false),
            ("군단장 비아키스", #selector(viaBtnTapped), characterSetting?.isViaKissRaidCheck ?? false),
            ("군단장 쿠크세이튼", #selector(koukuBtnTapped), characterSetting?.isKoukusatonCheck ?? false)
        ]
        
        // 버튼 레이아웃의 기준값을 잡아주는 변수
        var buttonTopAnchor = raidSectionLabel.snp.bottom
        //마지막 버튼을 저장하는 변수
        var lastBtn: UIView?
        var buttons: [UIButton] = []
        
        for data in commendersBtnData {
            if data.2 {
                let button = UIButton()
                button.setTitle(data.0, for: .normal)
                button.setTitleColor(.white, for: .normal)
                button.backgroundColor = .gray
                button.addTarget(self, action: data.1, for: .touchUpInside)
                scrollView.addSubview(button)
                
                button.snp.makeConstraints { make in
                    make.top.equalTo(buttonTopAnchor).offset(20)
                    make.leading.trailing.equalToSuperview().inset(20)
                    make.height.equalTo(50)
                }
                buttonTopAnchor = button.snp.bottom
                lastBtn = button
                buttons.append(button)
            }
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
    
    @objc func valtanBtnTapped(_ sender: UIButton) {
        sender.isSelected.toggle()
        
        if sender.isSelected {
            sender.alpha = 0.6
            sender.setTitle("군단장 발탄 토벌 완료", for: .normal)
            isValtanRaidDone = true
        } else {
            sender.alpha = 1.0
            sender.setTitle("군단장 발탄", for: .normal)
            isValtanRaidDone = false
        }
    }
    
    @objc func viaBtnTapped(_ sender: UIButton) {
        sender.isSelected.toggle()
        
        if sender.isSelected {
            sender.alpha = 0.6
            sender.setTitle("군단장 비아키스 토벌 완료", for: .normal)
            isViaKissRaidDone = true
        } else {
            sender.alpha = 1.0
            sender.setTitle("군단장 비아키스", for: .normal)
            isViaKissRaidDone = false
        }
    }
    
    @objc func koukuBtnTapped(_ sender: UIButton) {
        sender.isSelected.toggle()
        
        if sender.isSelected {
            sender.alpha = 0.6
            sender.setTitle("군단장 쿠크세이튼 토벌 완료", for: .normal)
            isKoukusatonRaidDone = true
        } else {
            sender.alpha = 1.0
            sender.setTitle("군단장 쿠크세이튼", for: .normal)
            isKoukusatonRaidDone = false
        }
    }
    
    //  MARK: - 삭제 버튼
    func createDeleteButton(topAnchor: ConstraintRelatableTarget) {
        
        view.addSubview(deleteButton)
        scrollView.addSubview(deleteButton)
        
        var lastBtn: UIView?
        
        deleteButton.snp.makeConstraints { make in
            make.top.equalTo(topAnchor).offset(600)
            make.leading.equalToSuperview().offset(50)
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
