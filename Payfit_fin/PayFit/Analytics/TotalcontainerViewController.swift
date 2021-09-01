//
//  TotalcontainerViewController.swift
//  PayFit
//
//  Created by swuad_19 on 17/01/2020.
//  Copyright © 2020 swuad_19. All rights reserved.
//

import UIKit
import SwiftyGif
import FirebaseAuth
import FirebaseDatabase
import CodableFirebase

class TotalcontainerViewController: UIViewController, SwiftyGifDelegate {
    
    @IBOutlet weak var image_view: UIImageView!
    
    var data:[Pay] = []
    var dbRef:DatabaseReference!
    var count:Int = 0
    
    override func viewDidAppear(_ animated: Bool) {
        dbRef = Database.database().reference()
        do{
            let gif = try UIImage(gifName: "nolist_icon_gif_gr.gif")
            self.image_view.setGifImage(gif)
            self.image_view.loopCount = 1
            self.image_view.startAnimating()
            self.image_view.delegate = self //변호사 선임
        } catch{
            print("gif 없음")
        }
    }
}
