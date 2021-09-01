//
//  PayStructure.swift
//  PayFit
//
//  Created by swuad_19 on 14/01/2020.
//  Copyright © 2020 swuad_19. All rights reserved.
//

import Foundation

struct Pay:Codable {
    let title:String?
    let price:String?
    let firstdate:String?
    let dday:Int?
    let tag:String?
    let paydate:String?
}
