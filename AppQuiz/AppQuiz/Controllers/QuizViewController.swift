//
//  QuizViewController.swift
//  AppQuiz
//
//  Created by Taof on 8/28/19.
//  Copyright © 2019 Taof. All rights reserved.
//

import UIKit
import Firebase

class QuizViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var countAnswerLabel: UILabel!
    @IBOutlet weak var previousButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    
    var x: ((Type) -> Void)?
    let db = Firestore.firestore()
    
    // khai báo biến type, kiểu Type để kiểm tra QuizViewController được gọi từ trạng thái nào
    var type: Type?
    
    // khai báo collection, kiểu Collection để hứng bộ câu hỏi từ màn chính
    var collection: Collection?
    
    // khai báo một biến timer, kiểu Timer
    var timer: Timer!
    
    // khai báo biến đếm
    var dem: Int = 0
    
    // khai báo mảng questions để hứng dữ liệu của từng câu hỏi
    var questions: [Question]{
        return collection?.questions ?? [Question]()
    }
    
    // khai báo biến để đếm tổng số câu hỏi
    var numberOfQuestion: Int{
        return collection?.questions.count ?? 0
    }
    
    // khai báo biến để biết câu hiện tại
    var currentIndexQuestion: Int = 0
    
    var currentQuestion: Question{
        return questions[currentIndexQuestion]
    }
    
    // đếm số câu đáp án của từng câu hỏi
    var countOption: Int = 4
    
    var isShowNote: Bool = false
    
    deinit {
        print("deinit QuizViewController")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        if collection == nil{
            // phải chắc chắn nó k nil mới đc gọi !
            navigationController?.popToRootViewController(animated: true)
            return
        }
        
        if type == Type.test {
            navigationItem.title = String(collection!.time)
            dem = collection!.time
        } else if type == Type.history {
            navigationItem.title = "Chi tiết"
        } else {
            navigationItem.title = "Luyện tập"
        }
        setupTableView()
        checkTypeAndGetData(type: type!)
        
        
        // khởi tạo biến leftSwipe
        let leftSwipe = UISwipeGestureRecognizer(target: self, action: #selector(swipeLeft))
        // quy định biến này vuốt sang trái
        leftSwipe.direction = .left
        // thêm cử chỉ leftSwipe vào
        view.addGestureRecognizer(leftSwipe)
        
        // ở câu thứ nhất thì nút previousButton set cho nó bị khoá, k tương tác được
        previousButton.isEnabled = false
        
        let rightSwipe = UISwipeGestureRecognizer(target: self, action: #selector(swipeRight))
        rightSwipe.direction = .right
        view.addGestureRecognizer(rightSwipe)
        
        // gán mảng câu hỏi vào questions
        currentIndexQuestion = 0
        
        countAnswerLabel.text = "\(currentIndexQuestion + 1)/\(numberOfQuestion)"
        
    }
    
    func checkTypeAndGetData(type: Type){
        switch type {
        case .test:
            // khởi tạo timer
            timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(runTimer), userInfo: nil, repeats: true)
            
            // thêm nút cho navigationBar
            navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Kết thúc", style: .done, target: self, action: #selector(endedFunc))
        case .practice, .history:
            
            navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Xong", style: .done, target: self, action: #selector(endedFunc))
        }
    }
    
    @objc func runTimer(){
        // mỗi lần gọi hàm, biến dếm sẽ trừ đi 1
        dem -= 1
        
        // đặt lại thời gian ở chỗ title của navigation bar
        navigationItem.title = String(dem)
        
        // nếu biến dem == 0 thì dừng thời gian
        if dem == 0 {
            self.timer.invalidate()
            let alert = UIAlertController(title: "Quiz App", message: "Thời gian làm bài đã hết!", preferredStyle: .alert)
            
            let action = UIAlertAction(title: "OK", style: .default) { (_) in
                self.submitResult(collection: self.collection!)
                print("Time end")
                self.x?(Type.history)
                self.dismiss(animated: true, completion: nil)
                
            }
            alert.addAction(action)
            present(alert, animated: true, completion: nil)
        }
    }
    
    func setupTableView(){
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        tableView.separatorStyle = .none
        tableView.bounces = false
        
        tableView.register(UINib(nibName: "QuestionTableViewCell", bundle: nil), forCellReuseIdentifier: "QuestionTableViewCell")
        tableView.register(UINib(nibName: "AnswerTableViewCell", bundle: nil), forCellReuseIdentifier: "AnswerTableViewCell")
        tableView.register(UINib(nibName: "NoteTableViewCell", bundle: nil), forCellReuseIdentifier: "NoteTableViewCell")
    }
    
    
    @objc func endedFunc(){
        
        if type == Type.history {
            let mainVC = MainViewController()
            mainVC.type = .test
            let navigationVC = UINavigationController(rootViewController: mainVC)
            self.slideMenuController()?.changeMainViewController(navigationVC, close: true)
        }
        
        let alert = UIAlertController(title: "Quiz App", message: "Bạn muốn kết thúc luyện tập?", preferredStyle: .alert)
        let action = UIAlertAction(title: "Đồng ý", style: .default) { (_) in
            if self.type == Type.test {
                self.timer.invalidate()
                self.x?(Type.history)
            }
            self.submitResult(collection: self.collection!)
            self.dismiss(animated: true, completion: nil)
        }
        let cancel = UIAlertAction(title: "Huỷ", style: .cancel)
        
        alert.addAction(action)
        alert.addAction(cancel)
        
        present(alert, animated: true, completion: nil)
        
    }
    
    func getNumberOfRows() -> Int {
        guard let type = type else {
            return 0
        }
        
        switch type {
        case .test:
            // kiểm tra: tối thiểu 1 cell câu hỏi + đáp án
            return 1 + countOption
        case .practice, .history:
            // luyện tập: tối thiểu 2 cell (câu hỏi và giải thích) + đáp án
            return 2 + countOption
        }
    }
    
    @IBAction func backPress(_ sender: Any) {
        previousAnswer()
    }
    
    @IBAction func nextPress(_ sender: Any) {
        nextAnswer()
    }
    
    @objc func swipeLeft(){
        if currentIndexQuestion != numberOfQuestion - 1 {
            nextAnswer()
        }
    }
    
    @objc func swipeRight(){
        if currentIndexQuestion > 0 {
            previousAnswer()
        }
    }
    
    func nextAnswer(){
        print("nextAnswer")
        
        print(currentQuestion.answers[0].isSelected)
        // mở khoá nút back câu hỏi
        previousButton.isEnabled = true
        
        // mỗi lần next, giá trị câu hỏi hiện tại tăng lên 1
        currentIndexQuestion += 1
        
        // kiểm tra câu hỏi hiện tại, nếu lớn hơn tổng số câu
        if currentIndexQuestion == numberOfQuestion - 1 {
            nextButton.isEnabled = false
            
        }
        countAnswerLabel.text = "\(currentIndexQuestion + 1)/\(numberOfQuestion)"
        
        // cập nhật countOption
        countOption = currentQuestion.answers.count
        isShowNote = false
        tableView.reloadData()
    }
    
    func previousAnswer(){
        
        print("previousAnswer")
        // mở khoá cho nextButton
        nextButton.isEnabled = true
        
        // mỗi lần back thì câu hỏi hiện tại trừ 1
        currentIndexQuestion -= 1
        
        if currentIndexQuestion <= 0 {
            currentIndexQuestion = 0
            previousButton.isEnabled = false
        }
        countAnswerLabel.text = "\(currentIndexQuestion + 1)/\(numberOfQuestion)"
        
        // cập nhật countOption
        countOption = currentQuestion.answers.count
        
        isShowNote = false
        tableView.reloadData()
    }
    
    func submitResult(collection: Collection){
        // khi kết thúc thì đẩy toàn bộ collection lên history
        db.collection("histories").addDocument(data: collection.dictionary)
    }
}

