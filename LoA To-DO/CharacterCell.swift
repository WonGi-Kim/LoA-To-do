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
    
    func viewDidLoad() {
        self.loadClassImage()
    }
    
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
    
    func selectClassImage() {
        
    }
    
    var characterData: (name: String, level: String, playerClass: String)? {
        didSet {
            nameLabel.text = characterData?.name
            levelLabel.text = characterData?.level
            if let playerClass = characterData?.playerClass {
                classImage.image = UIImage(named: playerClass)
            }
        }
    }
    
    required init? (coder: NSCoder) {
        super.init(coder: coder)
        self.contentView.layer.borderWidth = 1.5
        self.contentView.layer.borderColor = UIColor.black.cgColor
        //  캐릭터 레벨에 따른 borderColor 구현 예정
        //self.levelBorderColor()
    }
    
    /**private func levelBorderColor() {
        
        if let charLevelText = levelLabel.text, let charLevel = Double(charLevelText) {
            if charLevel >= 1620.00 {
                self.contentView.layer.borderColor = UIColor.red.cgColor
            } else if charLevel < 1620.00 && charLevel >= 1600 {
                self.contentView.layer.borderColor = UIColor.green.cgColor
            } else {
                self.contentView.layer.borderColor = UIColor.black.cgColor
            }
        } else {
            self.contentView.layer.borderColor = UIColor.black.cgColor
        }

         guard let charLevelText = levelLabel.text else {
         self.contentView.layer.borderColor = UIColor.black.cgColor
         return
         }
         guard let charLevel = Double(charLevelText) else {
         self.contentView.layer.borderColor = UIColor.black.cgColor
         return
         }
         
         
         switch charLevel {
         case let value where value >= 1620.0:
         self.contentView.layer.borderColor = UIColor.red.cgColor
         case let value where value < 1620.0 && value >= 1600:
         self.contentView.layer.borderColor = UIColor.green.cgColor
         default:
         self.contentView.layer.borderColor = UIColor.black.cgColor
         }
         }
    }*/

}
