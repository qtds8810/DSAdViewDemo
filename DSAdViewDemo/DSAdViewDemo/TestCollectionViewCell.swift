//
//  TestCollectionViewCell.swift
//  DSAdViewDemo
//
//  Created by 左得胜 on 2018/8/16.
//  Copyright © 2018年 得胜. All rights reserved.
//

import UIKit

class TestCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    
    required init?(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)
        
//        layoutIfNeeded()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    func setupModel(model: Any) {
        guard let text = model as? String else { return }
        titleLabel.text = text
    }

}
