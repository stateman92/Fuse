//
//  ViewController.swift
//  Example
//
//  Created by Kirollos Risk on 05/02/2017.
//  Copyright (c) 2017 Kirollos Risk. All rights reserved.
//

import UIKit
import Fuse

final class ViewController: UITableViewController {
    private let books = {
        [
            "Angels & Demons",
            "Old Man's War",
            "The Lock Artist",
            "HTML5",
            "Right Ho Jeeves",
            "The Code of the Wooster",
            "Thank You Jeeves",
            "The DaVinci Code",
            "The Silmarillion",
            "Syrup",
            "The Lost Symbol",
            "The Book of Lies",
            "Lamb",
            "Fool",
            "Incompetence",
            "Fat",
            "Colony",
            "Backwards, Red Dwarf",
            "The Grand Design",
            "The Book of Samson",
            "The Preservationist",
            "Fallen",
            "Monster 1959"
        ]
    }()
    private let fuse = Fuse()
    private let searchController = UISearchController(searchResultsController: nil)

    private var filteredBooks = [NSAttributedString]()
}

extension ViewController {
    override func viewDidLoad() {
        super.viewDidLoad()

        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        tableView.tableHeaderView = searchController.searchBar
    }
}

extension ViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchController.isActive, searchController.searchBar.text != "" {
            filteredBooks.count
        } else {
            books.count
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)

        let item = if searchController.isActive, searchController.searchBar.text?.isEmpty == false {
            filteredBooks[indexPath.row]
        } else {
            NSAttributedString(string: books[indexPath.row])
        }

        cell.textLabel?.attributedText = item

        return cell
    }
}

extension ViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        searchBar.text.map { filterContentForSearchText($0) }
    }
}

extension ViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        searchController.searchBar.text.map { filterContentForSearchText($0) }
    }
}

extension ViewController {
    private func filterContentForSearchText(_ searchText: String) {
        let boldAttributes = [
            NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 17),
            .foregroundColor: UIColor.blue
        ]

        let results = fuse.search(searchText, in: books)

        filteredBooks = results.map { index, _, matchedRanges in
            let book = books[index]

            let attributedString = NSMutableAttributedString(string: book)
            matchedRanges
                .map(NSRange.init)
                .forEach { attributedString.addAttributes(boldAttributes, range: $0) }
            return attributedString
        }

        tableView.reloadData()
    }
}
