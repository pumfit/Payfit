//
//  DataStructures.swift
//  PayFit
//
//  Created by swuad_19 on 07/01/2020.
//  Copyright © 2020 swuad_19. All rights reserved.
//

import Foundation
// Functions에 UID를 보낼 때 필요한 구조체
struct TokenInfo:Encodable {
    let uid:String
}
// JMT 토큰을 받을 때 필요한 구조체 (? : 있으면 실행되고, 없으면 실행 안됨 최대한 모든 필드 다 적어라)
struct JWT:Codable {
    let error:Bool?
    let jwt:String?
    let msg:String?
    let uid:String?
}
