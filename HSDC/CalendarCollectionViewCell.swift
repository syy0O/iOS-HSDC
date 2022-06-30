//
//  CalendarCollectionViewCell.swift
//  HSDC
//
//  Created by hsudev on 2022/06/17.
//

import UIKit

class CalendarCollectionViewCell: UICollectionViewCell {
    static let identifier = "CalendarCollectionViewCell"
    private lazy var dayLabel = UILabel()
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.configure()
    }
    
    override init(frame:CGRect){
        super.init(frame: frame)
        self.configure()
    }
    
    private func configure(){
        self.addSubview(self.dayLabel)
        self.dayLabel.font = .boldSystemFont(ofSize: 12)
        self.dayLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.dayLabel.topAnchor.constraint(equalTo: self.topAnchor, constant:5),
            //self.dayLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant:10)
            self.dayLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor)
        ])
    }
    
    func update(day: String){ //day로 들어오는 문자열로 dayLabel 설정
        self.dayLabel.text = day
    }
}
