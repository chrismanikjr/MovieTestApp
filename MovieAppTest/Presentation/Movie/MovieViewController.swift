//
//  ViewController.swift
//  MovieAppTest
//
//  Created by Chrismanto Natanail Manik on 01/06/24.
//

import UIKit

class MovieViewController: UIViewController {
    private var listener = MovieViewModel()
    private lazy var tableView = UITableView()
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareTableView()
        observerData()
        listener.fetchGenreMovie()
        
        // Do any additional setup after loading the view.
    }

    func prepareTableView(){
        view.addSubview(tableView)
        tableView.anchor(top: view.topAnchor, paddingTop: 0, bottom: view.bottomAnchor, paddingBottom: 0, left: view.leadingAnchor, paddingLeft: 0, right: view.trailingAnchor, paddingRight: 0, width: 0, height: 0)
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func observerData(){
        listener.updateData = {[weak self] () in
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
        listener.showErrorMessage = {[weak self] errorMessage in
            self?.showErrorAlert(message: errorMessage)
        }
    }
    
    private func showErrorAlert(message: String){
        AlertHelper.present(title: "Error", actions: .close, message: message, from: self)
    }

}

extension MovieViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listener.genres.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = listener.genres[indexPath.row].name
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let movieListVc = MovieListViewController()
        movieListVc.genre =  listener.genres[indexPath.row]
        self.navigationController?.pushViewController(movieListVc, animated: true)
    }
}
