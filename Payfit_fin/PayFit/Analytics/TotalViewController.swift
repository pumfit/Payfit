//
//  TotalView.swift
//  PayFit
//
//  Created by swuad_19 on 13/01/2020.
//  Copyright © 2020 swuad_19. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseUI
import Charts
import FirebaseDatabase
import CodableFirebase

class TotalViewController: UIViewController, UITableViewDataSource {
    
    var dbRef = Database.database().reference()
    var data:[Pay] = []
    var single_data:Pay?
    
    var items: [String] = ["게임","미디어","쇼핑","음악"]
    //태그 초기화
    var gameTag = 0
    var mediaTag = 0
    var shopTag = 0
    var musicTag = 0
    //태그 차트값 초기화
    var gameEntry = PieChartDataEntry(value: 0)
    var shoppingEntry = PieChartDataEntry(value: 0)
    var musicEntry = PieChartDataEntry(value: 0)
    var mediaEntry = PieChartDataEntry(value: 0)//초기화
    var numberOfDownloadsDataEntries = [PieChartDataEntry]()
    
    @IBOutlet weak var totalPay: UILabel!
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "payListCell", for: indexPath)
        
        if cell.reuseIdentifier == "payListCell" {
            let appNameLabel = cell.viewWithTag(10) as! UILabel
            appNameLabel.text = self.data[indexPath.row].title
            let appPriceLabel = cell.viewWithTag(20) as! UILabel
            appPriceLabel.text = self.data[indexPath.row].price
            let appImageIcon = cell.viewWithTag(30) as! UIImageView
            appImageIcon.image = UIImage(named: appIcon[self.data[indexPath.row].title!]!)
            appImageIcon.layer.cornerRadius = 15
        }
        return cell
    }
    
    var hid:Bool = false
    
    var appIcon:[String:String] = ["none":"nonimage_icon_512x512","applearcade":"applearcade","bugs":"bugs","melon":"melon","minecraft":"minecraft_icon","netflix":"netflix_icon","watcha":"whatcha"]
    
    @IBOutlet weak var pieChart: PieChartView!
    @IBOutlet var tableView: UITableView!
    
    @IBOutlet weak var ContainerView: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = 55
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tableView.reloadData()
        dbRef = Database.database().reference()
        getData()
    }
    
    func updateChartData(){//차트 다시 초기화해서 보여주는 함수
        let chartDataSet = PieChartDataSet(entries: numberOfDownloadsDataEntries, label: nil)//values->entries
        let chartData = PieChartData(dataSet: chartDataSet)
        
        let colors = [UIColor.init(cgColor: #colorLiteral(red: 0.1308996379, green: 0.6439985037, blue: 0.7900323272, alpha: 1)),UIColor.init(cgColor: #colorLiteral(red: 0, green: 0.877353251, blue: 0.8352988362, alpha: 1)),UIColor.init(cgColor: #colorLiteral(red: 0.2588235438, green: 0.7568627596, blue: 0.9686274529, alpha: 1)),UIColor.init(cgColor: #colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1))]//색상변경 여기서 엔트리 순서대로 변경가능
        chartDataSet.colors = colors as! [NSUIColor]
        
        pieChart.data = chartData
        pieChart.animate(xAxisDuration: 1, yAxisDuration: 1)
        
    }
    // 차트 데이터
    func chartValue() {
        numberOfDownloadsDataEntries = []
        gameEntry.value = round(Double((Double(gameTag)/Double(gameTag+shopTag+musicTag+mediaTag))*100)) ?? 0.0
        gameEntry.label = "게임"
        if gameEntry.value != 0.0 {numberOfDownloadsDataEntries.append(gameEntry)}
        
        shoppingEntry.value = round(Double((Double(shopTag)/Double(gameTag+shopTag+musicTag+mediaTag))*100)) ?? 0.0
        shoppingEntry.label = "쇼핑"
        if shoppingEntry.value != 0.0 {numberOfDownloadsDataEntries.append(shoppingEntry)}
        
        mediaEntry.value = round(Double((Double(mediaTag)/Double(gameTag+shopTag+musicTag+mediaTag))*100)) ?? 0.0
        mediaEntry.label = "미디어"
        if mediaEntry.value != 0.0 {numberOfDownloadsDataEntries.append(mediaEntry)}
        
        musicEntry.value = round(Double((Double(musicTag)/Double(gameTag+shopTag+musicTag+mediaTag))*100)) ?? 0.0
        musicEntry.label = "음악"
        if musicEntry.value != 0.0 {numberOfDownloadsDataEntries.append(musicEntry)}
        
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
                self.chartValue() //차트 값 넣기
                self.totalPay.text = "총 금액: " + String(total) + "원"
                if self.data.count != 0 {
                    self.ContainerView.isHidden = true
                }
                self.tableView.reloadData()
            }
        }
    }
}
