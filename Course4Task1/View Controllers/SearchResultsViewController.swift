//
//  SearchResultsViewController.swift
//  Course4Task1
//

//

import UIKit

//Sets the table of search results
class SearchResultsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var repositoriesNumberLabel: UILabel! {
        didSet {
            repositoriesNumberLabel.text = "Repositories found: \(repsNumber)"
        }
    }
    
    @IBOutlet weak var repositoriesListTableView: UITableView! {
        didSet {
            repositoriesListTableView.register(UINib(nibName: String(describing: RepositoriesListTableViewCell.self), bundle: nil), forCellReuseIdentifier: String(describing: RepositoriesListTableViewCell.self))
            repositoriesListTableView.delegate = self
            repositoriesListTableView.dataSource = self
            repositoriesListTableView.allowsSelection = true
            repositoriesListTableView.estimatedRowHeight = 85.0
            repositoriesListTableView.rowHeight = UITableView.automaticDimension
            repositoriesListTableView.reloadData()
        }
    }
    
    var repsNumber: Int = 0
    var repositoriesList: [RepositoryShortInfo.Item] = []
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return repositoriesList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: RepositoriesListTableViewCell.self)) as! RepositoriesListTableViewCell
        let repository = repositoriesList[indexPath.row]
        
        cell.setRepositoryShortInfoItem(repository)
        
        return cell
    }
    
    // MARK: - UITableViewDelegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let destinationController = self.storyboard?.instantiateViewController(withIdentifier: "webViewVC") as? WebViewController else { return }
        destinationController.repositoryUrl = repositoriesList[indexPath.row].htmlUrl 
        self.navigationController!.pushViewController(destinationController, animated: true)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func searchResultsToWebViewSegue(_ cell: RepositoriesListTableViewCell) {
        guard let destinationController = self.storyboard?.instantiateViewController(withIdentifier: "webViewVC") as? WebViewController else { return }
        destinationController.repositoryUrl = cell.repUrl
        self.navigationController!.pushViewController(destinationController, animated: true)
    }
    
}
