//
//  appApplyoneController.swift
//  PayFit
//
//  Created by swuad_19 on 09/01/2020.
//  Copyright © 2020 swuad_19. All rights reserved.
//

import Foundation
import UIKit
import FirebaseUI
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage
import UserNotifications

class payWriteViewController:UIViewController, UITableViewDataSource, UITableViewDelegate,UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate{
    
    
    @IBOutlet var textbox2: UITextField!
    @IBOutlet var textbox3: UITextField!
    
    @IBOutlet var dropdown2: UIPickerView!
    @IBOutlet var dropdown3: UIPickerView!
    
    @IBOutlet var tableView: UITableView!
    
    
    var dbRef:DatabaseReference!
    var storage = Storage.storage()
    var cellList:[String] = ["appNameCell","priceCell","firstBuyCell","tagCell","alertCell"]
    //테이블 뷰
    
    var appName:String = "none"
    var price:Int = 0
    var date:String?
    var tag:String = "none"
    var dday:Int = 0
    var paydate:String?
    
    var datePicker = UIDatePicker()
    var date_string:String = "none"
    
    var dateAlarm = ["1일", "2일", "3일"]
    var alarm = ["무음", "진동", "소리"]
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        let dateAlarmrows : Int = dateAlarm.count
        let alarmrows : Int = alarm.count
        pickerView.backgroundColor = .lightGray
        pickerView.tintColor = .cyan
        
        
        
        if pickerView == dropdown2 {
            
            return dateAlarmrows
        }
        else if pickerView == dropdown3 {
            
            return alarmrows
        }
        
        return 0
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        
        if pickerView == dropdown2{
            let titleRow = dateAlarm[row]
            
            return titleRow
        }
            
