//
//  PayWriteAppName.swift
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

class PayWriteAppName:UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    
    @IBOutlet weak var tableView: UITableView!
    
    var dbRef:DatabaseReference!
    var data:[Pay] = []
    var data_title:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dbRef = Database.database().reference()
        tableView.dataSource = self
        self.tableView.delegate = self
        getData()
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "AppName", for: indexPath)
        cell.textLabel?.text = self.data[indexPath.row].title
        return cell
    }
    
    
    
    func getData() {
        if let userID = Auth.auth().currentUser?.uid {
            let thisRef = dbRef.child("system").child("data").queryOrdered(byChild: "title").observe(DataEventType.value) { (snapshot) in
                self.data = []
                print(snapshot)
                let snapshot_data = snapshot.children.allObjects as! [DataSnapshot]
                for system in snapshot_data {
                    let system = try! FirebaseDecoder().decode(Pay.self, from: system.value)
                    self.data.append(system)
                }
                self.tableView.reloadData()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let n: Int! = self.navigationController?.viewControllers.count
        let payWriteController = self.navigationController?.viewControllers[n-2] as! payWriteViewController
        payWriteController.appName = self.data[self.tableView.indexPathForSelectedRow!.row].title!
        payWriteController.tableView.reloadData()
        print(self.data[self.tableView.indexPathForSelectedRow!.row].title)
        self.navigationController?.popViewController(animated: true)
    }
}
