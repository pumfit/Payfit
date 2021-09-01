//
//  MySecondEmdeddedViewController.swift
//  PayFit
//
//  Created by swuad_19 on 14/01/2020.
//  Copyright © 2020 swuad_19. All rights reserved.
//

import UIKit
import FSCalendar
import XLPagerTabStrip
import FirebaseDatabase
import FirebaseStorage
import FirebaseAuth
import CodableFirebase

class CalenderViewController: UIViewController, FSCalendarDataSource, FSCalendarDelegate, IndicatorInfoProvider, UITableViewDataSource {
    
    
    @IBOutlet var calendar: FSCalendar!
    
    @IBOutlet weak var calenderTableView: UITableView!
    @IBOutlet weak var tableView: UITableView!
    
    var color:[UIColor] = [UIColor.init(cgColor: #colorLiteral(red: 0.1411764771, green: 0.3960784376, blue: 0.5647059083, alpha: 1)),UIColor.init(cgColor: #colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1)),UIColor.init(cgColor: #colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1)),
                           UIColor.init(cgColor: #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)),UIColor.init(cgColor: #colorLiteral(red: 0, green: 0.7287141681, blue: 0.9295378327, alpha: 1)),UIColor.init(cgColor: #colorLiteral(red: 0.2082563349, green: 0.8494355336, blue: 0.9686274529, alpha: 1)),UIColor.init(cgColor: #colorLiteral(red: 0.1587058212, green: 0.9173935815, blue: 0.9686274529, alpha: 1))]
    var datesWithEvent = ["2020-01-21","2020-01-24","2020-01-28"]
    var dataFormatter2: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
    
    var childNumber: String = ""
    var dbRef:DatabaseReference!
    var data:[Pay] = []
    var single_data:Pay?
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: "\(childNumber)")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dbRef = Database.database().reference()
        
        calendar.delegate = self
        calendar.dataSource = self
        tableView.layer.cornerRadius = 15
        self.calendar.appearance.headerMinimumDissolvedAlpha = 0.0;
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tableView.reloadData()
        dbRef = Database.database().reference()
        getData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:UITableViewCell =
            self.calenderTableView.dequeueReusableCell(withIdentifier: "colorListCell")! as UITableViewCell
        if cell.reuseIdentifier == "colorListCell" {
             let colorView = cell.viewWithTag(10) as! UIView
             colorView.backgroundColor = self.color[indexPath.row]
            colorView.layer.cornerRadius = (colorView.frame.height)/2
             let appNameLabel = cell.viewWithTag(20) as! UILabel
            appNameLabel.text = self.data[indexPath.row].title!
             let payDateLabel = cell.viewWithTag(30) as! UILabel
            payDateLabel.text = self.data[indexPath.row].firstdate
            
         }
        return cell
    }
    
    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
        let dataString = dataFormatter2.string(from: date)
        if datesWithEvent.contains(dataString) {
            return 1
        }
        return 0
    }
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
}
