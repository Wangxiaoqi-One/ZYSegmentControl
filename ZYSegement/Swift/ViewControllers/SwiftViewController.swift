//
//  SwiftViewController.swift
//  ZYSegement
//
//  Created by 三小时梦想 on 2020/11/6.
//  Copyright © 2020 三小时梦想. All rights reserved.
//

import UIKit

class SwiftViewController: UIViewController {

    private var fonts: [String] = []
    
    lazy private var tableView : UITableView = {[weak self] in
        let tableView = UITableView(frame: (self?.view.frame)!, style: .plain)
        tableView.backgroundColor = .white
        tableView.rowHeight = 44
        tableView.dataSource = self!
        tableView.delegate = self!
        tableView.register(UITableViewCell.classForCoder(), forCellReuseIdentifier: "cellid")
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.view.backgroundColor = .white
        self.edgesForExtendedLayout = UIRectEdge()
        self.navigationController?.navigationBar.isTranslucent = false
        self.view.addSubview(self.tableView)
        
        self.fonts = UIFont.familyNames
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
extension SwiftViewController : UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.fonts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "cellid", for: indexPath)
        cell.textLabel?.text = self.fonts[indexPath.row];
        return cell
    }
    
    
}
