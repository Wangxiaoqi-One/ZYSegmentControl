//
//  ViewController.swift
//  ZYSegement
//
//  Created by 三小时梦想 on 2020/9/1.
//  Copyright © 2020 三小时梦想. All rights reserved.
//

import UIKit


let SCREEN_WIDTH = UIScreen.main.bounds.width
let SCREEN_HEIGHT = UIScreen.main.bounds.height
let CELLID = "CELLID"

class ViewController: UIViewController {
    
    lazy private var tableView : UITableView = {[weak self] in
        let tableView = UITableView(frame: self!.view.frame, style: .plain)
        tableView.backgroundColor = .white
        tableView.delegate = self!
        tableView.dataSource = self!
        tableView.register(UITableViewCell.classForCoder(), forCellReuseIdentifier: CELLID)
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.title = "分类控制"
        self.view.backgroundColor = .white
        self.view.addSubview(self.tableView)
    }


}
extension ViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : UITableViewCell = tableView.dequeueReusableCell(withIdentifier: CELLID, for: indexPath)
        cell.selectionStyle = .none
        if indexPath.row == 0 {
            cell.textLabel?.text = "swift"
        } else {
            cell.textLabel?.text = "OC"
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            self.navigationController?.pushViewController(SwiftViewController(), animated: true)
        } else {
            self.navigationController?.pushViewController(OCViewController(), animated: true)
        }
    }
    
}

