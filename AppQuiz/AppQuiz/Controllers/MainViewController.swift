//
//  MainViewController.swift
//  AppQuiz
//
//  Created by Taof on 8/28/19.
//  Copyright © 2019 Taof. All rights reserved.
//

import UIKit
import Firebase
import SVProgressHUD

class MainViewController: UIViewController {
    
    // Huỷ ViewController khi không sử dụng đến nữa
    deinit {
        print("Huỷ MainViewController")
    }
    
    @IBOutlet weak var tableView: UITableView!
    
    let db = Firestore.firestore()
    var collections = [Collection]()
    var type: Type = .test
    var titleButton: String = "START"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.white
        self.setupSlideMenuItem()
        
        DispatchQueue.main.async {
            self.checkTypeAndGetData(type: self.type)
        }
        
        setupTableView()
        print("type: \(type)")
        
        print(collections)
        
    }
    
    // check xem type là kiểu gì để lấy dữ liệu
    // type có 3 loại được định nghĩa trong enum: test, history, practice
    // node truyền vào hàm getCollections là tên collection (có thể được hiểu như tên bảng) mà mình đặt trên database của Firebase
    func checkTypeAndGetData(type: Type){
        switch type {
        case .test:
            getCollections(node: "tests")
            titleButton = "START"
            
            navigationItem.title = "Bộ câu hỏi"
        case .history:
            getCollections(node: "histories")
            titleButton = "XEM CHI TIẾT"
            
            navigationItem.title = "Lịch sử"
            navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Xoá", style: .done, target: self, action: #selector(deleteHistories))
        case .practice:
            getCollections(node: "practices")
            titleButton = "LUYỆN TẬP"
            
            navigationItem.title = "Thực hành"
        }
    }
    
    @objc func deleteHistories(){
        let alert = UIAlertController(title: "Quiz App", message: "Bạn có chắc chắn muốn xoá toàn bộ lịch sử", preferredStyle: .alert)
        let action = UIAlertAction(title: "Đồng ý", style: .default) { (_) in
            self.collections.removeAll()
            
            self.db.collection("histories").getDocuments(completion: { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                }else{
                    for document in querySnapshot!.documents {
                        self.db.collection("histories").document(document.documentID).delete()
                    }
                }
            })
            self.tableView.reloadData()
        }
        let cancel = UIAlertAction(title: "Huỷ", style: .cancel)
        
        alert.addAction(action)
        alert.addAction(cancel)
        
        present(alert, animated: true, completion: nil)
    }
    
    // viết hàm lấy ra tất cả các bộ đề theo key
    func getCollections(node: String){
        // viet o day
        SVProgressHUD.show()
        // Xoá hết dữ liệu để lấy mới
        collections.removeAll()
        
        // Lấy toàn bộ collection và thằng con của nó
        db.collection(node).getDocuments() { (querySnapshot, err) in
            if let err = err {
                // lỗi sẽ nhảy vào đây
                SVProgressHUD.dismiss()
                print("Error getting documents: \(err)")
            } else {
                // for tất cả collections
                for document in querySnapshot!.documents {
                    
                    if let level = document.data()["level"] as? String,
                        let subject = document.data()["subject"] as? String,
                        let time = document.data()["time"] as? Int,
                        let questionsDict = document.data()["questions"] as? [[String: Any]]{
                        
                        var questions = [Question]()
                        
                        // for tất cả câu hỏi
                        for item in questionsDict{
                            if let question = item["question"] as? String,
                                let note = item["note"] as? String,
                                let answer = item["answer"] as? String,
                                let answersDict = item["answers"] as? [[String: Any]]{ // convert thành mảng dictionary
                               
                                var answers = [Answer]()
                                for answerDict in answersDict{ // for mảng dictionary để lấy dữ liệu của từng thằng theo key
                                    if let answer = answerDict["answer"] as? String,
                                        let isSelected = answerDict["isSelected"] as? Bool{
                                        
                                        answers.append(Answer(answer: answer, isSelected: isSelected))
                                    }
                                }
                                
                                let question = Question(question: question, note: note, answer: answer, answers: answers)
                                questions.append(question)
                            }
                        }
                        
                        let collection = Collection(level: level,
                                                    subject: subject,
                                                    time: time,
                                                    questions: questions)
                        
                        self.collections.append(collection)
                        self.tableView.reloadData()
                        SVProgressHUD.dismiss()
                    }
                }
            }
        }
    }
    
    func setupTableView(){
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.register(UINib(nibName: "ItemCell", bundle: nil), forCellReuseIdentifier: "itemCell")
    }
    
}

extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return collections.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "itemCell", for: indexPath) as! ItemCell
        
        // set lại tên nút
        cell.actionButton.setTitle(titleButton, for: .normal)
        
        let item = collections[indexPath.row]
        cell.type = self.type
        cell.item = item
        // tắt hiệu ứng khi nhấn vào cell
        cell.selectionStyle = .none
        
        
        // hứng closure từ cell
        cell.start = { [weak self] in
            
            // kiểm tra self nếu không nil thì gán lại bằng strongSelf
            guard let strongSelf = self else { return }
            
            // khởi tạo màn quizViewController
            let quizVC = QuizViewController()
            
            quizVC.type = strongSelf.type
            quizVC.collection = item
            quizVC.x = { [weak self] u  in
                
                guard let strongSelf = self else { return }
                
                let historyVC = QuizViewController()
                historyVC.type = u
                historyVC.collection = item
                let navigationVC = UINavigationController(rootViewController: historyVC)
                strongSelf.slideMenuController()?.changeMainViewController(navigationVC, close: true)
            
            }
            let navigation = UINavigationController(rootViewController: quizVC)
            navigation.modalPresentationStyle = .fullScreen
            strongSelf.present(navigation, animated: true, completion: nil)
            
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