        else if pickerView == dropdown3{
            let titleRow = alarm[row]
            
            return titleRow
        }
        return ""
    }
    
    
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        
        if pickerView == dropdown2{
            self.textbox2.text = self.dateAlarm[row]
            self.dropdown2.isHidden = true
            
        }
        else if pickerView == dropdown3{
            self.textbox3.text = self.alarm[row]
            self.dropdown3.isHidden = true
            
        }
    }
    
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        if (textField == self.textbox2){
            self.dropdown2.isHidden = false
            
        }
        else if (textField == self.textbox3){
            self.dropdown3.isHidden = false
            
        }
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { return 5 }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellList[indexPath.row],for:indexPath)
        
        if cell.reuseIdentifier == "appNameCell" {
            let appNameLabel = cell.viewWithTag(10) as! UILabel
            appNameLabel.text = appName
        } else if cell.reuseIdentifier == "priceCell" {
            let appPriceLabel = cell.viewWithTag(20) as! UILabel
            appPriceLabel.text = String(self.price)
        } else if cell.reuseIdentifier == "firstBuyCell" {
            let firstBuyLabel = cell.viewWithTag(30) as! UILabel
            firstBuyLabel.text = date_string
        } else if cell.reuseIdentifier == "tagCell" {
            let tagLabel = cell.viewWithTag(40) as! UILabel
            tagLabel.text = tag
        } //d-day 남은 일자
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 2 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "firstBuyCell", for: indexPath)
            if cell.reuseIdentifier == "firstBuyCell" {
                let alert = UIAlertController(title: "날짜 선택", message: "\n", preferredStyle: .actionSheet)
                let add = UIAlertAction(title: "선택", style: .default)
                let cancel = UIAlertAction(title: "취소", style: .cancel)
                datePicker.datePickerMode = .dateAndTime
                let date = Date()
                datePicker.maximumDate = date
                datePicker.frame = CGRect.init(x: 0, y: 40, width: 375, height: 50)
                alert.view.addSubview(datePicker)
                alert.addAction(add)
                alert.addAction(cancel)
                
                datePicker.addTarget(self, action: #selector(changed), for: .valueChanged)
                
                self.present(alert, animated: true)
            }
            self.tableView.reloadData()
        }
    }
    
    @objc func changed() {
        let dateformatter = DateFormatter()
        dateformatter.dateStyle = .medium
        date_string = dateformatter.string(from: datePicker.date)
        self.date = date_string
        self.tableView.reloadData()
    }
    
    
    @IBOutlet var hideStackView: UIStackView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = 55
        //swAppearOnOff(hidSwitch)
        dbRef = Database.database().reference()
        self.tableView.delegate = self
        self.tableView.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.tableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func swAppearOnOff(_ sender: UISwitch) {
        if sender.isOn {
            hideStackView.isHidden = false
        }else{
            hideStackView.isHidden = true
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toPriceData" {
            guard let destination = segue.destination as? PayWritePrice else {return}
            destination.data_title = self.appName
        } else {return}
    }
    
    @IBAction func doSave(_ sender: Any) {
        
        // 첫구매일 기준 한달후 알림 (시연을 위해 30초후 알림)
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "yyyy-MM-dd"
        let time = self.datePicker.date // 첫결제일
        let monthTime = Date(timeIntervalSince1970: (Calendar.current.date(byAdding: .month, value: 1, to: time)!.timeIntervalSince1970) - (Date().timeIntervalSince1970 - time.timeIntervalSince1970)) //첫결제일 한달 후
        
        let realterm = Int((monthTime.timeIntervalSince1970 - time.timeIntervalSince1970)/(60*60*24)) //첫결제일 한달후와 첫결제일 사이시간
        self.dday = realterm
        let alarmterm = (monthTime.timeIntervalSince1970 - time.timeIntervalSince1970) - ((monthTime.timeIntervalSince1970 - time.timeIntervalSince1970)-30) //알람을 위해 지정한 사이시간
        
        let monthTimeString = dateformatter.string(from: monthTime)
        // 데이터 베이스 저장
        var post:[String:Any] = [
            "title": appName,
            "price":String(price),
            "firstdate": date,
            "tag": tag,
            "dday": dday
        ]
        guard let userID = Auth.auth().currentUser?.uid else {return}
        guard let key = dbRef.child("pay/\(userID)/").childByAutoId().key else {return}
        let path = "/pay/\(userID)/\(key)"
        postUpLoad(path, post)
        
        UNUserNotificationCenter.current().getNotificationSettings{
            settings in
            if settings.authorizationStatus == UNAuthorizationStatus.authorized{
                if alarmterm > 0{
                    let nContent = UNMutableNotificationContent()
                    nContent.body = "D-\(realterm)일! \(monthTimeString)일에 '\(self.appName)' 결제일!"
                    nContent.title = "Payfit 정기결제 알림"
                    nContent.sound = UNNotificationSound.default
                    
                    let trigger = UNTimeIntervalNotificationTrigger(timeInterval: alarmterm, repeats: false)
                    
                    let request = UNNotificationRequest(identifier: "remider", content: nContent, trigger: trigger)
                    UNUserNotificationCenter.current().add(request){
                        (_) in
                        DispatchQueue.main.async {
                            let alert = UIAlertController(title: "알람설정", message: "알람이 설정되었습니다.", preferredStyle: .alert)
                            let ok = UIAlertAction(title: "OK", style: .default)
                            alert.addAction(ok)
                            self.present(alert, animated: false)
                        }
                    }
                }else{ //시간초과 time<0
                    DispatchQueue.main.async {
                        let alert = UIAlertController(title: "Fail", message: "시간초과 0보다 작음", preferredStyle: .alert)
                        let ok = UIAlertAction(title: "OK", style: .default)
                        alert.addAction(ok)
                        self.present(alert, animated: false)
                    }
                }
            }else{
                DispatchQueue.main.async {
                    let alert = UIAlertController(title: "Fail", message: "notification 설정이 되어있지않음", preferredStyle: .alert)
                    let ok = UIAlertAction(title: "OK", style: .default)
                    alert.addAction(ok)
                    self.present(alert, animated: false)
                }
            }
        }
        
    }
    
    func postUpLoad(_ path:String, _ post:[String:Any]) {
        dbRef.child(path).setValue(post) {
            (error, ref) in
            if let error = error {
                NSLog(error.localizedDescription)
                return
            }
            self.navigationController?.popViewController(animated: true)
        }
    }
}
