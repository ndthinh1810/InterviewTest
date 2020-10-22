//
//  DiaryTableViewCell.swift
//  InterviewTest
//
//  Created by Nguyễn Đức Thịnh on 10/7/20.
//  Copyright © 2020 Duc Thinh. All rights reserved.
//

import UIKit
protocol DiaryTableViewCellDelegate: class {
    func didTapDeleteButtonInCell(_ cell: DiaryTableViewCell)
    func didTapEditButtonInCell(_ cell: DiaryTableViewCell)
}
class DiaryTableViewCell: UITableViewCell {
    weak var delegate: DiaryTableViewCellDelegate?
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var DateLabel: UILabel!
    @IBOutlet weak var DiaryLabel: UILabel!
    @IBOutlet weak var text1: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    @IBAction func didTapDeleteButton(sender: UIButton) {
        delegate?.didTapDeleteButtonInCell(self)
        
    }
    
    @IBAction func didTapEditButton(sender: UIButton) {
        delegate?.didTapEditButtonInCell(self)
        
    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
