//
//  SearchCityViewController.swift
//  CityAirportSearch
//
//  Created by Valeriy Kovalevskiy on 2.04.21.
//

import UIKit
import RxSwift
import RxDataSources

final class SearchCityViewController: UIViewController, Storyboardable {

    // MARK: - Outlets
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var roundedView: UIView!
    @IBOutlet private weak var searchTextField: UITextField!
    
    private let disposeBag = DisposeBag()
    private static let reuseIdentifier = "CityCell"
    private lazy var dataSource = RxTableViewSectionedReloadDataSource<CityItemsSection>(configureCell: { _, tableView, indexPath, item in
        
        guard let cityCell = tableView.dequeueReusableCell(withIdentifier: SearchCityViewController.reuseIdentifier, for: indexPath) as? CityCell else {
            return UITableViewCell()
        }
        cityCell.configure(usingViewModel: item)
        return cityCell
    })
    
    // MARK: - Properties
    private var viewModel: SearchCityViewPresentable!
    var viewModelBuilder: SearchCityViewPresentable.ViewModelBuilder!
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // View Model will created after we pass some input 
        viewModel = viewModelBuilder((
            searchText: searchTextField.rx.text.orEmpty.asDriver(), ()
        ))
        
        setupUI()
        setupBinding()
    }


}

private extension SearchCityViewController {
    
    func setupUI() -> Void {
        let nib = UINib(nibName: "CityCell", bundle: nil)
        self.tableView.register(nib, forCellReuseIdentifier: SearchCityViewController.reuseIdentifier)
        
        self.title = "Airports"
    }
    
    func setupBinding() -> Void {
        
        self.viewModel.output.cities
            .drive(tableView.rx.items(dataSource: self.dataSource))
            .disposed(by: disposeBag)
    }
}
