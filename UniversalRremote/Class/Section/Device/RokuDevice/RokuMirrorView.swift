//
//  RokuMirror.swift
//  UniversalRremote
//
//  Created by Hao Liu on 2024/8/9.
//


import UIKit

class RokuMirrorView:UIView {
    
    lazy var scrollView:UIScrollView = {
        
        let cY:CGFloat = 0
        let sview:UIScrollView = UIScrollView(frame: CGRect(x: 0, y: cY, width: width, height: height - cY))
        sview.backgroundColor = .clear
        return sview
    }()
    
    lazy var number1TitleVLabel:UILabel = {
        
        let sview:UILabel = UILabel()
        sview.text = "1."
        sview.font = UIFont.systemFont(ofSize: 32.RW(), weight: .bold)
        sview.textColor = UIColor.colorWithHex(hexStr: whiteColor)
        sview.sizeToFit()
        sview.y = marginLR
        sview.x = marginLR
        return sview
    }()
    
    lazy var number1TipVLabel:UILabel = {
        let cX:CGFloat = number1TitleVLabel.x + number1TitleVLabel.width + 13.RW()
        let sview:UILabel = UILabel()
        sview.text = "Make sure your phone and TV are connected to the same wifi network."
        sview.font = UIFont.systemFont(ofSize: 14.RW(), weight: .regular)
        sview.textColor = UIColor.colorWithHex(hexStr: "#B3B3B3")
        sview.numberOfLines = 0
        sview.width = scrollView.width - cX - marginLR
        sview.sizeToFit()
        sview.y = number1TitleVLabel.y + 5.RW()
        sview.x = cX
        return sview
    }()
    
    lazy var number1ImageView:UIImageView = {
        let cX:CGFloat = marginLR
        let sview:UIImageView = UIImageView()
        
        let image:UIImage = UIImage(named: "roku_mirror_tip_1") ?? UIImage()
        sview.width = 295.RW()
        sview.height = image.size.height / image.size.width * sview.width
        sview.image = image
        sview.centerX = scrollView.width / 2
        sview.y = number1TipVLabel.y + number1TipVLabel.height + 8.RW()
        
        return sview
    }()
    
    lazy var number2TitleVLabel:UILabel = {
        
        let sview:UILabel = UILabel()
        sview.text = "2."
        sview.font = UIFont.systemFont(ofSize: 32.RW(), weight: .bold)
        sview.textColor = UIColor.colorWithHex(hexStr: whiteColor)
        sview.sizeToFit()
        sview.y = number1ImageView.y + number1ImageView.height + marginLR
        sview.x = marginLR
        return sview
    }()
    
    lazy var number2TipVLabel:UILabel = {
        let cX:CGFloat = number1TitleVLabel.x + number1TitleVLabel.width + 13.RW()
        let sview:UILabel = UILabel()
        sview.text = "Enable the \"AirPlay\" function on your TV. (You need to enable it manually on the devices system settings AirPlay and Homekit)"
        sview.font = UIFont.systemFont(ofSize: 14.RW(), weight: .regular)
        sview.textColor = UIColor.colorWithHex(hexStr: "#B3B3B3")
        sview.numberOfLines = 0
        sview.width = scrollView.width - cX - marginLR
        sview.sizeToFit()
        sview.y = number2TitleVLabel.y + 5.RW()
        sview.x = cX
        return sview
    }()
    
    lazy var number2ImageView:UIImageView = {
        let cX:CGFloat = marginLR
        let sview:UIImageView = UIImageView()
        
        let image:UIImage = UIImage(named: "roku_mirror_tip_2") ?? UIImage()
        sview.width = 295.RW()
        sview.height = image.size.height / image.size.width * sview.width
        sview.image = image
        sview.centerX = scrollView.width / 2
        sview.y = number2TipVLabel.y + number2TipVLabel.height + 8.RW()
        
        return sview
    }()
    
    
    lazy var number3TitleVLabel:UILabel = {
        
        let sview:UILabel = UILabel()
        sview.text = "3."
        sview.font = UIFont.systemFont(ofSize: 32.RW(), weight: .bold)
        sview.textColor = UIColor.colorWithHex(hexStr: whiteColor)
        sview.sizeToFit()
        sview.y = number2ImageView.y + number2ImageView.height + marginLR
        sview.x = marginLR
        return sview
    }()
    
    lazy var number3TipVLabel:UILabel = {
        let cX:CGFloat = number1TitleVLabel.x + number1TitleVLabel.width + 13.RW()
        let sview:UILabel = UILabel()
        sview.text = "Turn on screen mirroring on your phone, select a TV device, and enter mirroring mode."
        sview.font = UIFont.systemFont(ofSize: 14.RW(), weight: .regular)
        sview.textColor = UIColor.colorWithHex(hexStr: "#B3B3B3")
        sview.numberOfLines = 0
        sview.width = scrollView.width - cX - marginLR
        sview.sizeToFit()
        sview.y = number3TitleVLabel.y + 5.RW()
        sview.x = cX
        return sview
    }()
    
    lazy var number3ImageView:UIImageView = {
        let cX:CGFloat = marginLR
        let sview:UIImageView = UIImageView()
        
        let image:UIImage = UIImage(named: "roku_mirror_tip_3") ?? UIImage()
        sview.width = 178.RW()
        sview.height = image.size.height / image.size.width * sview.width
        sview.image = image
        sview.centerX = scrollView.width / 2
        sview.y = number3TipVLabel.y + number3TipVLabel.height + 8.RW()
        
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
        
        addSubview(scrollView)
        scrollView.addSubview(number1TitleVLabel)
        scrollView.addSubview(number1TipVLabel)
        scrollView.addSubview(number1ImageView)
        
        scrollView.addSubview(number2TitleVLabel)
        scrollView.addSubview(number2TipVLabel)
        scrollView.addSubview(number2ImageView)
        
        scrollView.addSubview(number3TitleVLabel)
        scrollView.addSubview(number3TipVLabel)
        scrollView.addSubview(number3ImageView)
        
        if number3ImageView.y + number3ImageView.height + 25.RW() > scrollView.height {
            
            scrollView.contentSize = CGSizeMake(scrollView.width, number3ImageView.y + number3ImageView.height + 25.RW())
        }
            
    }
}
