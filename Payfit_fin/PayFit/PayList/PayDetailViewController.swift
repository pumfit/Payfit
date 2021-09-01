//
//  PayDataViewController.swift
//  PayFit
//
//  Created by swuad_19 on 10/01/2020.
//  Copyright © 2020 swuad_19. All rights reserved.
//

import UIKit
import Kingfisher
import FirebaseUI
import FirebaseDatabase
import CodableFirebase

class PayDetailViewController: UIViewController {
    
    @IBOutlet weak var appTitle: UILabel!
    @IBOutlet weak var appPrice: UILabel!
    @IBOutlet weak var recentBuyDate: UILabel!
    
    
    var pay_data:Pay?
    
    var dbRef:DatabaseReference!
    var data:[Pay] = []
    var key = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dbRef = Database.database().reference()
        appTitle.text = pay_data?.title
        appPrice.text = "결제금액: "+(pay_data?.price ?? "0")
        recentBuyDate.text = "최근결제일: "+(pay_data?.firstdate ?? "none")
    }
    
    func setContent() {
        
    }
}
