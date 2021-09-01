//
//  mainViewController.swift
//  PayFit
//
//  Created by swuad_19 on 07/01/2020.
//  Copyright © 2020 swuad_19. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import CodableFirebase
import FirebaseStorage
import FSCalendar
import Charts
import Kingfisher
import XLPagerTabStrip

class GraphViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, IndicatorInfoProvider {
    
    var childNumber: String = ""
    var dbRef = Database.database().reference()
    var data:[Pay] = []
    var single_data:Pay?
    
    var items: [String] = ["게임","미디어","쇼핑","음악"]
    
    @IBOutlet weak var totalPay: UILabel!
    
    @IBOutlet weak var tableview: UITableView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var pieChart: PieChartView!
    @IBOutlet weak var allpaylistView: UIView!
    
    var gameTag = 0
    var mediaTag = 0
    var shopTag = 0
    var musicTag = 0
    
    var appIcon:[String:String] = ["none":"nonimage_icon_512x512","applearcade":"applearcade","bugs":"bugs","melon":"melon","minecraft":"minecraft_icon","netflix":"netflix_icon","watcha":"whatcha"]
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "recentPayCell", for: indexPath)
        if cell.reuseIdentifier == "recentPayCell" {
            let appNameLabel = cell.viewWithTag(10) as! UILabel
            appNameLabel.text = self.data[indexPath.row].title
            let appPriceLabel = cell.viewWithTag(20) as! UILabel
            appPriceLabel.text = "₩" + self.data[indexPath.row].price!
            let buyDateLabel = cell.viewWithTag(30) as! UILabel
            buyDateLabel.text = self.data[indexPath.row].firstdate! + "  #" + self.data[indexPath.row].tag!
            let appIconLabel = cell.viewWithTag(40) as! UIImageView
            appIconLabel.image = UIImage(named: appIcon[self.data[indexPath.row].title!]!)
            appIconLabel.layer.cornerRadius = 15
            let dDayLabel = cell.viewWithTag(50) as! UILabel
            dDayLabel.text = String(self.data[indexPath.row].dday!)
            
        }
        return cell
    }
    
    var gameEntry = PieChartDataEntry(value: 0)
    var shoppingEntry = PieChartDataEntry(value: 0)
    var musicEntry = PieChartDataEntry(value: 0)
    var mediaEntry = PieChartDataEntry(value: 0)//초기화
    var numberOfDownloadsDataEntries = [PieChartDataEntry]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pieChart.holeRadiusPercent = 0.48
        
        //테이블뷰 및 뷰 UI설정
        tableview.layer.cornerRadius = 15
        tableview.rowHeight = 110
        tableview.layer.shadowOpacity = 0.2
        tableview.layer.shadowOffset = CGSize.init(width: 0, height: 3)
        tableview.layer.shadowRadius = 3
        //그림자 설정
        allpaylistView.layer.cornerRadius = 15
        allpaylistView.layer.shadowOpacity = 0.2
        allpaylistView.layer.shadowOffset = CGSize.init(width: 0, height: 3)
        allpaylistView.layer.shadowRadius = 3
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        dbRef = Database.database().reference()
        getData()
    }
    
    func updateChartData(){//차트 다시 초기화해서 보여주는 함수
        
        let chartDataSet = PieChartDataSet(entries: numberOfDownloadsDataEntries, label: nil)//values->entries
        let chartData = PieChartData(dataSet: chartDataSet)
        
        let colors = [UIColor.init(cgColor: #colorLiteral(red: 0.1308996379, green: 0.6439985037, blue: 0.7900323272, alpha: 1)),UIColor.init(cgColor: #colorLiteral(red: 0.139932245, green: 0.710555017, blue: 0.871692121, alpha: 1)),UIColor.init(cgColor: #colorLiteral(red: 0.1470111907, green: 0.7628701329, blue: 0.9355059266, alpha: 1))]//색상변경 여기서 엔트리 순서대로 변경가능
        chartDataSet.colors = colors as! [NSUIColor]
        
        pieChart.data = chartData
        //pieChart.drawAngles =
        pieChart.animate(xAxisDuration: 1, yAxisDuration: 1)
        
    }
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: "\(childNumber)")
    }
    
    func chartValue() {
        gameEntry.value = round(Double((Double(gameTag)/Double(gameTag+shopTag+musicTag+mediaTag))*100))
        print(gameEntry.value)
        gameEntry.label = "게임"
        print((shopTag/(gameTag+shopTag+musicTag+mediaTag))*100)
        shoppingEntry.value = round(Double((Double(shopTag)/Double(gameTag+shopTag+musicTag+mediaTag))*100))
        print(shoppingEntry.value)
        shoppingEntry.label = "쇼핑"
        
        mediaEntry.value = round(Double((Double(mediaTag)/Double(gameTag+shopTag+musicTag+mediaTag))*100))
        print(mediaEntry.value)
        mediaEntry.label = "미디어"
        
        musicEntry.value = round(Double((Double(musicTag)/Double(gameTag+shopTag+musicTag+mediaTag))*100))
        musicEntry.label = "음악"
        
        numberOfDownloadsDataEntries = [gameEntry,shoppingEntry,mediaEntry,musicEntry]
        
        updateChartData()
    }
    
    func getData() {
        if let userID = Auth.auth().currentUser?.uid {
            let postRef = dbRef.child("pay").child("\(userID)")
            let refHandle = postRef.queryOrdered(byChild: "returndate").observe(DataEventType.value) { (snapshot) in
                self.data = []
                let snapshot_data = snapshot.children.allObjects as! [DataSnapshot]
                var total = 0
                for pay in snapshot_data {
                    let pay = try! FirebaseDecoder().decode(Pay.self, from: pay.value)
                    self.data.append(pay)
                    total += Int(pay.price!)!
                    if pay.tag == "게임" {
                        self.gameTag += 1
                    }else if pay.tag == "미디어" {
                        self.mediaTag += 1
                    }else if pay.tag == "쇼핑" {
                        self.shopTag += 1
                    }else if pay.tag == "음악" {
                        self.musicTag += 1
                    }else {}
                }
                self.chartValue()
                self.totalPay.text = String(total) + "원"
                self.tableView.reloadData()
            }
            
        }
    }
    
}
