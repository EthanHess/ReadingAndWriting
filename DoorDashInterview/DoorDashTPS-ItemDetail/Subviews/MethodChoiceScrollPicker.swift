//
//  MethodChoiceScrollPicker.swift
//  DoorDashTPS-ItemDetail
//
//  Created by Ethan Hess on 1/31/22.
//  Copyright © 2022 Jeff Cosgriff. All rights reserved.
//

import UIKit

protocol DidChooseOption : AnyObject {
    func choseOption(index: Int)
}

class MethodChoiceScrollPicker: UITableViewCell {

    //MARK: TODO add scroll view for storage options, not just fetch
    
    var fetchOptionsScrollView : UIScrollView = {
        let sv = UIScrollView()
        sv.isPagingEnabled = true
        sv.backgroundColor = .darkGray
        return sv
    }()
    
    var viewArray : [UIView] = []
    
    //Can also do via sink, i.e. replacing delegates (Combine frameworks)
    weak var delegate : DidChooseOption?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func arrayOfOptions(_ fetch: Bool) -> [String] {
        let fetchArray = ["Standard", "Codable", "Combine", "Async Await"]
        let storageArray = ["File Manager", "Core Data", "SQL", "???"]
        return fetch == true ? fetchArray : storageArray
    }
    
    @objc func setUpStorageScroll() {
        
    }
    
    func setUpFetchWrapper() {
        self.perform(#selector(setUpFetchScroll), with: nil, afterDelay: 0.25)
        self.perform(#selector(setUpStorageScroll), with: nil, afterDelay: 0.25)
    }
    
    //MARK: Could have one scroll view setup function for cleaner code
//    @objc func setUpScroll(_scrollView: UIScrollView, storage: Bool) {
//
//    }
    
    @objc func setUpFetchScroll() {
        self.contentView.isUserInteractionEnabled = true
        self.isUserInteractionEnabled = true
        fetchOptionsScrollView.contentSize = CGSize(width: contentView.frame.size.width * 4, height: 0)
        fetchOptionsScrollView.frame = self.contentView.bounds
        fetchOptionsScrollView.delegate = self
        self.contentView.addSubview(fetchOptionsScrollView)
        
        for view in fetchOptionsScrollView.subviews {
            view.removeFromSuperview()
        }
        
        viewArray.removeAll()
        
        var x = 10
        let tWidth = Int(self.contentView.frame.size.width - 20)
        
        let arr = arrayOfOptions(true)
        
        for i in 0...arr.count - 1 {
            let label = UILabel(frame: CGRect(x: x, y: 5, width: tWidth, height: 40))
            label.text = arr[i]
            labelAttributes(label)
            
            let gesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
            label.isUserInteractionEnabled = true
            label.tag = i
            label.addGestureRecognizer(gesture)
            
            viewArray.append(label)
            fetchOptionsScrollView.addSubview(label)
            x = x + Int(self.contentView.frame.size.width)
        }
    }
    
    @objc fileprivate func handleTap(_ sender: UITapGestureRecognizer) {
        guard let theView = sender.view else {
            return
        }
        self.delegate?.choseOption(index: theView.tag)
    }
    
    func labelAttributes(_ label: UILabel) {
        label.textAlignment = .center
        label.textColor = .white
        label.layer.cornerRadius = 5
        label.layer.masksToBounds = true
        label.backgroundColor = .lightGray
        label.layer.borderColor = UIColor.gray.cgColor
    }
    
    fileprivate func commenceBounceAnimation(_ label: UILabel) {
        layerScaleAnimation(layer: label.layer, duration: 1.5, fromValue: 1, toValue: 1.5)
    }
    
    //MARK: https://stackoverflow.com/questions/16447236/cabasicanimation-transform-scale-keep-in-center
    
    func layerScaleAnimation(layer: CALayer, duration: CFTimeInterval, fromValue: CGFloat, toValue: CGFloat) {
        let timing = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeIn)
        let scaleAnimation: CABasicAnimation = CABasicAnimation(keyPath: "transform.scale")

        CATransaction.begin()
        CATransaction.setAnimationTimingFunction(timing)
        scaleAnimation.duration = duration
        scaleAnimation.fromValue = fromValue
        scaleAnimation.toValue = toValue
        layer.add(scaleAnimation, forKey: "scale")
        CATransaction.commit()
    }
}

extension MethodChoiceScrollPicker: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let svox = scrollView.contentOffset.x
        let cw = scrollView.contentSize.width
        print("SCROLL VIEW OFFSET X \(svox) CW \(cw)")
        
        //MARK: % for Ints, truncatingRemainder for Floats
        //MARK: TODO fix last index
        
        let remainderZero = svox < 1 ? true : cw.truncatingRemainder(dividingBy: svox) == 0
        print("REMAINDER ZERO \(remainderZero)")
        
        if svox == 0 || remainderZero == true { //Modulo
            let theIndex = svox / cw * CGFloat(viewArray.count)
            let labelIndex : Int = Int(svox == 0 ? 0 : theIndex)
            print("LABEL INDEX \(labelIndex)")
            if let theLabel = viewArray[labelIndex] as? UILabel {
                commenceBounceAnimation(theLabel)
            }
        }
    }
}
