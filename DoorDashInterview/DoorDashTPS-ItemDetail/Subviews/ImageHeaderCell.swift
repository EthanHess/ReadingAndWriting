//
//  ImageHeaderCell.swift
//  DoorDashTPS-ItemDetail
//
//  Created by Ethan Hess on 3/21/22.
//  Copyright © 2022 Jeff Cosgriff. All rights reserved.
//

import UIKit

@available(iOS 13.0, *)
class ImageHeaderCell: UITableViewCell {
    
    //MARK: Properties
    var mainImageView : UIImageView = {
        let mIv = UIImageView()
        mIv.contentMode = .scaleAspectFit
        mIv.backgroundColor = .lightGray
        mIv.layer.cornerRadius = 5
        mIv.layer.masksToBounds = true
        return mIv
    }()
    
    var activityIndicator : UIActivityIndicatorView = {
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
        contentView.addSubview(mainImageView)
        mainImageView.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 20, paddingLeft: 20, paddingBottom: 20, paddingRight: 20, width: 0, height: 0)
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
        
    }
}
