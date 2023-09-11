//
//  FeedCell.swift
//  DoorDashTPS-ItemDetail
//
//  Created by Ethan Hess on 11/23/21.
//  Copyright © 2021 Jeff Cosgriff. All rights reserved.
//

import UIKit
import Combine

@available(iOS 13.0, *)
class FeedCell: UITableViewCell {
    
    //MARK: A subject that broadcasts elements to downstream subscribers.
    
    //Appropriate for something like a button press (takes place of a delegate in this case, passing data to subscribers)
    var actionPublisher = PassthroughSubject<Action, Never>()
    
    //Appropriate for sharing state, not just a single action
    var someState = CurrentValueSubject<SomeState, Never>(.on)
    
    
    private var currentItem: ContentItem?
    private var currentItemDict: [String : Any]!

    let theTitleLabel : UILabel = {
        let tl = UILabel()
        return tl
    }()
    
    //For "content", long paragraph text
    let contentLabel : UILabel = {
        let cl = UILabel()
        return cl
    }()
    
    let smallImageView : UIImageView = {
        let sIv = UIImageView()
        sIv.contentMode = .scaleAspectFit
        sIv.backgroundColor = .lightGray
        sIv.layer.cornerRadius = 5
        sIv.layer.masksToBounds = true
        return sIv
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
    
    private func publishAction() {
        guard let theItem = currentItem else {
            print("No item")
            return
        }
        actionPublisher.send(.showContent(theItem))
        
        //Test
        perform(#selector(stateSend), with: nil, afterDelay: 0.05)
    }
    
    @objc private func stateSend() {
        someState.send(.on)
    }

    func populate(with item: ContentItem) {
        self.currentItem = item
        
        theTitleLabel.text = item.title
        contentLabel.text = item.content
        
        if item.image_url == "" {
            self.downloadedFinished(UIImage(systemName: "face.smiling")!)
        } else {
            addActivityIndicatorViewToSmallImageAndStartAnimating()
            imageDownloadWrapper(item.image_url)
        }
    }
    
    //MARK: Can add in extension for cleaner code
    fileprivate func addActivityIndicatorViewToSmallImageAndStartAnimating() {
        let aiX = self.smallImageView.frame.size.width / 2
        let aiY = self.smallImageView.frame.size.height / 2
        
        self.activityIndicator.frame = CGRect(x: aiX - 20, y: aiY - 20, width: 40, height: 40)
        self.smallImageView.addSubview(self.activityIndicator)
        self.activityIndicator.startAnimating()
    }
    
    func populate(with dict: [String: Any]) {
        self.currentItemDict = dict
        
        theTitleLabel.text = dict["title"] as? String ?? ""
        contentLabel.text = dict["content"] as? String ?? ""
        
        guard let urlString = dict["image_url"] as? String else {
            print("No URL str")
            return
        }
        
        addActivityIndicatorViewToSmallImageAndStartAnimating()
        imageDownloadWrapper(urlString)
    }
    
    fileprivate func imageDownloadWrapper(_ urlString: String) {
        guard let url = URL(string: urlString) else {
            print("No URL")
            return
        }
        
        //MARK: TODO subclass image
        self.smallImageView.downloadImageFromURL(url, andCompletion: { response in
            DispatchQueue.main.async {
                guard let theImage = response.image else {
                    self.downloadedFinished(UIImage(systemName: "face.smiling")!)
                    return
                }
                self.downloadedFinished(theImage)
            }
        })
    }
    
    fileprivate func downloadedFinished(_ theImage: UIImage) {
        self.activityIndicator.stopAnimating()
        self.smallImageView.image = theImage
        
        //Should check before adding, may exist
        print("Small IV GR \(String(describing: smallImageView.gestureRecognizers))")
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(imageTapped))
        smallImageView.isUserInteractionEnabled = true
        smallImageView.addGestureRecognizer(tapGesture)
    }
    
    @objc fileprivate func imageTapped() {
        publishAction()
    }
    
    func setUpViews() {
        let stackViewLabelsLeft = UIStackView(arrangedSubviews: [theTitleLabel, contentLabel])
        let stackViewMain = UIStackView(arrangedSubviews: [stackViewLabelsLeft, self.smallImageView])
        
        stackViewMain.axis = .horizontal
        stackViewLabelsLeft.axis = .vertical
        stackViewMain.distribution = .fillEqually
        stackViewLabelsLeft.distribution = .fillEqually
        
        addSubview(stackViewMain)
        stackViewMain.anchor(top: self.topAnchor, left: self.leftAnchor, bottom: self.bottomAnchor, right: self.rightAnchor, paddingTop: 20, paddingLeft: 20, paddingBottom: 20, paddingRight: 20, width: 0, height: 0)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        theTitleLabel.text = ""
        contentLabel.text = ""
        smallImageView.image = nil
    }
    
    //MARK: iOS 14+, can pass configuration object to configure a cell, look into image resizing issue though
    @available(iOS 14.0, *)
    func configure(configuration: UIContentConfiguration) {
        
    //Use this for reference
    // https://www.biteinteractive.com/cell-content-configuration-in-ios-14/
        
//        guard let configuration = configuration as? MyContentConfiguration else { return }
//        self.label.text = configuration.text
    }
}

@available(iOS 13.0, *)
extension FeedCell {
    //MARK: For publisher
    enum Action { //TODO add others
        case showContent(ContentItem)
    }
    
    enum SomeState {
        case on
        case off
    }
}

