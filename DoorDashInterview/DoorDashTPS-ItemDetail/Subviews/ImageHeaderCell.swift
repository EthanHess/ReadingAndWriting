//
//  ImageHeaderCell.swift
//  DoorDashTPS-ItemDetail
//
//  Created by Ethan Hess on 3/21/22.
//  Copyright © 2022 Jeff Cosgriff. All rights reserved.
//

import UIKit

var memoryIDCache : [String: String] = [:]

@available(iOS 13.0, *)
class ImageHeaderCell: UITableViewCell {
    
    //MARK: Properties (constants, closure based initialized properties generally don't need to be var)
    let mainImageView : UIImageView = {
        let mIv = UIImageView()
        mIv.contentMode = .scaleAspectFit
        mIv.layer.cornerRadius = 5
        mIv.layer.masksToBounds = true
        return mIv
    }()
    
    let activityIndicator : UIActivityIndicatorView = {
        let ai = UIActivityIndicatorView()
        ai.hidesWhenStopped = true
        return ai
    }()

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setUpViews() {
        
        //MARK: will blur whatever is behind it, can add glassy backround image or something
  //      mainImageView.addBlur()
//        contentView.addBlur()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
            //MARK: Ideally should probably not do this (kind of hacky) but just testing / playing with something :)
            //Gets memory address like 0x00007fa8977103a0
            let opaque : UnsafeMutableRawPointer = Unmanaged.passUnretained(self).toOpaque()
            let idString = String(describing: opaque)
            print("id string \(idString)")
            if (memoryIDCache[idString] == nil) { //Only add gradient to object if hasn't been added yet, otherwise many layers are created. Can also remove sublayers in "prepareForReuse"
                self.contentView.addBackgroundGradient(true)
                memoryIDCache[idString] = ""
                self.contentView.layer.cornerRadius = 5
                self.contentView.layer.masksToBounds = true
            }
            self.contentView.addSubview(self.mainImageView)
            self.mainImageView.anchor(top: self.topAnchor, left: self.leftAnchor, bottom: self.bottomAnchor, right: self.rightAnchor, paddingTop: 20, paddingLeft: 20, paddingBottom: 20, paddingRight: 20, width: 0, height: 0)
        }
    }
    
    func populate(withURL: URL) {
        addActivityIndicatorViewToSmallImageAndStartAnimating()
        mainImageView.downloadImageFromURL(withURL) { response in
            DispatchQueue.main.async {
                guard let theImage = response.image else {
                    self.downloadedFinished(UIImage(systemName: "face.smiling")!)
                    return
                }
                self.downloadedFinished(theImage)
            }
        }
    }
    
    fileprivate func addActivityIndicatorViewToSmallImageAndStartAnimating() {
        let aiX = self.mainImageView.frame.size.width / 2
        let aiY = self.mainImageView.frame.size.height / 2
        
        self.activityIndicator.frame = CGRect(x: aiX - 20, y: aiY - 20, width: 40, height: 40)
        self.mainImageView.addSubview(self.activityIndicator)
        self.activityIndicator.startAnimating()
    }
    
    fileprivate func downloadedFinished(_ theImage: UIImage) {
        self.activityIndicator.stopAnimating()
        self.mainImageView.image = theImage
    }

    @available(iOS 14.0, *)
    func configure(configuration: UIContentConfiguration) {
        print("Configuration \(configuration)")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        //MARK: Remove sublayers
    }
}


extension UIView {
    //MARK: For blur effect
    func addBlur() {
        let be = UIBlurEffect(style: .light)
        let beView = UIVisualEffectView(effect: be)
        beView.frame = self.frame
        beView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.addSubview(beView)
        self.sendSubviewToBack(beView)
    }
    
    //MARK:
    func addBackgroundGradient(_ add: Bool) {
        if add == true {
            let gradient = CAGradientLayer()
            gradient.frame = self.frame
            gradient.colors = [UIColor.white.cgColor, UIColor.gray.cgColor, UIColor.white.cgColor]
            gradient.startPoint = CGPoint(x: 0.0, y: 0.5)
            gradient.endPoint = CGPoint(x: 1.0, y: 0.5)
            gradient.locations = [0.0, 0.5, 1.0]
            self.layer.addSublayer(gradient)
            
            let animation = CABasicAnimation(keyPath: "transform.translation.x")
            animation.fromValue = -self.frame.width
            animation.toValue = self.frame.width
            animation.duration = 1.5
            animation.repeatCount = .infinity
            
            gradient.add(animation, forKey: "loadingAnimation")
        } else { //Remove when loading is done
            
        }
    }
}
