//
//  MyPagerTabStripName.swift
//  PayFit
//
//  Created by swuad_19 on 14/01/2020.
//  Copyright © 2020 swuad_19. All rights reserved.
//

import UIKit
import XLPagerTabStrip

class MyPagerViewController: ButtonBarPagerTabStripViewController {
    
    override func viewDidLoad() {
        configureButtonBar()
        super.viewDidLoad()
        //self.navigationController?.navigationBar.isHidden = true
        edgesForExtendedLayout = []
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    func configureButtonBar() {
        settings.style.buttonBarBackgroundColor = .white
        settings.style.buttonBarItemBackgroundColor = .white
        
        // Sets the pager strip item font and font color
        settings.style.buttonBarItemFont = UIFont(name: "Helvetica", size: 16.0)!
        settings.style.buttonBarItemTitleColor = #colorLiteral(red: 0, green: 0.7287141681, blue: 0.9295378327, alpha: 1)
        
        // Sets the pager strip item offsets
        settings.style.buttonBarMinimumLineSpacing = 0
        settings.style.buttonBarItemsShouldFillAvailableWidth = true
        settings.style.buttonBarLeftContentInset = 0
        settings.style.buttonBarRightContentInset = 0
        
        // Sets the height and colour of the slider bar of the selected pager tab
        settings.style.selectedBarHeight = 3.0
        settings.style.selectedBarBackgroundColor = #colorLiteral(red: 0.3358631134, green: 0.7132208347, blue: 0.9083992839, alpha: 1)
        
        
        // Changing item text color on swipe
        changeCurrentIndexProgressive = { [weak self] (oldCell: ButtonBarViewCell?, newCell: ButtonBarViewCell?, progressPercentage: CGFloat, changeCurrentIndex: Bool, animated: Bool) -> Void in
            guard changeCurrentIndex == true else { return }
            oldCell?.label.textColor = .gray
            newCell?.label.textColor = #colorLiteral(red: 0, green: 0.7287141681, blue: 0.9295378327, alpha: 1)
        }
    }
    override func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
        
        let child1 = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "GraphViewController") as! GraphViewController
        child1.childNumber = "그래프"
        
        let child2 = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CalenderViewController") as! CalenderViewController
        child2.childNumber = "캘린더"
        
        return [child1, child2]
    }
    
}
