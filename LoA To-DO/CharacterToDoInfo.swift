//
//  CharacterToDoInfo.swift
//  LoA To-DO
//
//  Created by 김원기 on 2023/07/11.
//

import Foundation

struct CharacterToDoInfo: Codable,Equatable {
    //  To-Do 리스트만 체크하기 때문에 이름 직업 레벨 변수는 생략한다
    var characterName: String
    var isGuardianRaidDone: Bool //   일일 가디언 토벌 여부
    var isChaosDungeonDone: Bool //   일일 카오스 던전 여부
    var isAbyssDungeonDone: Bool //   어비스 던전 여부
    var isAbyssRaidDone: Bool //   어비스 레이드 여부
    var isValtanRaidDone: Bool //   발탄
    var isViaKissRaidDone: Bool //   비아키스
    var isKoukusatonRaidDone: Bool //   쿠크세이튼ㄴ
    var isAbrelshudRaidDone: Bool //   아브렐슈드
    var isIliakanRaidDone: Bool // 일리아칸
    var isKamenRaidDone: Bool  //  카멘
    var isAbyssDungeonName: String
}
