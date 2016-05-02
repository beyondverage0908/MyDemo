//
//  ViewController.swift
//  UIPerformanceTestDemo
//
//  Created by linsir on 16/4/30.
//  Copyright © 2016年 linsir. All rights reserved.
//

import UIKit

let Cell_Identifier = "sir_identifier"

class ViewController: UIViewController  {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let screen_w = UIScreen.mainScreen().bounds.width
        let screen_h = UIScreen.mainScreen().bounds.height
        
        let tableView = UITableView.init(frame: CGRectMake(0, 0, screen_w, screen_h), style: .Plain)
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.registerNib(UINib.init(nibName: "SirTableViewCell", bundle: NSBundle.mainBundle()), forCellReuseIdentifier: Cell_Identifier)
        
        
        self.view.addSubview(tableView)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}


extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell: SirTableViewCell = tableView.dequeueReusableCellWithIdentifier(Cell_Identifier) as! SirTableViewCell
        return cell
    }
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        let cell: SirTableViewCell = cell as! SirTableViewCell
        
        if indexPath.row == 0 {
            cell.imageName = "photo_0"
        } else if indexPath.row == 1 {
            cell.imageName = "photo_1"
        } else if indexPath.row == 2 {
            cell.imageName = "photo_2"
        } else if indexPath.row == 3 {
            cell.imageName = "photo_3"
        } else if indexPath.row == 4 {
            cell.imageName = "photo_4"
        }
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 150
    }
    
}

