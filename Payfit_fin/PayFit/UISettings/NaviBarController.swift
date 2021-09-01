//
//  NaviBarController.swift
//  PayFit
//
//  Created by swuad_19 on 17/01/2020.
//  Copyright © 2020 swuad_19. All rights reserved.
//

import UIKit
 
 
class NaviBarfirstController: UINavigationController
{
 
    @IBOutlet var barForGradient: UINavigationBar!
    
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
        
        let gradient = CAGradientLayer()
        
        gradient.startPoint = CGPoint(x: 0, y: 0.5)
        gradient.endPoint = CGPoint(x: 1, y: 0.5)
 
        let colors = [
            UIColor(red: 0.0, green: 186/255, blue: 237/255, alpha: 1).cgColor,
            UIColor(red: 0.0, green: 231/255, blue: 205/255, alpha: 1).cgColor
            ]
        gradient.colors = colors
        
        //gradient.frame = barForGradient.bounds
        gradient.frame = CGRect(origin: CGPoint.init(x: 0, y: -44), size: CGSize.init(width: 414, height: 88))
        
        if let image = getImageFrom(gradientLayer: gradient) {
        barForGradient.setBackgroundImage(image, for: UIBarMetrics.default)
        }
    
    }
}
