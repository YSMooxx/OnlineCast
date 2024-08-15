//
//  WebOSHDMIView.swift
//  UniversalRremote
//
//  Created by Hao Liu on 2024/8/15.
//

import UIKit

class WebOSHDMIViewController:LDBaseViewController {
    
    var idCallBack:callBack = {id in}
    
    lazy var model:WebOSHDMIViewModel = {
        
        let model:WebOSHDMIViewModel = WebOSHDMIViewModel()
        
        model.callBack = {[weak self] text in
            
            guard let self else {return}
            if text == WebOSHDMIViewModel.channgeModelArrayKey {
                
                self.channgeModelArray()
            }
        }
        
        return model
    }()
    
    lazy var backView:UIView = {
        
        let cH:CGFloat = 240.RW() + (safeHeight > 0 ? safeHeight:25.RW())
        
        let sview:UIView = UIView(frame: CGRect(x: 0, y: view.height - cH, width: view.width, height: cH))
        
        sview.backgroundColor = UIColor.colorWithHex(hexStr: "#292929")
        
        sview.cornerCut(radius: 12.RW(), corner: [.topLeft,.topRight])
        
        return sview
    }()
    
    lazy var collectionView:UICollectionView = {
        
        let cY:CGFloat = 16.RW()
        
        let layout = WaterfallMutiSectionFlowLayout()
        layout.delegate = self
        let sview:UICollectionView = UICollectionView.init(frame: CGRect(x: marginLR, y: cY, width: backView.width - 2 * marginLR, height: backView.height - cY),  collectionViewLayout: layout)
        
        sview.dataSource = self
        sview.delegate = self
        sview.showsVerticalScrollIndicator = false
        sview.register(WebOSHDMICollectionCell.self, forCellWithReuseIdentifier: WebOSHDMICollectionCell.Identifier)
        sview.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: model.lineSpacing, right: 0)
        sview.backgroundColor = .clear
        return sview
        
    }()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        view.backgroundColor = UIColor.colorWithHex(hexStr: blackColor, alpha: 0.6)
    }
    
    override func addViews() {
        
        view.addSubview(backView)
        backView.addSubview(collectionView)
    }
    
    func channgeModelArray() {
        
        DispatchQueue.main.async {[weak self] in
            guard let self else {return}
            self.collectionView.reloadData()
        }
    }
    
    func getCell(indexPath:IndexPath) -> UICollectionViewCell {
        
        let cell:WebOSHDMICollectionCell = collectionView.dequeueReusableCell(withReuseIdentifier: WebOSHDMICollectionCell.Identifier, for: indexPath) as! WebOSHDMICollectionCell
        
        if indexPath.row < model.modelArray.count {
            
            cell.model =  model.modelArray[indexPath.row]
        }
        
        return cell
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        var result:Bool? = true
        
        for touch:AnyObject in touches{
            
            let touch:UITouch = touch as! UITouch
            let result1:Bool = touch.view?.isDescendant(of:self.backView) ?? true
            result = result1
        }
        
        if result != true {

            self.navigationController?.dismiss(animated: true)
        }
    }
}

extension WebOSHDMIViewController:WaterfallMutiSectionDelegate,UICollectionViewDataSource,UICollectionViewDelegate {
    
    func heightForRowAtIndexPath(collectionView collection: UICollectionView, layout: WaterfallMutiSectionFlowLayout, indexPath: IndexPath, itemWidth: CGFloat) -> CGFloat {
        
        return 92.RW()
    }
    
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        
        return 1
    }
    
    func columnNumber(collectionView collection: UICollectionView, layout: WaterfallMutiSectionFlowLayout, section: Int) -> Int {
        
        return 2
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return model.modelArray.count
    }
    
    func lineSpacing(collectionView collection: UICollectionView, layout: WaterfallMutiSectionFlowLayout, section: Int) -> CGFloat {
        
        return model.lineSpacing
    }
    
    func interitemSpacing(collectionView collection: UICollectionView, layout: WaterfallMutiSectionFlowLayout, section: Int) -> CGFloat {
        
        return model.interitemSpacing
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        return getCell(indexPath: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if indexPath.row < model.modelArray.count {
            
            idCallBack(model.modelArray[indexPath.row].id ?? "")
            
            UIView.animate(withDuration: 0.3) {[weak self] in
                
                self?.view.backgroundColor = .clear
            }completion: {[weak self]  bool in
                self?.navigationController?.dismiss(animated: true)
            }
        }
    }
}

class WebOSHDMICollectionCell:UICollectionViewCell {
    
    static let Identifier:String = "WebOSHDMICollectionCellID"
    
    var callBack:callBack = {text in}
    
    lazy var backImageView:UIView = {
        
        let sview:UIView = UIView(frame: bounds)
        sview.backgroundColor = UIColor.colorWithHex(hexStr: "#292929", alpha: 1)
        
        // 设置圆角
        sview.layer.cornerRadius = 12.RW()
        
        // 添加边框
        sview.layer.borderWidth = 1
        sview.layer.borderColor = UIColor.colorWithHex(hexStr: "#4B4B4B").cgColor
        
        // 确保边框也是圆角
        sview.layer.masksToBounds = true
                
        
        return sview
    }()
    
    lazy var iconImage:UIImageView = {
        
        let sview:UIImageView = UIImageView(image: UIImage(named: "webos_hdmi_icon"))
        sview.width = 56.RW()
        sview.height = 26.RW()
        
        sview.y = 19.RW()
        sview.centerX = backImageView.width / 2
        
        return sview
    }()
    
    lazy var titleLabel:UILabel = {
        
        let sview:UILabel = UILabel()
        sview.font = UIFont.systemFont(ofSize: 16.RW(), weight: .regular)
        sview.textColor = UIColor.colorWithHex(hexStr: whiteColor)
        sview.y = iconImage.y + iconImage.height + 8.RW()
        sview.textAlignment = .center
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
        
        contentView.addSubview(backImageView)
        backImageView.addSubview(iconImage)
        backImageView.addSubview(titleLabel)
//        contentView.addSubview(collectBtn)
    }
    
    var model:WebOSHDMIListModel? {
        
        didSet {
            
            titleLabel.text = model?.name
            titleLabel.sizeToFit()
            titleLabel.width = backImageView.width - 2 * marginLR
            titleLabel.centerX = backImageView.width / 2
        }
    }

}



class WebOSHDMIViewModel {
    
    static let channgeModelArrayKey:String = "channgeModelArray"
    
    var callBack:callBack = {text in}
    var modelArray:[WebOSHDMIListModel] = [] {
        
        didSet {
            
            callBack(WebOSHDMIViewModel.channgeModelArrayKey)
        }
    }
    let lineSpacing:CGFloat = 8.RW()
    let interitemSpacing:CGFloat = 8.RW()
}

class WebOSHDMIListModel:BaseModel {
    
    var name:String?
    var id:String?
}
