//
//  PayWriteViewController.swift
//  PayFit
//
//  Created by swuad_19 on 10/01/2020.
//  Copyright © 2020 swuad_19. All rights reserved.
//

import UIKit
import Eureka

import FirebaseAuth
import FirebaseDatabase

class PayWriteViewController: FormViewController {
    var dbRef:DatabaseReference!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.topItem?.title = ""
        self.title = "일기쓰기"
        //유레카- 아래 얘들 자동으로 만들어줌
        //->섹션추가->로우넣기
        form +++  Section("")
            <<< TextRow() { row in
                row.tag = "title"
                row.title = "넷플릭스"
                row.placeholder = "제목을 입력하세요."
            }
            <<< DateRow() {
                $0.tag = "Date"
                $0.value = Date()
                $0.title = "D-day"
            }
            +++ Section("")
                <<< ImageRow(){
                    $0.tag = "image"
                    $0.title = "사진"
                }
            +++ Section("요금제")
            <<< TextAreaRow("내용") {
                $0.tag = "content"
                $0.placeholder = "요금제입력"
                $0.textAreaHeight = .dynamic(initialTextViewHeight: 100)
            }
    }
    
    
    @IBAction func doSave(_ sender: Any) {
        if let title_row = form.rowBy(tag: "title") as? TextRow,
            let date_row = form.rowBy(tag: "Date") as? DateRow,
            let image_row = form.rowBy(tag: "image") as? ImageRow,
            let content_row = form.rowBy(tag: "content") as? TextAreaRow
        {
            //있으면 ?? 고 없으면 "" 임
            print(title_row.value ?? "", date_row.value ?? "")
            // 데이터저장 (이미지저장은 나중에 파일업로드를 해야하므로) //서버의 시간은 숫자로 저장
            let timestamp = date_row.value?.timeIntervalSince1970
            guard let userID = Auth.auth().currentUser?.uid else {return}
            //구글 파이어베이스 규칙 diary 아래로
            guard let key = dbRef.child("diary/\(userID)/").childByAutoId().key else {return}
            let path = "/diary/\(userID)/\(key)"
            let post:[String:Any] = [
                "uid":userID,
                "title":title_row.value ?? "",
                "date":timestamp ?? TimeInterval(),
                "content":content_row.value ?? ""
            ]
            dbRef.child(path).setValue(post){ (error, ref) in
                if let error = error {
                    NSLog(error.localizedDescription)
                    return
                }
                NSLog("Save Complete")
                
            }
        }
    }
}
