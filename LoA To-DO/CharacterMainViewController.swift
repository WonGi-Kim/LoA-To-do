//
//  CharacterMainViewController.swift
//  LoA To-DO
//
//  Created by 김원기 on 2023/05/23.
//

import UIKit

class CharacterMainViewController: UIViewController {
    
    @IBOutlet weak var TableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //  func 아래 추가
        //  self.configureTableView()
        //  self.loadCharacterList()
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is CharacterSettingViewController {
            //settingViewController.delegate = self
        }
    }
}

//extension CharacterMainViewController: SettingViewController {
//}
