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
        self.contentView.layer.borderWidth = 1.0
        self.contentView.layer.borderColor = UIColor.black.cgColor
        //  self.levelBorderColor()
        //  캐릭터 레벨에 따른 borderColor 구현 예정
    }
    /**
    private func levelBorderColor() {
        
        var charLevel = self.levelLabel
        
        switch self.levelLabel.text {
            case Double(charLevel) >= 1620.00 :
                self.contentView.layer.borderColor = UIColor.green.cgColor
            case Double(self.levelLabel.text) < 1620.00 && self.levelLabel.text >= 1600 :
                self.contentView.layer.borderColor = UIColor.green.cgColor
            
            default:
                self.contentView.layer.borderColor = UIColor.black.cgColor
        }
    }
    */
}
