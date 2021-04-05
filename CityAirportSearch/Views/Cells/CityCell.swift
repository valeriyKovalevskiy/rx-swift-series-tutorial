//
//  CityCell.swift
//  CityAirportSearch
//
//  Created by Valeriy Kovalevskiy on 2.04.21.
//

import UIKit

final class CityCell: UITableViewCell {
    // MARK: - Outlets
    @IBOutlet private weak var cityLabel: UILabel!
    @IBOutlet private weak var locationLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func configure(usingViewModel viewModel: CityViewPresentable) {
        
        self.cityLabel.text = viewModel.city
        self.locationLabel.text = viewModel.location
        
        self.selectionStyle = .none
    }
}
