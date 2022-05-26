//
//  ImagePresenter.swift
//  DoorDashTPS-ItemDetail
//
//  Created by Ethan Hess on 4/4/22.
//  Copyright © 2022 Jeff Cosgriff. All rights reserved.
//

import UIKit

protocol DidCloseImagePresenter : AnyObject {
    func didClickClose()
}

class ImagePresenter: UIView {
    
    weak var delegate : DidCloseImagePresenter?
    
    var mainImageView : UIImageView = {
        let miv = UIImageView()
        miv.contentMode = .scaleAspectFit
        return miv
    }()
    
    var closeButton : UIButton = {
        let cb = UIButton()
        cb.setTitle("X", for: .normal)
        cb.backgroundColor = .white
        cb.setTitleColor(.black, for: .normal)
        return cb
    }()
    
    var mainImageString : String? {
        didSet {
            guard let setImageString = mainImageString else {
                return
            }
            imageOnMain(setImageString)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureViews()
    }
    
    fileprivate func imageOnMain(_ imageString: String) {
        guard let theURL = URL(string: imageString) else {
            return
        }
        DispatchQueue.main.async {
            self.mainImageView.downloadImageFromURL(theURL) { response in
                DispatchQueue.main.async {
                    guard let theImage = response.image else {
                        if #available(iOS 13.0, *) {
                            self.downloadedFinished(UIImage(systemName: "face.smiling")!)
                        } else {
                            // Fallback on earlier versions
                        }
                        return
                    }
                    self.downloadedFinished(theImage)
                }
            }
        }
    }
    
    fileprivate func downloadedFinished(_ theImage: UIImage) {
        //self.activityIndicator.stopAnimating()
        self.mainImageView.image = theImage
    }
    
    fileprivate func configureViews() {
        addSubview(mainImageView)
        mainImageView.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 200, paddingLeft: 100, paddingBottom: 200, paddingRight: 100, width: 0, height: 0)
        
        let buttonFrame = CGRect(x: 50, y: 50, width: 50, height: 50)
        closeButton.frame = buttonFrame
        closeButton.layer.cornerRadius = 25
        closeButton.addTarget(self, action: #selector(closeSelf), for: .touchUpInside)
        addSubview(closeButton)
    }
    
    @objc fileprivate func closeSelf() {
        delegate?.didClickClose()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
