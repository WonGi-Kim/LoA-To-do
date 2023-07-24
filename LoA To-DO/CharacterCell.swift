//
//  CharacterCell.swift
//  LoA To-DO
//
//  Created by 김원기 on 2023/05/30.
//

import UIKit

class CharacterCell: UITableViewCell {
    
    @IBOutlet weak var levelLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var classImage: UIImageView!
    
    var dataArray: [String] = []
    
    var characterName: String = ""
    var characterLevel: String = ""
    
    func loadClassImage() {
        guard let plistPath = Bundle.main.path(forResource: "CharacterClass", ofType: "plist"),
              let dataArray = NSArray(contentsOfFile: plistPath) as? [NSDictionary] else { return }
        
        var classImage: [String] = []
        for item in dataArray {
            if var classImage = item["classImage"] as? String {
                classImage.append(classImage)
            }
        }
        self.dataArray = classImage
    }
    
    var characterSetting: CharacterSetting? {
        didSet{
            nameLabel.text = characterSetting?.charName
            levelLabel.text = characterSetting?.charLevel
            if let playerClass = characterSetting?.charClass {
                classImage.image = UIImage(named: playerClass)
            }
        }
    }
    
    func configure(with characterSetting: CharacterSetting) {
            nameLabel.text = characterSetting.charName
            levelLabel.text = characterSetting.charLevel
            classImage.image = UIImage(named: characterSetting.charClass)
        }
    
    required init? (coder: NSCoder) {
        super.init(coder: coder)
        self.contentView.layer.borderWidth = 1.5
        self.contentView.layer.borderColor = UIColor.black.cgColor
        //  캐릭터 레벨에 따른 borderColor 구현 예정
        //self.levelBorderColor()
    }
    
}
