//
//  UITableView+Extension.swift
//  CrazyFutures
//
//  Created by 左得胜 on 2018/4/26.
//  Copyright © 2018年 左得胜. All rights reserved.
//

import UIKit

extension UITableView {
    
    /// 便利构造tableView
    ///
    /// - Parameters:
    ///   - frame: frame
    ///   - style: style
    ///   - estimatedRowHeight: 是否需要预估高度，否的话请为nil或省略该参数
    ///   - dataSource: UITableViewDataSource
    ///   - delegate: UITableViewDelegate
    convenience init(frame: CGRect, style: UITableView.Style, estimatedRowHeight: CGFloat? = nil, dataSource: UITableViewDataSource? = nil, delegate: UITableViewDelegate? = nil) {
        self.init(frame: frame, style: style)
        
        backgroundColor = UIColor.groupTableViewBackground
        
        let footerView = UIView()
        footerView.backgroundColor = backgroundColor
        footerView.frame.size.height = 8
        tableFooterView = footerView
        
        if let estimatedRowHeight = estimatedRowHeight {
            rowHeight = UITableView.automaticDimension
            self.estimatedRowHeight = estimatedRowHeight
        }
        
        self.dataSource = dataSource
        self.delegate = delegate
    }
    
    func registerCell<T: UITableViewCell>(_ type: T.Type) {
        let identifier = String(describing: type.self)
        register(type, forCellReuseIdentifier: identifier)
    }
    
    func registerNibCell<T: UITableViewCell>(_ type: T.Type) {
        let cell = String(describing: type.self)
        register(UINib.init(nibName: cell, bundle: nil), forCellReuseIdentifier: cell)
    }
    
    func dequeueReusableCell<T: UITableViewCell>(_ type: T.Type, for indexPath: IndexPath) -> T {
        let identifier = String(describing: type.self)
        guard let cell = dequeueReusableCell(withIdentifier: identifier, for: indexPath) as? T else {
            fatalError("\(type.self) was not registered")
        }
        return cell
    }
}
