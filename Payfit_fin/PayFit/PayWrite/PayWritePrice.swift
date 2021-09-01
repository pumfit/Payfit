//
//  PayWritePrice.swift
//  PayFit
//
//  Created by swuad_19 on 16/01/2020.
//  Copyright © 2020 swuad_19. All rights reserved.
//

import Foundation
import UIKit
import FirebaseAuth
import FirebaseDatabase
import CodableFirebase
import FirebaseStorage

class PayWritePrice:UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var tableView: UITableView!
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "PriceCell", for: indexPath)
        cell.textLabel?.text = self.title_data[indexPath.row] + " - " + String(self.data[indexPath.row]) + "₩"
        return cell
    }
    
    
    var dbRef:DatabaseReference!
    var data:[Int] = []
    var title_data:[String] = []
    var data_title:String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dbRef = Database.database().reference()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        getData()
    }
    
    func getData() {
        if data_title == "none" {return} else {
            let path = "system/price/\(data_title)"
            let postRef = dbRef.child(path).observe(DataEventType.value) { (snapshot) in
                self.data = []
                self.title_data = []
                
                for (data) in (snapshot.children.allObjects as! [DataSnapshot]) {
                    let data = try! FirebaseDecoder().decode(Int.self, from: data.value)
                    self.data.append(data)
                }
                
                for (title_data) in (snapshot.children.allObjects as! [DataSnapshot]) {
                    let title_data = try! FirebaseDecoder().decode(String.self, from: title_data.key)
                    self.title_data.append(title_data)
                }
                self.tableView.reloadData()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let n: Int! = self.navigationController?.viewControllers.count
        let payWriteViewController = self.navigationController?.viewControllers[n-2] as! payWriteViewController
        payWriteViewController.price = self.data[self.tableView.indexPathForSelectedRow!.row]
        print(self.data[self.tableView.indexPathForSelectedRow!.row])
        
        self.navigationController?.popViewController(animated: true)
    }
}
