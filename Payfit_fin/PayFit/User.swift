//
//  User.swift
//  PayFit
//
//  Created by swuad_19 on 07/01/2020.
//  Copyright © 2020 swuad_19. All rights reserved.
//

struct User:Codable {
    let name:String
    let email:String
    
    init(name:String, email:String) {
        self.name = name
        self.email = email
    }
}
