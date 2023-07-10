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
    
    var nameLabel = UILabel()
    var levelLabel = UILabel()
    var classLabel = UILabel()
    var characterImage = UIImageView()
    var chaosDunButton = UIButton()
    var guardianRaidButton = UIButton()
    var valtanButton = UIButton()
    var viakissButton = UIButton()
    var koukuButton = UIButton()
    var abrelButton = UIButton()
    var lilakanButton = UIButton()
    var kamenButtonn = UIButton()
    var editButton = UIButton()
    var deleteButton = UIButton()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        charInfo()
    }
    
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
    
    func charInfo() {
        labelDefaults()
        
        nameLabel.text = "캐릭터 명: " + (characterSetting?.charName ?? "")
        levelLabel.text = "아이템 레벨: " + (characterSetting?.charLevel ?? "")
        classLabel.text = "직업: " + (characterSetting?.charClass ?? "")
        characterImage.image = UIImage(named: (characterSetting?.charClass) ?? "")
        
        view.addSubview(nameLabel)
        view.addSubview(levelLabel)
        view.addSubview(classLabel)
        view.addSubview(characterImage)
        view.addSubview(editButton)
        view.addSubview(deleteButton)
        
        classLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(100)
            make.leading.equalToSuperview().offset(20)
            make.width.equalTo(150)
            make.height.equalTo(50)
        }
        
        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(classLabel.snp.bottom).offset(10)
            make.leading.equalToSuperview().offset(20)
            make.width.equalTo(150)
            make.height.equalTo(50)
        }
        levelLabel.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(10)
            make.leading.equalToSuperview().offset(20)
            make.width.equalTo(150)
            make.height.equalTo(50)
        }
        characterImage.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(100)
            make.trailing.equalToSuperview().offset(-20)
            make.width.equalTo(170)
            make.height.equalTo(170)
        }
        characterImage.layer.borderWidth = 1.0
        characterImage.layer.borderColor = UIColor.gray.withAlphaComponent(0.8).cgColor
        characterImage.layer.cornerRadius = 5.0
        
        deleteButton.snp.makeConstraints { make in
            make.top.equalTo(levelLabel.snp.bottom).offset(100)
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
        
        /**
        if let encodedData = UserDefaults.standard.data(forKey: "CharacterSetting"),
           var characterSettingArray = try? JSONDecoder().decode([CharacterSetting].self, from: encodedData) {
            
            if let index = characterSettingArray.firstIndex(of: characterSetting) {
                characterSettingArray.remove(at: index)
                
                // 셀 삭제
                let indexPath = IndexPath(row: index, section: 0)
                TableView.deleteRows(at: [IndexPath], with: .automatic)
            }
            
            let encoder = JSONEncoder()
            if let encodedData = try? encoder.encode(characterSettingArray) {
                UserDefaults.standard.set(encodedData, forKey: "CharacterSetting")
            }
        }*/
        
        self.navigationController?.popViewController(animated: true)
    }
    
}
