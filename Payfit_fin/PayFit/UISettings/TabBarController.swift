//
//  TabBarController.swift
//  PayFit
//
//  Created by swuad_19 on 17/01/2020.
//  Copyright © 2020 swuad_19. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController
{
    
    @IBOutlet weak var barForGradient: UITabBar!
    @IBOutlet var naviItem: UINavigationItem!
    
    func getImageFrom(gradientLayer:CAGradientLayer) -> UIImage? {
        var gradientImage:UIImage?
        UIGraphicsBeginImageContext(gradientLayer.frame.size)
        if let context = UIGraphicsGetCurrentContext() {
            gradientLayer.render(in: context)
            gradientImage = UIGraphicsGetImageFromCurrentImageContext()?.resizableImage(withCapInsets: UIEdgeInsets.zero, resizingMode: .stretch)
        }
        UIGraphicsEndImageContext()
        return gradientImage
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let gradient = CAGradientLayer()//탭바에 그라디언트 색상 추가
        
        gradient.startPoint = CGPoint(x: 0, y: 0.5)
        gradient.endPoint = CGPoint(x: 1, y: 0.5)
        
        let colors = [
            UIColor(red: 0.0, green: 186/255, blue: 237/255, alpha: 1).cgColor,
            UIColor(red: 0.0, green: 231/255, blue: 205/255, alpha: 1).cgColor
        ]
        gradient.colors = colors
        
        gradient.frame = CGRect(origin: CGPoint.init(x: 0, y: -44), size: CGSize.init(width: 414, height: 88))
        
        if let image = getImageFrom(gradientLayer: gradient) {
            barForGradient.backgroundImage = image
        }
        
        barForGradient.layer.shadowPath = CGPath.init(roundedRect: CGRect.init(), cornerWidth: 0.3, cornerHeight: 0.3, transform: nil)
        barForGradient.layer.shadowOpacity = 0.2
        barForGradient.layer.shadowOffset = CGSize.init(width: 0, height: 3)
        barForGradient.tintColor = UIColor.white
        
        //        let selectedColor = UIColor.init(cgColor: #colorLiteral(red: 0.01680417731, green: 0.1983509958, blue: 1, alpha: 1))
        //        let unSelectedColor = UIColor.init(cgColor: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1))
        
    }
}
