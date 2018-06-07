//
//  CurrencyMainCell.swift
//  Currency
//
//  Created by Bogdan Koshyrets on 2/24/18.
//  Copyright © 2018 Bohdan Koshyrets. All rights reserved.
//

import UIKit

class CurrencyMainCell: UITableViewCell {

    @IBOutlet weak var currencyCodeLabel: UILabel!
    @IBOutlet weak var currencyNameLabel: UILabel!
    @IBOutlet weak var valueLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
