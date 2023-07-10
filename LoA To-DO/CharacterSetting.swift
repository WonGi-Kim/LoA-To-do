//
//  CharacterSetting.swift
//  LoA To-DO
//
//  Created by 김원기 on 2023/05/23.
//

import Foundation

struct CharacterSetting: Codable, Equatable {
    // detailview에서 firstIndex(of:) 메서드를 사용하기 위해 Equatable프로토콜 구현
    
    var charName: String // 캐릭터 이름
    var charLevel: String   // 캐릭터 레벨
    var charClass: String   // 캐릭터 클래스
    //var isDailyEpona: Bool //   일일 에포나 여부
    var isGuardianRaidCheck: Bool //   일일 가디언 토벌 여부
    var isChaosDungeonCheck: Bool //   일일 카오스 던전 여부
    var isAbyssDungeonCheck: Bool //   어비스 던전 여부
    var isAbyssRaidCheck: Bool //   어비스 레이드 여부
    var isValtanRaidCheck: Bool //   첫번째 군단장 여부
    var isViaKissRaidCheck: Bool //   두번째 군단장 여부
    var isKoukusatonCheck: Bool //   세번째 군단장 여부
    var isAbrelshudRaidCheck: Bool //   아브렐슈드
    var isIliakanRaidCheck: Bool // 일리아칸
    var isKamenRaidCheck: Bool  //  카멘
    
}
