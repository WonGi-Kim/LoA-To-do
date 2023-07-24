//
//  CharacterMainViewController.swift
//  LoA To-DO
//
//  Created by 김원기 on 2023/05/23.
//

import UIKit

class CharacterMainViewController: UIViewController, CharacterSettingViewControllerDelgate{
    
    @IBOutlet weak var TableView: UITableView!
    
    var characterSettings: [CharacterSetting] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        TableView.delegate = self
        TableView.dataSource = self
        TableView.register(UINib(nibName: "CharacterCell", bundle: nil), forCellReuseIdentifier: "CharacterCell")
        
        loadCharacterSettings()
        TableView.reloadData()
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleCharacterDeleted(_:)), name: Notification.Name("CharacterDeleted"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleEditCharacter(_:)), name: Notification.Name("EditCharacter"), object: nil)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //TableView.reloadData()
    }
    
    @objc func handleCharacterDeleted(_ notification: Notification) {
        
        if let characterSetting = notification.object as? CharacterSetting,
           let index = characterSettings.firstIndex(of: characterSetting) {
            characterSettings.remove(at: index)
            let indexPath = IndexPath(row: index, section: 0)
            TableView.deleteRows(at: [indexPath], with: .automatic)
                
            saveCharacterSettings()
        }
    }
    
    @objc func handleEditCharacter(_ notification: Notification) {
        if let characterSetting = notification.object as? CharacterSetting {
            if let selectedIndex = TableView.indexPathForSelectedRow?.row {
                // 기존 캐릭터 수정
                characterSettings[selectedIndex] = characterSetting
                // 편집된 행만 리로드
                TableView.reloadRows(at: [IndexPath(row: selectedIndex, section: 0)], with: .automatic)
            } else {
                // 새로운 캐릭터 추가
                characterSettings.append(characterSetting)
                // 테이블 전체 리로드
                // TableView.reloadData()
            }
            saveCharacterSettings()
        }
    }

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is CharacterSettingViewController {
            //  delegate설정
            let characterSettingViewController = segue.destination as! CharacterSettingViewController
            characterSettingViewController.delegate = self
        }
        
        if segue.identifier == "DetailViewSegue",
           let characterDetailViewController = segue.destination as? CharacterDetailViewController,
           let characterSetting = sender as? CharacterSetting {
            characterDetailViewController.characterSetting = characterSetting
            
            
        }
    }
        
    func saveCharacterSettings() {
        let encoder = JSONEncoder()
        if let encodedData = try? encoder.encode(characterSettings) {
            UserDefaults.standard.set(encodedData, forKey: "CharacterSettings")
        }
    }
        
    func loadCharacterSettings() {
        guard let encodedData = UserDefaults.standard.data(forKey: "CharacterSettings"),
              let decodedData = try? JSONDecoder().decode([CharacterSetting].self, from: encodedData) else {
            return
        }
        characterSettings = decodedData
    }
    
    var characterSetting: CharacterSetting?
    var characterSettingArray = [CharacterSetting]()
    
    var charName: String = ""
    var charLevel: String = ""
    var charClass: String = ""
    
    

}

extension CharacterMainViewController {
    
    func didSelectCharacter(characterSetting: CharacterSetting) {
        
        if let selectedIndex = TableView.indexPathForSelectedRow?.row {
            characterSettings[selectedIndex] = characterSetting
        } else {
            characterSettings.append(characterSetting)
        }
        
        TableView.reloadData()
        saveCharacterSettings()
    }
}

extension CharacterMainViewController: UITableViewDelegate, UITableViewDataSource {
    
    //  테이블 뷰의 각 셀을 구성하는 메서드
    //  xib로 만든 셀을 반환하도록 구현
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CharacterCell", for: indexPath) as! CharacterCell
        
        // 기존의 cellSetting을 가져옴
        let characterSetting = characterSettings[indexPath.row]
        
        // 기존의 cell에 새로운 데이터를 반영
        cell.configure(with: characterSetting)
        
        return cell
    }

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //  테이블 뷰의 데이터 개수 반환
        
        return characterSettings.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //   셀을 선택했을 때 동작 구현
        let characterSetting = characterSettings[indexPath.row]
        tableView.deselectRow(at: indexPath, animated: true)
        performSegue(withIdentifier: "DetailViewSegue", sender: characterSetting)
        //print("didSelectRowAt",characterSettingArray)
    }
}
