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
    
    var characterName: String = ""
    var characterLevel: String = ""
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    required init? (coder: NSCoder) {
        super.init(coder: coder)
        self.contentView.layer.borderWidth = 1.0
        self.contentView.layer.borderColor = UIColor.black.cgColor
        //  self.levelBorderColor()
        //  캐릭터 레벨에 따른 borderColor 구현 예정
    }
    /*
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
    **/
}
