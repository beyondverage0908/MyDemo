//
//  SirTableViewCell.swift
//  UIPerformanceTestDemo
//
//  Created by linsir on 16/4/30.
//  Copyright © 2016年 linsir. All rights reserved.
//

import UIKit

class SirTableViewCell: UITableViewCell {
    
    var imageName: String? {
        didSet {
            headerImageView.image = UIImage(named: imageName!)
        }
    }
    
    @IBOutlet weak var demoLabel: UILabel!
    @IBOutlet weak var headerImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        //demoLabel.opaque = true
        //demoLabel.backgroundColor = UIColor.whiteColor()
        //demoLabel.layer.shouldRasterize = true //开启光栅化操作，用于将图层转化为bitmap，用于缓存策略
        
        headerImageView.layer.shadowColor = UIColor.blackColor().CGColor
        headerImageView.layer.shadowRadius = 2
        headerImageView.layer.shadowOpacity = 1
        headerImageView.layer.shadowOffset = CGSizeMake(2, 1)
//        headerImageView.layer.shadowPath = UIBezierPath(rect: headerImageView.bounds).CGPath // 指定阴影曲线，防止阴影效果带来的离屏渲染
        
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
}
