//
//  AirportsViewController.swift
//  
//
//  Created by Valeriy Kovalevskiy on 5.04.21.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources

// TODO: - Create protocol like storyboardable but without connection with only main storyboard
final class AirportsViewController: UIViewController, Storyboardable {
    
    // MARK: - Outlets
    @IBOutlet private weak var tableView: UITableView!
    
    // MARK: - Properties
    private let disposeBag = DisposeBag()
    private static let reuseIdentifier = "AirportCell"
    private lazy var dataSource = RxTableViewSectionedReloadDataSource<AirportItemsSection>(configureCell: { _, tableView, indexPath, item in
        
        guard let airportCell = tableView.dequeueReusableCell(withIdentifier: AirportsViewController.reuseIdentifier, for: indexPath) as? AirportCell else {
            return UITableViewCell()
        }
        airportCell.configure(usingViewModel: item)
        return airportCell
    })
    
    private var viewModel: AirportsViewPresentable!
    var viewModelBuilder: AirportsViewPresentable.ViewModelBuilder!
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        viewModel = viewModelBuilder(())
        
        setupUI()
        setupBinding()
    }
}

private extension AirportsViewController {
    func setupUI() {
        let nib = UINib(nibName: "AirportCell", bundle: nil)
        self.tableView.register(nib, forCellReuseIdentifier: AirportsViewController.reuseIdentifier)
        
        self.viewModel.output.title
            .drive(self.rx.title)
            .disposed(by: disposeBag)
    }
    
    func setupBinding() {
        self.viewModel.output.airports
            .drive(self.tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
    }
}
