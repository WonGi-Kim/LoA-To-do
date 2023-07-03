//
//  CharacterSetting.swift
//  LoA To-DO
//
//  Created by 김원기 on 2023/05/23.
//

import Foundation

struct CharacterSetting {
    
    let charName: String // 캐릭터 이름
    var charLevel: String   // 캐릭터 레벨
    var charClass: String   // 캐릭터 클래스
    //var isDailyEpona: Bool //   일일 에포나 여부
    var isGuardianRaidCheck: Bool //   일일 가디언 토벌 여부
    var isChaosDungeonCheck: Bool //   일일 카오스 던전 여부
    var isAbyssDungeonCheck: Bool //   어비스 던전 여부
    var isCommander0Check: Bool //   첫번째 군단장 여부
    var isCommander1Check: Bool //   두번째 군단장 여부
    var isCommender2Check: Bool //   세번째 군단장 여부
    
}
