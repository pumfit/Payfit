//
//  listViewController.swift
//  PayFit
//
//  Created by swuad_19 on 09/01/2020.
//  Copyright © 2020 swuad_19. All rights reserved.
//

import Foundation
import UIKit

class listViewController:UIViewController, UITableViewDataSource {
    //행개수
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    //행내용
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "payListCell", for: indexPath)
        cell.textLabel?.text = "Title!"
        cell.detailTextLabel?.text = "date"
        return cell

    }
    
    
    //@IBAction func toappApply(_ sender: UIBarButtonItem) {
       // let appApplyController = self.storyboard?.instantiateViewController(identifier: "appApply") as! appApplyoneController
        //appApplyController.modalPresentationStyle = .fullScreen
    //}
    
    @IBAction func movetoappApply(_ sender: UIButton) {
        self.performSegue(withIdentifier: "appapply", sender: nil)
    }
    
    
}
