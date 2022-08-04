//
//  SlideMenuViewController.swift
//  AppQuiz
//
//  Created by Taof on 8/28/19.
//  Copyright © 2019 Taof. All rights reserved.
//

import UIKit

class SlideMenuViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    var menus = [Menu]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        createData()
        setupTableView()
    }

    func setupTableView(){
        tableView.delegate = self
        tableView.dataSource = self
        tableView.bounces = false
        tableView.tableFooterView = UIView()
        tableView.register(UINib(nibName: "MenuCell", bundle: nil), forCellReuseIdentifier: "cell")
    }
    
    func createData(){
        let cell1 = Menu(icon: "quiz", name: "Kiểm tra")
        let cell2 = Menu(icon: "learn", name: "Luyện tập")
        let cell3 = Menu(icon: "history", name: "Lịch sử")
        let cell4 = Menu(icon: "manual", name: "Hướng dẫn sử dụng")
        
        menus = [cell1, cell2, cell3, cell4]
    }
}

extension SlideMenuViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menus.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! MenuCell
        cell.menu = menus[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.width, height: 80))
        
        imageView.image = UIImage(named: "quizTime")
        imageView.contentMode = .scaleAspectFill
        return imageView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 200
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let name = menus[indexPath.row].name
        if name == "Kiểm tra" {
            
            let mainVC = MainViewController()
            mainVC.type = .test
            let navigationVC = UINavigationController(rootViewController: mainVC)
            self.slideMenuController()?.changeMainViewController(navigationVC, close: true)
            
        } else if name == "Lịch sử" {
            
            let historyVC = MainViewController()
            historyVC.type = .history
            let navigationVC = UINavigationController(rootViewController: historyVC)
            self.slideMenuController()?.changeMainViewController(navigationVC, close: true)
            
        } else if name == "Hướng dẫn sử dụng" {
            
            let manualVC = UserManualViewController()
            let navigationVC = UINavigationController(rootViewController: manualVC)
            self.slideMenuController()?.changeMainViewController(navigationVC, close: true)
            
        } else if name == "Luyện tập" {
            
            let practiceVC = MainViewController()
            practiceVC.type = .practice
            let navigationVC = UINavigationController(rootViewController: practiceVC)
            self.slideMenuController()?.changeMainViewController(navigationVC, close: true)
        }
    }
}