extension QuizViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return getNumberOfRows()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "QuestionTableViewCell", for: indexPath) as! QuestionTableViewCell
            
            cell.selectionStyle = .none
            cell.titleLabel.text = currentQuestion.question
            return cell
        } else if indexPath.row == getNumberOfRows() - 1 && (type == Type.practice || type == Type.history) {
            let cell = tableView.dequeueReusableCell(withIdentifier: "NoteTableViewCell", for: indexPath) as! NoteTableViewCell
            
            cell.selectionStyle = .none
            if type == Type.practice {
                if isShowNote {
                    cell.containerView.isHidden = false
                    cell.titleLabel.isHidden = false
                    cell.noteLabel.isHidden = false
                    cell.titleLabel.text = "\(currentQuestion.note)"
                } else {
                    cell.containerView.isHidden = true
                    cell.titleLabel.isHidden = true
                    cell.noteLabel.isHidden = true
                    cell.titleLabel.text = ""
                }
            } else {
                cell.containerView.isHidden = false
                cell.titleLabel.isHidden = false
                cell.noteLabel.isHidden = false
                cell.titleLabel.text = "\(currentQuestion.note)"
            }
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "AnswerTableViewCell", for: indexPath) as! AnswerTableViewCell
            let answer = currentQuestion.answers[indexPath.row-1]
            cell.cauTraLoiDung = currentQuestion.answer
            cell.type = type!
            cell.answer = answer
            cell.selectionStyle = .none
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if type == .test || type == .practice{
            // gọi hàm deselectRow khi nhấn vào 1 row, row đó sẽ đc chọn, nhiều khi bị chậm, bỏ đi thì hiệu ứng nó nhanh hơn
            tableView.deselectRow(at: indexPath, animated: true)
            
            for item in currentQuestion.answers{
                item.isSelected = false
            }
            currentQuestion.answers[indexPath.row - 1].isSelected = true
            
            tableView.reloadData()
        }
        
        if type == Type.practice {
            if currentQuestion.answers[indexPath.row - 1].answer == currentQuestion.answer {
                isShowNote = true
            } else {
                isShowNote = false
            }
            tableView.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
