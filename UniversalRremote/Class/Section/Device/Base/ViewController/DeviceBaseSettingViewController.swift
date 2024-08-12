//
//  DeviceBaseSettingViewController.swift
//  UniversalRremote
//
//  Created by Hao Liu on 2024/8/9.
//

import UIKit

class DeviceBaseSettingViewController:LDBaseViewController {
    
    lazy var modelArray:[SettingsListModel] = {
        
        let array:[Any] = [["icon":"deviceVC_set_haptic_icon","title": "Haptic feedback","type":0,"height":63.RW(),"isON":UserDef.shard.isShock]]
        
        let jsonString = JsonUtil.getJSONStringFromArray(array: array)
        
        let modelArray:[SettingsListModel] = JsonUtil.jsonArrayToModel(jsonString, SettingsListModel.self) as! [SettingsListModel]
        
        return modelArray
        
    }()
    
    lazy var tableView:UITableView = {
        
        let cY:CGFloat = titleView.y + titleView.height
        
        let sview:UITableView = UITableView.init(frame: CGRectMake(0, cY, view.width, ScreenH - cY))
        sview.backgroundColor = .clear
        sview.separatorStyle = .none
        sview.showsVerticalScrollIndicator = false
        sview.delegate = self
        sview.dataSource = self
        sview.register(SettingsSwitchCell.self, forCellReuseIdentifier: SettingsSwitchCell.identifier)
        sview.contentInset = UIEdgeInsets(top: marginLR, left: 0, bottom: 0, right: 0)
        if #available(iOS 15.0, *) {
            
            sview.sectionHeaderTopPadding = 0
        }
        
        return sview
    }()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        titleView.model.title = "Settings"
    }
    
    override func addViews() {
        
        super.addViews()
        
        view.addSubview(tableView)
    }
}

extension DeviceBaseSettingViewController:UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return modelArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell:SettingsSwitchCell = tableView.dequeueReusableCell(withIdentifier: SettingsSwitchCell.identifier, for: indexPath) as! SettingsSwitchCell
        
        if indexPath.row < modelArray.count {
            
            cell.model = modelArray[indexPath.row]
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath.row < modelArray.count {
            
            let subModel = modelArray[indexPath.row]
            
            return subModel.height
        }else {
            
            return 0
        }
    }
}

class SettingsSwitchCell:UITableViewCell {
    
    static let identifier:String = "SettingsSwitchCellID"
    
    lazy var backView:UIView = {
        
        let backView:UIView = UIView()
        backView.backgroundColor = UIColor.colorWithHex(hexStr: cellBackColor)
        backView.width = ScreenW
        backView.x = 0
        return backView
    }()
    
    lazy var iconImage:UIImageView = {
        
       let iconImage:UIImageView = UIImageView()
        iconImage.x = marginLR
        iconImage.width = iconWH
        iconImage.height = iconWH
        
        return iconImage
    }()
    lazy var titleLabel:UILabel = {
        
       let titleLabel:UILabel = UILabel()
        titleLabel.font = UIFont.systemFont(ofSize: 14.RW(), weight: .medium)
        titleLabel.textColor = UIColor.colorWithHex(hexStr: whiteColor, alpha: 0.7)
        titleLabel.x = iconImage.x + iconImage.width + 8.RW()
        
        return titleLabel
    }()
    
    lazy var isONBtn:UISwitch = {
        
        let isONBtn:UISwitch = UISwitch()
        isONBtn.x = backView.width - 16.RW() - isONBtn.width
        isONBtn.isOn = true;
        isONBtn.addTarget(self, action: #selector(isONBtnClick(btn:)), for:.valueChanged)
       
        return isONBtn
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupUI()
        addSubview1()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI() {
        
        backgroundColor = UIColor.colorWithHex(hexStr: cellBackColor)
        selectionStyle = .none
    }
    
    func addSubview1() {
        
        contentView.addSubview(backView)
        backView.addSubview(iconImage)
        backView.addSubview(titleLabel)
        backView.addSubview(isONBtn)
    }
    
    @objc func isONBtnClick(btn:UISwitch) {
        UserDef.shard.isShock = btn.isOn
        UserDef.saveKeyWithValue(key: "isShock", value: btn.isOn)
    }
    
    var model:SettingsListModel = SettingsListModel() {
        
        didSet {
            
            backView.height = model.height - 32.RW()
            backView.centerY = model.height / 2
            
            iconImage.centerY = backView.height / 2
            iconImage.image = UIImage(named: model.icon)
            
            titleLabel.text = model.title
            titleLabel.sizeToFit()
            titleLabel.centerY = backView.height / 2
            
            backView.cornerCut(radius: 12.RW(), corner: .allCorners)
            
            isONBtn.centerY = backView.height / 2
            
            isONBtn.isOn = UserDef.shard.isShock
        }
    }
}

class SettingsListModel:BaseModel {
    
    var icon:String = ""
    var title:String = ""
    var isON:Bool = true
    var height:CGFloat = 63.RW()
//    var type:Int = 0
//    var isTop:Bool = false
//    var isBottom:Bool = false
}

