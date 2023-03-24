//
//  Extensions.swift
//  DoorDashTPS-ItemDetail
//
//  Created by Ethan Hess on 2/25/22.
//  Copyright © 2022 Jeff Cosgriff. All rights reserved.
//

import Foundation
import UIKit

//MARK: Extensions
extension UIView {
    func anchor(top: NSLayoutYAxisAnchor?, left: NSLayoutXAxisAnchor?, bottom: NSLayoutYAxisAnchor?, right: NSLayoutXAxisAnchor?, paddingTop: CGFloat, paddingLeft: CGFloat, paddingBottom: CGFloat, paddingRight: CGFloat, width: CGFloat, height: CGFloat) {
        
        //Autoresizing mask controls how view resizes itself when (superview) bounds change
        //We don't want system to automatically create contraints so we'll set to false
        translatesAutoresizingMaskIntoConstraints = false
        
        if let top = top {
            self.topAnchor.constraint(equalTo: top, constant: paddingTop).isActive = true
        }
        if let left = left {
            self.leftAnchor.constraint(equalTo: left, constant: paddingLeft).isActive = true
        }
        if let bottom = bottom {
            bottomAnchor.constraint(equalTo: bottom, constant: -paddingBottom).isActive = true
        }
        if let right = right {
            rightAnchor.constraint(equalTo: right, constant: -paddingRight).isActive = true
        }
        if width != 0 {
            widthAnchor.constraint(equalToConstant: width).isActive = true
        }
        if height != 0 {
            heightAnchor.constraint(equalToConstant: height).isActive = true
        }
    }
}

var imageCache : [String: UIImage?] = ["": nil]

extension UIImageView {
    func downloadImageFromURL(_ url: URL, andCompletion: @escaping (_ response: (success: Bool, image: UIImage?)) -> Void) {
        let urlString = url.absoluteString
        if imageCache[urlString] != nil {
            andCompletion((success: true, image: imageCache[urlString] as? UIImage))
        } else {
        URLSession.shared.dataTask(with: url) { data, response, error in
            if error != nil {
                andCompletion((success: false, image: nil))
            } else {
                if let httpUrlResponse = response as? HTTPURLResponse {
                    if httpUrlResponse.statusCode != 200 {
                        andCompletion((success: false, image: nil))
                    } else {
                        guard let theData = data else {
                            andCompletion((success: false, image: nil))
                            return
                        }
                        let image = UIImage(data: theData)
                        imageCache[urlString] = image
                        andCompletion((success: true, image: image))
                    }
                } else {
                    print("No response")
                    andCompletion((success: false, image: nil))
                }
            }
        }.resume() //Newly-initialized tasks begin in a suspended state, so you need to call this method to start the task.
    }
    }
}


//MARK: Weakifiable tutorial credit (I changed / added a few things) https://www.youtube.com/watch?v=BGzPK7f13RM

//Replaces weak self syntax with something cleaner
//TODO incorporate into current code
protocol Weakifiable: AnyObject { }

extension NSObject: Weakifiable { }

//Self with capital S refers to type that conforms to the protocol (or in some cases as a return type of a static method), T is generic (whatever type)
extension Weakifiable {
    func weakify<T>(code: @escaping (Self, T, Error?) -> Void) -> (T, Error?) -> Void {
        return {
            //Boilerplate (code that's repeated multiple places with little to no variation)
            [weak self] data, err in
            guard let self = self else { return }
            
            code(self, data, err)
        }
    }
}
