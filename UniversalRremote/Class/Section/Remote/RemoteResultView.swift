//
//  RemoteResultView.swift
//  UniversalRremote
//
//  Created by Hao Liu on 2024/8/7.
//

import UIKit

class RemoteResultView:UIView {
    
    let footerID:String = "SearchResulViewControllerFooterID"
    
    var indexCallBack:(_ oper:String,_ index:Int,_ model:RemoteDListCollectionCellModel) -> () = {oper,index,model in}
    
    var deviceModelArray:[RemoteDListCollectionCellModel] = [] {
        
        didSet {
            
            collectionView.reloadData()
        }
    }
    
    let lineSpacing:CGFloat = 15.RW()
    let interitemSpacing:CGFloat = marginLR
    
    lazy var collectionView:UICollectionView = {
        
        let layout = WaterfallMutiSectionFlowLayout()
        layout.delegate = self
        let sview:UICollectionView = UICollectionView.init(frame: CGRect(x: 0, y: 0, width: width, height: height),  collectionViewLayout: layout)
        
        sview.dataSource = self
        sview.delegate = self
        sview.showsVerticalScrollIndicator = false
        sview.register(RemoteDListCollectionCell.self, forCellWithReuseIdentifier: RemoteDListCollectionCell.Identifier)
        sview.backgroundColor = UIColor.colorWithHex(hexStr: dBackColor)
        sview.contentInsetAdjustmentBehavior = .never
        sview.contentInset = UIEdgeInsets(top: marginLR, left: 0, bottom: safeHeight > 0 ? safeHeight : marginLR ,right: 0)

        return sview
        
    }()
    
    lazy var renameView:RemoteDRenameView = {
        
        let sview:RemoteDRenameView = RemoteDRenameView(frame: CGRect(x: 0, y: 0, width: ScreenW, height: ScreenH))
        
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
        
        addSubview(collectionView)
    }
    
    func startEdit(index:Int) {
        
        if index < deviceModelArray.count {
            
            for (i,model) in deviceModelArray.enumerated() {
                
                if i == index {
                    
                    model.isEdit = true
                }else {
                    model.isEdit = false
                }
            }
        }
        
        collectionView.reloadData()
    }
    
    func closeEdit() {
        
        for model in deviceModelArray {
            
            model.isEdit = false
        }
        
        collectionView.reloadData()
    }
    
    func delete(index:Int) {
        
        if index < deviceModelArray.count {
            
            deviceModelArray.remove(at: index)
        }
        
        var deviceArray:[Device] = []
        
        for smodel in deviceModelArray {
            
            guard let deviceModel = smodel.smodel else {break}
            
            deviceArray.append(deviceModel)
        }
        
        RemoteDMananger.mananger.removeDeivce(devices: deviceArray)
    }
    
    func rename(index:Int,name:String) {
        
        renameView.showView(content: name)
        
        renameView.callBack = {[weak self] (text) in
            
            guard let self else {return}
            if text == Click_close {
                
                self.closeEdit()
            }
        }
        
        renameView.resultCallBack = {text in
            
            RemoteDMananger.mananger.renameDevice(name: text, index: index)
        }
    }
}

extension RemoteResultView:WaterfallMutiSectionDelegate,UICollectionViewDataSource,UICollectionViewDelegate {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return deviceModelArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell:RemoteDListCollectionCell = collectionView.dequeueReusableCell(withReuseIdentifier: RemoteDListCollectionCell.Identifier, for: indexPath) as! RemoteDListCollectionCell
        
        if indexPath.row < deviceModelArray.count {
            
            let smodel = deviceModelArray[indexPath.row]
            
            cell.model = smodel
            
            cell.callBack = {[weak self] (text) in
                
                if text == "startEdit" {
                    
                    self?.startEdit(index: indexPath.row)
                }else if text == "closeEdit" {
                    
                    self?.closeEdit()
                }else if text == "delete" {
                    
                    self?.delete(index: indexPath.row)
                }else if text == "rename" {
                    
                    self?.rename(index: indexPath.row, name: smodel.smodel?.reName ?? "")
                }
            }
        }
        
        return cell
    }
    
    func heightForRowAtIndexPath(collectionView collection: UICollectionView, layout: WaterfallMutiSectionFlowLayout, indexPath: IndexPath, itemWidth: CGFloat) -> CGFloat {
        
        if indexPath.row < deviceModelArray.count {
            
            let smodel = deviceModelArray[indexPath.row]
            
            return smodel.height
        }else {
            
            return 0
        }
        
    }
    
    func lineSpacing(collectionView collection: UICollectionView, layout: WaterfallMutiSectionFlowLayout, section: Int) -> CGFloat {
        
        return lineSpacing
    }
    
    func interitemSpacing(collectionView collection: UICollectionView, layout: WaterfallMutiSectionFlowLayout, section: Int) -> CGFloat {
        
        return interitemSpacing
    }
}

class RemoteDListCollectionCell:UICollectionViewCell {
    
    static let Identifier:String = "RemoteDListCollectionCellID"
    
    var callBack:callBack = {text in }
    
