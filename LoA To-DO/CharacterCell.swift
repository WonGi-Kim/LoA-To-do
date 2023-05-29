//
//  CharacterCell.swift
//  LoA To-DO
//
//  Created by 김원기 on 2023/05/22.
//

import UIKit

class CharacterCell: UITableViewCell {
    //  Cell 부분은 StoryBoard에서 outlet변수 연결 후 구현
    
    //  init 설정 (캐릭터 테두리 부분)
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.contentView.layer.cornerRadius = 3.0
        self.contentView.layer.borderWidth = 1.0
        
        /*
        private func levelBorderColor() {
            switch self.levelLabel.text {
                case self.levelLabel.text >= 1620.00:
                    UIColor.green.cgColor
                case self.levelLabel.text < 1620.00 && self.levelLabel.text >= 1600.00:
                    UIColor.green.cgColor
                case self.levelLabel.text < 1620.00 && self.levelLabel.text >= 1600.00:
                    UIColor.green.cgColor
                case self.levelLabel.text < 1620.00 && self.levelLabel.text >= 1600.00:
                    UIColor.green.cgColor
                case self.levelLabel.text < 1620.00 && self.levelLabel.text >= 1600.00:
                    UIColor.green.cgColor
                default:
                UIColor.pink.cgColor
            }
        }
        **/
    }
}
