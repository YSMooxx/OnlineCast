//
//  SearchResultView.swift
//  UniversalRremote
//
//  Created by Hao Liu on 2024/8/8.
//

import UIKit

class SearchResultView:UIView {
    
    var modelCallBack:(_ model:Device?) -> () = {model in}
    
    var deviceModelArray:[searchDeviceCellModel] = [] {
        
        didSet {
            
            DispatchQueue.main.async {[weak self] in
                
                self?.tableView.reloadData()
            }
            
        }
    }
    
    lazy var tableView:UITableView = {
        
        let sview:UITableView = UITableView.init(frame: bounds)
        sview.backgroundColor = .clear
        sview.separatorStyle = .none
        sview.showsVerticalScrollIndicator = false
        sview.delegate = self
        sview.dataSource = self
        sview.register(searchDeviceCell.self, forCellReuseIdentifier: searchDeviceCell.identifier)
        if #available(iOS 15.0, *) {
            
            sview.sectionHeaderTopPadding = 0
        }
        sview.contentInset = UIEdgeInsets(top: marginLR, left: 0, bottom: safeHeight > 0 ? safeHeight : marginLR, right: 0)
        return sview
    }()
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        
        setupUI()
        addViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI() {
        
        backgroundColor = .clear
    }
    
    func addViews() {
        
        addSubview(tableView)
    }
}

extension SearchResultView:UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return deviceModelArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell:searchDeviceCell = tableView.dequeueReusableCell(withIdentifier: searchDeviceCell.identifier, for: indexPath) as! searchDeviceCell
         
        if indexPath.row < deviceModelArray.count {
            
            cell.model = deviceModelArray[indexPath.row]
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 72.RW()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.row < deviceModelArray.count {
            
            modelCallBack(deviceModelArray[indexPath.row].smodel ?? nil)
        }
    }
    
}

class searchDeviceCell:UITableViewCell {
    
    static let identifier:String = "searchDeviceCellID"
    
    lazy var backView:UIView = {
       
        let sview:UIView = UIView(frame: CGRect(x: marginLR, y: 0.RW(), width: 343.RW(), height: 56.RW()))
        sview.backgroundColor = UIColor.colorWithHex(hexStr: "#292929")
        sview.cornerCut(radius: 12.RW(), corner: .allCorners)
        return sview
    }()
    
    lazy var iconImage:UIImageView = {
        
        let sview:UIImageView = UIImageView()
        
        sview.width = 32.RW()
        sview.height = 32.RW()
        sview.x = marginLR
        sview.centerY = backView.height / 2
        
        return sview
    }()
    
    lazy var titleLabel:UILabel = {
        
       let sview:UILabel = UILabel()
        sview.font = UIFont.systemFont(ofSize: 16.RW(), weight: .medium)
        sview.textColor = UIColor.colorWithHex(hexStr: whiteColor)
        sview.x = iconImage.x + iconImage.width + 12.RW()
        
        return sview
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupUI()
        addViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI() {
        
        backgroundColor = .clear
        selectionStyle = .none
    }
    
    func addViews() {
        
        contentView.addSubview(backView)
        backView.addSubview(iconImage)
        backView.addSubview(titleLabel)
    }
    
    var model:searchDeviceCellModel? {
        
        didSet {
            
            if model?.smodel?.type == Roku {
                
                iconImage.image = UIImage(named: "searcch_roku_icon")
            }else if  model?.smodel?.type == Fire {
                
                iconImage.image = UIImage(named: "searcch_fire_icon")
            }else if  model?.smodel?.type == WebOS {
                
                iconImage.image = UIImage(named: "searcch_webos_icon")
            }
            
            titleLabel.text = model?.smodel?.friendlyName
            titleLabel.sizeToFit()
            titleLabel.centerY = backView.height / 2
        }
    }
}

class searchDeviceCellModel {
    
    var smodel:Device?
    var height:CGFloat = 72.RW()
}