    var model:RemoteDListCollectionCellModel? {
        
        didSet {
            
            if model?.smodel?.type == Roku {
                
                backView.image = UIImage(named: "remoteD_roku_back")
                
            }else if model?.smodel?.type == Fire {
                
                backView.image = UIImage(named: "remoteD_fire_back")
            }else if model?.smodel?.type == WebOS {
                
                backView.image = UIImage(named: "remoteD_webos_back")
            }
            
            nameLabel.text = model?.smodel?.reName
            nameLabel.sizeToFit()
            if nameLabel.width > width - 2 * marginLR {
                 
                nameLabel.width = width - 2 * marginLR
            }
            nameLabel.centerX = width / 2
            nameLabel.centerY = height - 21.5.RW()
            
            editView.isHidden = !(model?.isEdit ?? false)
        }
    }
    
    lazy var backView:UIImageView = {
        
        let sview:UIImageView = UIImageView(frame: bounds)
        sview.isUserInteractionEnabled = true
        
        return sview
    }()
    
    lazy var nameLabel:UILabel = {
        
        let sview:UILabel = UILabel()
        sview.font = UIFont.systemFont(ofSize: 16.RW(), weight: .regular)
        sview.textColor = UIColor.colorWithHex(hexStr: whiteColor)
        
        return sview
    }()
    
    lazy var editBtn:UIButton = {
        
        let cWH:CGFloat = iconWH
        let cXY:CGFloat = 12.RW()
        let sview:UIButton = UIButton()
        sview.width = cWH
        sview.height = cWH
        sview.x = backView.width - cWH - cXY
        sview.y = cXY
        sview.setImage(UIImage(named: "remoteD_rename_icon"), for: .normal)
        sview.addTarget(self, action: #selector(editBtnClick), for: .touchUpInside)
        return sview
    }()
    
    lazy var editView:UIView = {
        
        let sview:UIView = UIView(frame: bounds)
        sview.backgroundColor = UIColor.colorWithHex(hexStr: blackColor, alpha: 0.6)
        sview.isHidden = true
        return sview
    }()
    
    lazy var closeEditBtn:UIButton = {
        
        let cWH:CGFloat = iconWH
        let cXY:CGFloat = 12.RW()
        let sview:UIButton = UIButton()
        sview.width = cWH
        sview.height = cWH
        sview.x = editView.width - cWH - cXY
        sview.y = cXY
        sview.setBackgroundImage(UIImage(named: "remoteD_close_icon"), for: .normal)
        sview.addTarget(self, action: #selector(closeEditBtnClick), for: .touchUpInside)
        
        return sview
    }()
    
    lazy var deleteEditBtn:UIButton = {
        
        let cXY:CGFloat = 12.RW()
        let sview:UIButton = UIButton()
        sview.width = 110.RW()
        sview.height = 44.RW()
        sview.centerX = editView.width / 2
        sview.y = 48.RW()
        sview.setTitle("Delete", for: .normal)
        sview.backgroundColor = UIColor.colorWithHex(hexStr: whiteColor)
        sview.setTitleColor(UIColor.colorWithHex(hexStr: "#0A0A0A"), for: .normal)
        sview.titleLabel?.font = UIFont.systemFont(ofSize: 16.RW(), weight: .regular)
        sview.addTarget(self, action: #selector(deleteEditBtnClick), for: .touchUpInside)
        sview.cornerCut(radius: 12.RW(), corner: .allCorners)
        
        return sview
    }()
    
    lazy var renameEditBtn:UIButton = {
        
        let cXY:CGFloat = 12.RW()
        let sview:UIButton = UIButton()
        sview.width = 110.RW()
        sview.height = 44.RW()
        sview.centerX = editView.width / 2
        sview.y = deleteEditBtn.y + deleteEditBtn.height + 16.RW()
        sview.setTitle("Rename", for: .normal)
        sview.backgroundColor = UIColor.colorWithHex(hexStr: whiteColor)
        sview.setTitleColor(UIColor.colorWithHex(hexStr: "#0A0A0A"), for: .normal)
        sview.titleLabel?.font = UIFont.systemFont(ofSize: 16.RW(), weight: .regular)
        sview.addTarget(self, action: #selector(renameEditBtnClick), for: .touchUpInside)
        sview.cornerCut(radius: 12.RW(), corner: .allCorners)
        
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
        
        contentView.backgroundColor = .clear
    }
    
    func addViews() {
        
        contentView.addSubview(backView)
        backView.addSubview(nameLabel)
        backView.addSubview(editBtn)
        
        contentView.addSubview(editView)
        editView.addSubview(closeEditBtn)
        editView.addSubview(deleteEditBtn)
        editView.addSubview(renameEditBtn)
    }
    
    @objc func editBtnClick() {
        
        callBack("startEdit")
    }
    
    @objc func closeEditBtnClick() {
        
        callBack("closeEdit")
    }
    
    @objc func deleteEditBtnClick() {
        
        callBack("delete")
    }
    
    @objc func renameEditBtnClick() {
        
        callBack("rename")
    }
    
}

class RemoteDListCollectionCellModel {
    
    var smodel:Device?
    
    var isEdit:Bool = false
    
    var height:CGFloat = 183.RW()
}

