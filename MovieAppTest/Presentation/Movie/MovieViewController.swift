//
//  ViewController.swift
//  MovieAppTest
//
//  Created by Chrismanto Natanail Manik on 01/06/24.
//

import UIKit

class MovieViewController: UIViewController {
    private var viewModel = MovieViewModel()
    private lazy var tableView = UITableView()
    private var loadingIndicator = UIActivityIndicatorView(style: .large)
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        observerData()
        fetchData()
    }

    private func setupView(){
        title = "Genre Movie"
        navigationItem.backButtonTitle = " "
        view.backgroundColor = .white
        prepareTableView()
        setupConstraint()
        prepareLoadingIndicator()
    }
    private func prepareTableView() {
        tableView.delegate = self
        tableView.dataSource = self
    }
    private func setupConstraint(){
        [tableView].forEach{view.addSubview($0)}
        tableView.anchor(top: view.topAnchor, paddingTop: 0, bottom: view.bottomAnchor, paddingBottom: 0, left: view.leadingAnchor, paddingLeft: 0, right: view.trailingAnchor, paddingRight: 0, width: 0, height: 0)

    }
    
    private func prepareLoadingIndicator() {
        view.addSubview(loadingIndicator)
        loadingIndicator.center = view.center
    }

    private func observerData() {
        viewModel.updateData = { [weak self] () in
            DispatchQueue.main.async {
                self?.loadingIndicator.stopAnimating()
                self?.tableView.reloadData()
            }
        }
        viewModel.showErrorMessage = { [weak self] errorMessage in
            self?.loadingIndicator.stopAnimating()
            self?.showErrorAlert(message: errorMessage)
        }
    }
    
    private func showErrorAlert(message: String) {
        DispatchQueue.main.async {
            AlertHelper.present(title: "Error Fetch Api", actions: .retry(handler: {
                self.viewModel.fetchGenreMovie()
            }), message: message, from: self)
        }
    }
    
    private func fetchData() {
        loadingIndicator.startAnimating()
        viewModel.fetchGenreMovie()
    }
}

extension MovieViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.genres.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = viewModel.genres[indexPath.row].name
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let movieListVc = MovieListViewController()
        movieListVc.genre = viewModel.genres[indexPath.row]
        tableView.deselectRow(at: indexPath, animated: true)
        navigationController?.pushViewController(movieListVc, animated: true)
    }
}
