//
//  CharacterDetailViewController.swift
//  LoA To-DO
//
//  Created by 김원기 on 2023/07/10.
//

import Foundation
import UIKit
import SnapKit

class CharacterDetailViewController: UIViewController {
    var characterSetting: CharacterSetting?
    
    var nameLabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nameLabel.text = characterSetting?.charName
        
        view.addSubview(nameLabel)
        
        nameLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(100)
            make.centerX.equalToSuperview()
        }
    }
    
}
