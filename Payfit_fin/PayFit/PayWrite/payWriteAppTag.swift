//
//  payWriteAppTag.swift
//  PayFit
//
//  Created by swuad_19 on 18/01/2020.
//  Copyright © 2020 swuad_19. All rights reserved.
//

import Foundation
import UIKit
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage
import CodableFirebase

class PayWriteAppTag:UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet var tableView: UITableView!
    var dbRef:DatabaseReference!
    var data:[String] = []
    var data_tag:String?
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "appTag", for: indexPath)
        cell.textLabel?.text = self.data[indexPath.row]
        return cell
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dbRef = Database.database().reference()
        tableView.dataSource = self
        tableView.delegate = self
        getData()
    }
    
    func getData() {
        if let userID = Auth.auth().currentUser?.uid {
            let thisRef = dbRef.child("system").child("tag").observe(DataEventType.value) { (snapshot) in
                self.data = []
                for (data) in (snapshot.children.allObjects as! [DataSnapshot]) {
                    let data = try! FirebaseDecoder().decode(String.self, from: data.value)
                    self.data.append(data)
                }
                self.tableView.reloadData()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let n: Int! = self.navigationController?.viewControllers.count
        let payWriteViewController = self.navigationController?.viewControllers[n-2] as! payWriteViewController
        payWriteViewController.tag = self.data[self.tableView.indexPathForSelectedRow!.row]
        payWriteViewController.tableView.reloadData()
        self.navigationController?.popViewController(animated: true)
    }
}
