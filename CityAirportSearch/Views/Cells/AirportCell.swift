//
//  AirportCell.swift
//  CityAirportSearch
//
//  Created by Valeriy Kovalevskiy on 5.04.21.
//

import UIKit

final class AirportCell: UITableViewCell {
    @IBOutlet private weak var airportNameLabel: UILabel!
    @IBOutlet private weak var distanceLabel: UILabel!
    @IBOutlet private weak var countryLabel: UILabel!
    @IBOutlet private weak var runwayLengthLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configure(usingViewModel viewModel: AirportViewPresentable) -> Void {
        airportNameLabel.text = viewModel.name
        distanceLabel.text = viewModel.formattedDistance
        countryLabel.text = viewModel.address
        runwayLengthLabel.text = viewModel.runwayLength
        
        self.selectionStyle = .none
    }
}
