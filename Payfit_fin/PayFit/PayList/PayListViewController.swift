//
//  PaylistViewController.swift
//  PayFit
//
//  Created by swuad_19 on 10/01/2020.
//  Copyright © 2020 swuad_19. All rights reserved.
//

import UIKit
import FirebaseUI

import FirebaseAuth
import FirebaseDatabase
import CodableFirebase

class PayListViewController: UIViewController, UITableViewDataSource, FUIAuthDelegate {
    
    let authUI = FUIAuth.defaultAuthUI()
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet var nick: UILabel!
    
    //이미지 딕셔너리
    var appIcon:[String:String] = ["none":"nonimage_icon_512x512","applearcade":"applearcade","bugs":"bugs","melon":"melon","minecraft":"minecraft_icon","netflix":"netflix_icon","watcha":"whatcha"]
    
    var dbRef = Database.database().reference()
    var data:[Pay] = []
    
    var AppName: String = ""
    var AppPrice: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = 115
        //dbRef = Database.database().reference()
        //getData()
    }
    //행 개수
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.data.count
    }
    //행 내용
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "payListCell", for: indexPath)
        if cell.reuseIdentifier == "payListCell" {
            let appNameLabel = cell.viewWithTag(10) as! UILabel
            appNameLabel.text = self.data[indexPath.row].title
            let appPriceLabel = cell.viewWithTag(20) as! UILabel
            appPriceLabel.text = "₩" + self.data[indexPath.row].price!
            let buyDateLabel = cell.viewWithTag(30) as! UILabel
            buyDateLabel.text = self.data[indexPath.row].firstdate
            let tagLabel = cell.viewWithTag(40) as! UILabel
            tagLabel.text = self.data[indexPath.row].tag
            let dDayLabel = cell.viewWithTag(50) as! UILabel
            dDayLabel.text = String(self.data[indexPath.row].dday!)
            let appImageIcon = cell.viewWithTag(60) as! UIImageView
            appImageIcon.image = UIImage(named: appIcon[self.data[indexPath.row].title!]!)
            appImageIcon.layer.cornerRadius = 15
        }
        return cell
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let ad = UIApplication.shared.delegate as? AppDelegate
        nick.text = ad?.paramNickname ?? "슈니"
        
        tableView.reloadData()
        dbRef = Database.database().reference()
        getData()
    }
    //    let authUI = FUIAuth.defaultAuthUI()
    //
    //    override func viewWillAppear(_ animated: Bool) {
    //        let ad = UIApplication.shared.delegate as? AppDelegate
    //
    //        nick.text = ad?.paramNickname
    //
    //        let url = URL(string: (ad?.paramImage ?? nil)!)
    //        let data = try? Data(contentsOf: url!)
    //        profileimage.image = UIImage(data: data!)
    //    }
    func getData(){
        if let userID = Auth.auth().currentUser?.uid {
            let postRef = dbRef.child("pay").child("\(userID)")
            let refHandle = postRef.queryOrdered(byChild: "returndate").observe(DataEventType.value) { (snapshot) in
                self.data = []
                let snapshot_data = snapshot.children.allObjects as! [DataSnapshot]
                for pay in snapshot_data {
                    let pay = try! FirebaseDecoder().decode(Pay.self, from: pay.value)
                    self.data.append(pay)
                }
                self.tableView.reloadData()
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toDetail" {
            guard let destination = segue.destination as? PayDetailViewController else {return}
            let index = self.tableView.indexPathForSelectedRow!.row
            destination.pay_data = self.data[index]
        } else if segue.identifier == "toAdd" {
            guard let destination = segue.destination as? payWriteViewController else {return}
        }
    }
}
