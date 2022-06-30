//
//  declare.swift
//  HSDC
//
//  Created by hsudev on 2022/06/20.
//

import UIKit

extension CALayer {
    func addBorder(_ arr_edge: [UIRectEdge], color:UIColor, width:CGFloat){
        for edge in arr_edge {
            let border = CALayer()
            switch edge {
            case UIRectEdge.top:
                border.frame = CGRect.init(x:0,y:0,width:frame.width, height:width)
                break
            default:
                break
            }
            border.backgroundColor = color.cgColor
            self.addSublayer(border)
        }
    }
}
