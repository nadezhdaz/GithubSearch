//
//  SearchViewController.swift
//  Course4Task1
//

//

import UIKit
import Kingfisher


//Sets view with search for repositories
class SearchViewController: UIViewController {
    
    @IBOutlet weak var usernameLabel: UILabel! {
        didSet {
            usernameLabel.text = username
        }
    }
    @IBOutlet weak var repositoryNameTextField: UITextField! {
        didSet {
            repositoryNameTextField.autocorrectionType = .no
        }
    }
    @IBOutlet weak var languageTextField: UITextField! {
        didSet {
            languageTextField.autocorrectionType = .no
        }
    }
    
    @IBOutlet weak var sortSegmentedControl: UISegmentedControl!
    var order = ""
    var searchString = ""
    let queryService = QueryService()
    var searchResults: RepositoryShortInfo?
    var avatarURL: String?
    var username: String?
    
    @IBOutlet weak var avatarImageView: UIImageView! {
        didSet {
            guard let url = URL(string: avatarURL!) else { return }
            avatarImageView.kf.setImage(with: url)
            avatarImageView.setRounded()
            avatarImageView.clipsToBounds = true
        }
    }
    
    @IBAction func sortIndexChanged(_ sender: Any) {
        switch sortSegmentedControl.selectedSegmentIndex {
        case 0:
            order = "asc"
        case 1:
            order = "desc"
        default:
            break
        }
    }
    
    @IBAction func startSearchButtonPressed(_ sender: Any) {
        guard let repositoryName = repositoryNameTextField.text, let language = languageTextField.text else {
            print("No item to search")
            return
        }
        
        guard repositoryName.count > 0 else {
            print("No item to search")
            return
        }
        
        let isLanguageSpecified = languageTextField.hasText
        
        searchForRepositories(repository: repositoryName, language: language, isLanguageSpecified: isLanguageSpecified)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        repositoryNameTextField.becomeFirstResponder()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard (_:)))
        self.view.addGestureRecognizer(tapGesture)
        tapGesture.cancelsTouchesInView = false
    }
    
    @objc func dismissKeyboard (_ sender: UITapGestureRecognizer) {
        repositoryNameTextField.resignFirstResponder()
    }
    
    private func searchForRepositories(repository: String, language: String, isLanguageSpecified: Bool) {
        searchString = isLanguageSpecified ? "\((repository))+language:\(language)" : "\((repository))"
        queryService.getSearchResults(searchTerm: searchString, order: order) { [weak self] results, errorMessage in
            
            if let results = results {
                self?.searchResults = results
                self?.searchToSearchResultsSegue()
            }
            
            if !errorMessage.isEmpty {
                print("Search error: " + errorMessage)
            }
        }
    }
    
    private func searchToSearchResultsSegue() {
        guard let destinationController = self.storyboard?.instantiateViewController(withIdentifier: "searchResultsVC") as? SearchResultsViewController else { return }
        guard let searchResults = searchResults else { return }
        destinationController.repsNumber = searchResults.totalCount
        destinationController.repositoriesList = searchResults.items
        self.navigationController!.pushViewController(destinationController, animated: true)
    }
    
}

extension UIImageView {
    
    func setRounded() {
        self.layer.cornerRadius = self.frame.width / 2
    }
    
}
