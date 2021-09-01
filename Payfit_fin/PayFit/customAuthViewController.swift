//
//  customAuthViewController.swift
//  PayFit
//
//  Created by swuad_19 on 07/01/2020.
//  Copyright © 2020 swuad_19. All rights reserved.
//

import UIKit
import FirebaseUI

class customAuthViewController:FUIAuthPickerViewController{
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?, authUI: FUIAuth) {
        super.init(nibName: "FUIAuthPickerViewController", bundle: nibBundleOrNil, authUI: authUI)
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let width = UIScreen.main.bounds.size.width
        let height = UIScreen.main.bounds.size.height
        
        let backgroundImageView = UIImageView(frame: CGRect(x:0, y:0, width: width, height: height))
        backgroundImageView.image = UIImage(named: "login_image")
        backgroundImageView.backgroundColor = #colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1)
        backgroundImageView.contentMode = .scaleAspectFill
        
        self.view.insertSubview(backgroundImageView, at: 0)
        self.view.subviews[1].backgroundColor = UIColor.clear
        /* 순서: view -> background image view -> scrollview -> view */
        self.view.subviews[1].subviews[0].backgroundColor = UIColor.clear
    }
}
