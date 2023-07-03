//
//  CharacterMainViewController.swift
//  LoA To-DO
//
//  Created by 김원기 on 2023/05/23.
//

import UIKit

class CharacterMainViewController: UIViewController, CharacterSettingViewControllerDelgate {
    
    @IBOutlet weak var TableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        TableView.delegate = self
        TableView.dataSource = self
        TableView.register(UINib(nibName: "CharacterCell", bundle: nil), forCellReuseIdentifier: "CharacterCell")
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is CharacterSettingViewController {
            //  delegate설정
            let characterSettingViewController = segue.destination as! CharacterSettingViewController
            characterSettingViewController.delegate = self
        }
    }
    
    var characterSetting: CharacterSetting?
    var characterSettingArray = [CharacterSetting]()
    
    var charName: String = ""
    var charLevel: String = ""
    var charClass: String = ""


}

extension CharacterMainViewController {
    
    func didSelectCharacter(characterSetting: CharacterSetting) {
        self.characterSetting = characterSetting
        self.characterSettingArray.append(characterSetting)
        TableView.reloadData()
    }
}

extension CharacterMainViewController: UITableViewDelegate, UITableViewDataSource {
    
    //  테이블 뷰의 각 셀을 구성하는 메서드
    //  xib로 만든 셀을 반환하도록 구현
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CharacterCell", for: indexPath) as! CharacterCell
        let characterSetting = characterSettingArray[indexPath.row]
        cell.characterSetting = characterSetting
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //  테이블 뷰의 데이터 개수 반환
        
        return characterSettingArray.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //   셀을 선택했을 때 동작 구현
        print(characterSetting?.isChaosDungeonCheck)
        print(characterSetting?.isGuardianRaidCheck)
    }
}

//extension CharacterMainViewController: CharacterSettingViewController {}
