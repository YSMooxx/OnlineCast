//
//  DeviceChannelCell.swift
//  UniversalRremote
//
//  Created by Hao Liu on 2024/8/12.
//

import UIKit

class ChannelResultListModel {
    
    var model:RokuChannelResultListDataModel?
    
    var fireModel:FireChannelResultListDataModel?
    
    var height:CGFloat = 88.RW()
}

class ChannelListCollectionCell:UICollectionViewCell {
    
    static let Identifier:String = "ChannelListCollectionCellID"
    
    var callBack:callBack = {text in}
    
    lazy var imageBtn:UIImageView = {
        
        let sview:UIImageView = UIImageView()
        sview.frame = bounds
        sview.backgroundColor = UIColor.colorWithHex(hexStr: "#666666", alpha: 0.8)
        sview.cornerCut(radius: 12.RW(), corner: .allCorners)
        sview.backgroundColor = UIColor.colorWithHex(hexStr: cellBackColor)
        sview.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTapGesture(_:)))
        sview.addGestureRecognizer(tapGesture)
        sview.contentMode = .scaleAspectFill
        sview.clipsToBounds = true
        
        return sview
    }()
    
    lazy var collectBtn:EnlargeBtn = {
        let cWY:CGFloat = 24.RW()
        let sview:EnlargeBtn = EnlargeBtn()
        sview.frame = CGRect(x: imageBtn.width - cWY, y: 0, width: cWY, height: cWY)
        sview.setBackgroundImage(UIImage.init(named: "channel_collect_unsel"), for: .normal)
        sview.setBackgroundImage(UIImage.init(named: "channel_collect_sel"), for: .selected)
        sview.addTarget(self, action: #selector(collectBtnClick(btn:)), for: .touchUpInside)
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
        
        contentView.addSubview(imageBtn)
        contentView.addSubview(collectBtn)
    }
    
    var model:ChannelResultListModel? {
        
        didSet {
            
            if model?.model != nil {
                
                guard let url = URL(string: model?.model?.imageUrl ?? "") else {return}
                
                self.imageBtn.sd_setImage(with: url, placeholderImage: UIImage(), context: nil)
                
                collectBtn.isSelected = model?.model?.isCollect ?? false
            }
            
            if model?.fireModel != nil {
                
                guard let url = URL(string: model?.fireModel?.iconArtSmallUri ?? "") else {return}
                
                self.imageBtn.sd_setImage(with: url, placeholderImage: UIImage(), context: nil)
                
                collectBtn.isSelected = model?.fireModel?.isCollect ?? false
            }
            
        }
    }
    
    @objc func imageBtnClick() {
        
        shock()
    }
    
    @objc func collectBtnClick(btn:UIButton) {
        
        if model?.model != nil {
            
            model?.model?.isCollect = !(model?.model?.isCollect ?? false)
        }
        
        if model?.fireModel != nil {
            
            model?.fireModel?.isCollect = !(model?.fireModel?.isCollect ?? false)
        }
        
        callBack("collect")
    }
    
    @objc func handleTapGesture(_ gesture: UITapGestureRecognizer) {
        
        shock()
        callBack("click")
    }
}



class ChannelCollectionSectionModel:BaseModel {
    
    var height:CGFloat = 0
    var topMar:CGFloat = 0
    var title:String = ""
    var isHidden:Bool = false
}

class ChannelCollectionSection: UICollectionReusableView {
    
    static let headerIdef = "ChannelCollectionSectionheaderIdef"
    static let footerIdef = "ChannelCollectionSectionfooterIdef"
    
    var callBack:callBack = {index in }
    
    lazy var titleLabel:UILabel = {
        
        let sview:UILabel = UILabel()
        sview.textColor = UIColor.colorWithHex(hexStr: whiteColor)
        sview.font = UIFont.systemFont(ofSize: 16.RW(), weight: .medium)
        sview.x = 0
        sview.y = 0
        
        return sview
    }()
    
    var model:ChannelCollectionSectionModel? {
        
        didSet {
            
            titleLabel.text = (model?.height ?? 0) == 0 ? "" : model?.title
            titleLabel.sizeToFit()
            
            titleLabel.y = height - titleLabel.height - 8.RW()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addViews()
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI() {
        
        backgroundColor = .clear
    }
    
    func addViews() {
        
        addSubview(titleLabel)
    }
 
}

