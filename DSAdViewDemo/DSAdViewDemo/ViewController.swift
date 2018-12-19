//
//  ViewController.swift
//  DSAdViewDemo
//
//  Created by 左得胜 on 2018/8/15.
//  Copyright © 2018年 得胜. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    // MARK: - Property
    // MARK: Public
    
    
    // MARK: Private
    private lazy var adView: DSAdView = {
        let adView = DSAdView.init(frame: CGRect(origin: CGPoint.zero, size: CGSize(width: view.frame.width, height: 200))) { (builder) in
            // 这里等比例
            builder.adItemSize = CGSize(width: view.bounds.size.width / 2.5, height: view.bounds.size.width * 0.25)
            builder.minimumLineSpacing = 50
            builder.secondaryItemMinAlpha = 0.8
            builder.threeDimensionalScale = 1.45
            builder.scrollDirection = .horizontal
            builder.isInfinite = true
            builder.isAutoPlay = true
        }
        adView.register(UINib(nibName: "TestCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "TestCollectionViewCell")
        adView.dataSource = self
        adView.delegate = self
        adView.backgroundColor = UIColor.groupTableViewBackground
        
        return adView
    }()
    private lazy var dataArr: [String] = ["测试0", "测试1", "测试2", "测试3"]
    
    private lazy var myTableView: UITableView = {
        let myTableView = UITableView.init(frame: view.bounds, style: .plain, estimatedRowHeight: 50, dataSource: self, delegate: self)
        myTableView.registerCell(DSRecommendTableViewCell.self)
        
        return myTableView
    }()
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    
    // MARK: - Action
    
}

// MARK: - Private Method
private extension ViewController {
    func setupUI() {
        view.addSubview(myTableView)
        
        myTableView.tableHeaderView = adView
        
        dataArr.append("测试~~")
        adView.reloadData()
        
    }
}

// MARK: - DSAdViewDataSource, DSAdViewDelegate
extension ViewController: DSAdViewDataSource, DSAdViewDelegate {
    func adView(_ adView: DSAdView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = adView.dequeueReusableCell(withReuseIdentifier: "TestCollectionViewCell", for: indexPath) as? TestCollectionViewCell else { return DSAdViewCell()}
        
        cell.backgroundColor = UIColor.black
        cell.setupModel(model: String(indexPath.row) + dataArr[indexPath.row])
        
        return cell
    }
    
    func numberOfItems(in adView: DSAdView) -> Int {
        return dataArr.count
    }
    
    func adView(_ adView: DSAdView, didSelectItemAt index: Int) {
        print(#file, "点击了：\(index)***)")
//        if self.adView == adView {
//            tmpSelectedIndex = index
//            adView.isAutoPlay = false
//            let scrollCard = DSScrollCard.init(animationType: .scale, delegate: self, originPageIndex: index)
//            scrollCard.show()
//        } else {
//            global_showAlert(message: "我是详情轮播图")
//        }
    }
    
}

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 50
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(DSRecommendTableViewCell.self, for: indexPath)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
//    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        menuView.frame.size.width = tableView.frame.width
//        return menuView
//    }
//
//    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//        return menuView.frame.height
//    }
    
}

//extension ViewController: DSMenuDataSource, DSMenuDelegate {
//    func numberOfColumnsInMenu(_ menu: DSMenu) -> Int {
//        return menuData.count
//    }
//
//    func menu(_ menu: DSMenu, numberOfRowsInColumn column: Int) -> Int {
//        return menuData[column].count
//    }
//
//    func menu(_ menu: DSMenu, titleForRowAtIndexPath indexPath: DSMenu.Index) -> String {
//        return menuData[indexPath.column][indexPath.row]
//    }
//
//    func menu(_ menu: DSMenu, didSelectRowAtIndexPath indexPath: DSMenu.Index) {
//        QL1("")
//    }
//
//}
