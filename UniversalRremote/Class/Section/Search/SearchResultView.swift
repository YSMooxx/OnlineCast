//
//  SearchResultView.swift
//  UniversalRremote
//
//  Created by Hao Liu on 2024/8/8.
//

import UIKit

class SearchResultView:UIView {
    
    var modelCallBack:(_ model:searchDeviceCellModel?) -> () = {model in}
    
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
            
            modelCallBack(deviceModelArray[indexPath.row])
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
        
        sview.width = 44.RW()
        sview.height = 44.RW()
        sview.x = marginLR
        sview.centerY = backView.height / 2
        
        return sview
    }()
    
    lazy var titleLabel:UILabel = {
        
       let sview:UILabel = UILabel()
        sview.font = UIFont.systemFont(ofSize: 16.RW(), weight: .medium)
        sview.textColor = UIColor.colorWithHex(hexStr: whiteColor)
        sview.x = iconImage.x + iconImage.width + 12.RW()
        sview.numberOfLines = 1
        sview.width = connectSucIcon.x - sview.x - marginLR
        return sview
    }()
    
    lazy var connectSucIcon:UIImageView = {
        
        let sview:UIImageView = UIImageView(image: UIImage(named: "searcch_connect_suc_icon"))
        
        sview.width = 24.RW()
        sview.height = 24.RW()
        sview.centerY = backView.height / 2
        sview.x = backView.width - marginLR - sview.width
        sview.isHidden = true
        return sview
    }()
    
    lazy var connectSucView:UIView = {
        
        let sview:UIView = UIView()
        
        sview.width = 4.RW()
        sview.height = 4.RW()
        sview.y = iconImage.y + 12.RW()
        sview.x = iconImage.x + iconImage.width + 12.RW()
        sview.backgroundColor = UIColor.colorWithHex(hexStr: "#3AE875")
        sview.cornerCut(radius: sview.height / 2, corner: .allCorners)
        sview.isHidden = true
        return sview
    }()
    
    lazy var connectSucLabel:UILabel = {
        
        let sview:UILabel = UILabel()
        
        sview.text = "Connected"
        sview.textColor = UIColor.colorWithHex(hexStr: "#3AE875")
        sview.font = UIFont.systemFont(ofSize: 14.RW(), weight: .medium)
        sview.sizeToFit()
        sview.centerY = connectSucView.centerY
        sview.x = connectSucView.x + connectSucView.width + 2.RW()
        sview.isHidden = true
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
        backView.addSubview(connectSucIcon)
        backView.addSubview(connectSucView)
        backView.addSubview(connectSucLabel)
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
            titleLabel.width = connectSucIcon.x - titleLabel.x - marginLR
            
            if (model?.isConnect ?? false) {
                
                titleLabel.y = backView.height - titleLabel.height - 8.RW()
            }else {
                
                titleLabel.centerY = backView.height / 2
            }
            connectSucIcon.isHidden = !(model?.isConnect ?? false)
            connectSucView.isHidden = !(model?.isConnect ?? false)
            connectSucLabel.isHidden = !(model?.isConnect ?? false)
        }
    }
}

class searchDeviceCellModel {
    
    var smodel:Device?
    var height:CGFloat = 72.RW()
    var isConnect:Bool = false
}
