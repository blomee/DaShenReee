//
//  EnvEnvSwitchController.swift
//  venom
//
//  Created by BLOM on 8/23/22.
//  Copyright © 2022 Venom. All rights reserved.
//

import UIKit

class EnvSwitchController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    typealias CallbackHandler = ((_ model: SwitchModel) -> Void)
    
    
    /// 环境地址
    public var dataArray = [SwitchModel]() {
        didSet {
            if dataArray.count == 0 {
                return
            }
            self.tableView.reloadData()
        }
    }
    
    var selectedModel : SwitchModel?
    var configSelected : CallbackHandler?
    
    
    lazy var tableView : UITableView = {
        let tableView = UITableView.init(frame: CGRect.init(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height), style: .plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        tableView.separatorStyle = .none
        tableView.showsHorizontalScrollIndicator = false
        tableView.showsVerticalScrollIndicator = false
        tableView.estimatedRowHeight = 100;
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedSectionHeaderHeight = 0;
        tableView.estimatedSectionFooterHeight = 0;
        tableView.delaysContentTouches = true
        tableView.contentInsetAdjustmentBehavior = .automatic
        return tableView
    }()
    
    lazy var button : UIButton = {
        let button = UIButton.init(type: .custom)
        button.frame = CGRect.init(x: 0, y: 0, width: 80, height: 44)
        button.contentHorizontalAlignment = .right
        button.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        button.titleLabel?.adjustsFontSizeToFitWidth = true
        button.setTitleColor(.black, for: .normal)
        button.setTitleColor(.lightGray, for: .highlighted)
        
        button.setTitle("确认", for: .normal)
        button.addTarget(self, action: #selector(changeNetwork), for: .touchUpInside)
        return button
    }()
    
    lazy var backBtn : UIButton = {
        let button = UIButton.init(type: .custom)
        button.frame = CGRect.init(x: 0, y: 0, width: 80, height: 44)
        button.contentHorizontalAlignment = .left
        button.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        button.titleLabel?.adjustsFontSizeToFitWidth = true
        button.setTitleColor(.black, for: .normal)
        button.setTitleColor(.lightGray, for: .highlighted)
        button.setTitle("取消", for: .normal)
        button.addTarget(self, action: #selector(goBack), for: .touchUpInside)
        return button
    }()
    
    var selectedName : String?
    var selectedIndexPath : IndexPath?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "网络环境配置"
        self.view.backgroundColor = .white
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem.init(customView: backBtn)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(customView: button)
        self.view.addSubview(tableView)
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "cellID")
        if  cell == nil {
            cell = UITableViewCell.init(style: .subtitle, reuseIdentifier: "cellID")
        }
        
        cell?.accessoryType = .none
        cell?.detailTextLabel?.font = UIFont.systemFont(ofSize: 12)
        cell?.textLabel?.textColor = .black
        cell?.detailTextLabel?.textColor = .lightGray
        cell?.detailTextLabel?.numberOfLines = 0
        
        let model = dataArray[indexPath.row]
        
        cell?.textLabel?.text = model.title
        cell?.detailTextLabel?.text = model.app_api_url
        
        let indexValue = AppConfig.shared.currentEnvIndex
        if indexPath.row == indexValue-1 {
            cell?.accessoryType = .checkmark
            cell?.textLabel?.textColor = .red
            cell?.detailTextLabel?.textColor = .black
            selectedIndexPath = indexPath
        }
        
        return cell ?? UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let model = dataArray[indexPath.row]
        selectedModel = model
        
        if selectedIndexPath != nil {
            let last = tableView.cellForRow(at: selectedIndexPath!)
            last?.accessoryType = .none
            last?.textLabel?.textColor = .black
            last?.detailTextLabel?.textColor = .lightGray
        }
        let now = tableView.cellForRow(at: indexPath)
        now?.accessoryType = .checkmark
        now?.textLabel?.textColor = .red
        now?.detailTextLabel?.textColor = .black
        selectedIndexPath = indexPath
        
    }
    
    
    // 确认
    @objc
    public func changeNetwork() {
        guard let callback = configSelected, let model = selectedModel else {
            return
        }
//        showProgress()
        if let index = selectedIndexPath?.row {
            
            DispatchQueue.global().async {//并行、异步
                UserDefaults.standard.set(index+1, forKey: kSaveEnvSelectedIndex)
                UserDefaults.standard.set(nil, forKey: "VNAPI_URL_Key")
                UserDefaults.standard.synchronize()
            }
            
            delayWithSeconds(2.0) {
//                hideProgress()
                
                callback(model)
                self.dismiss(animated: true) {
                    
                }
            }
        } else {
            BMLog("11111")
        }
        
        
    }
    
    @objc
    public func goBack() {
        self.dismiss(animated: true) {
            
        }
    }
}
