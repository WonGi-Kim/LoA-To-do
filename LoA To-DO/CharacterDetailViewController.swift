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
    var isKoukusatonDone: Bool = false
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
        self.createDailySection()
        self.createRaidButton()
        self.createDeleteButton()
        
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
    func createDailySection() {
        view.addSubview(dailySectionLabel)
        scrollView.addSubview(dailySectionLabel)
        view.addSubview(chaosDunButton)
        scrollView.addSubview(chaosDunButton)
        view.addSubview(guardianRaidButton)
        scrollView.addSubview(guardianRaidButton)
        
        dailySectionLabel.text = "일일 컨텐츠"
        dailySectionLabel.snp.makeConstraints{ make in
            make.top.equalTo(levelLabel.snp.bottom).offset(30)
            make.leading.equalToSuperview().offset(20)
            make.width.equalTo(150)
            make.height.equalTo(30)
        }
        self.drawUnderLine(destination: dailySectionLabel)
        
        chaosDunButton.setTitle("카오스 던전", for: .normal)
        chaosDunButton.setTitleColor(.white, for: .normal)
        chaosDunButton.backgroundColor = .gray
        chaosDunButton.addTarget(self, action: #selector(chaosButtonTapped), for: .touchUpInside)
        chaosDunButton.snp.makeConstraints{ make in
            make.top.equalTo(dailySectionLabel.snp.bottom).offset(20)
            make.leading.equalToSuperview().offset(20)
            make.width.left.right.equalToSuperview().inset(20)
            make.height.equalTo(50)
        }
        
        guardianRaidButton.setTitle("가디언 토벌", for: .normal)
        guardianRaidButton.setTitleColor(.white, for: .normal)
        guardianRaidButton.backgroundColor = .gray
        guardianRaidButton.addTarget(self, action: #selector(guardinaButtonTapped), for: .touchUpInside)
        guardianRaidButton.snp.makeConstraints{ make in
            make.top.equalTo(chaosDunButton.snp.bottom).offset(10)
            make.leading.equalToSuperview().offset(20)
            make.width.left.right.equalToSuperview().inset(20)
            make.height.equalTo(50)
        }
    }
    
    @objc func chaosButtonTapped() {
        chaosDunButton.isSelected.toggle()
        
        if chaosDunButton.isSelected {
            chaosDunButton.alpha = 0.6
            chaosDunButton.setTitle("카오스 던전 완료", for: .normal)
            isChaosDungeonDone = true
        } else {
            chaosDunButton.alpha = 1.0
            chaosDunButton.setTitle("카오스 던전", for: .normal)
            isChaosDungeonDone = false
        }
    }
    
    @objc func guardinaButtonTapped() {
        guardianRaidButton.isSelected.toggle()
        
        if guardianRaidButton.isSelected {
            guardianRaidButton.alpha = 0.6
            guardianRaidButton.setTitle("가디언 토벌 완료", for: .normal)
            isGuardianRaidDone = true
        } else {
            guardianRaidButton.alpha = 1.0
            guardianRaidButton.setTitle("가디언 토벌", for: .normal)
            isGuardianRaidDone = false
        }
    }
    
    //  MARK: - 레이드 버튼
    func createRaidButton() {
        view.addSubview(raidSectionLabel)
        scrollView.addSubview(raidSectionLabel)
        view.addSubview(valtanButton)
        scrollView.addSubview(valtanButton)
        view.addSubview(viakissButton)
        scrollView.addSubview(viakissButton)
        view.addSubview(koukuButton)
        scrollView.addSubview(koukuButton)
        view.addSubview(abrelButton)
        scrollView.addSubview(abrelButton)
        view.addSubview(lilakanButton)
        scrollView.addSubview(lilakanButton)
        
        self.drawUnderLine(destination: raidSectionLabel)
        raidSectionLabel.text = "군단장 토벌"
        raidSectionLabel.snp.makeConstraints{ make in
            make.top.equalTo(guardianRaidButton.snp.bottom).offset(20)
            make.leading.equalToSuperview().offset(20)
            make.width.equalTo(150)
            make.height.equalTo(30)
        }
        
    }
    
    //  MARK: - 삭제 버튼
    func createDeleteButton() {
        
        view.addSubview(deleteButton)
        scrollView.addSubview(deleteButton)
        
        deleteButton.snp.makeConstraints { make in
            make.top.equalTo(chaosDunButton.snp.bottom).offset(600)
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
