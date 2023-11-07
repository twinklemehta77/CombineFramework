//
//  ViewController.swift
//  CombineFramework
//
//  Created by Twinkle Mehta on 06/11/23.
//

import UIKit
import Combine

class MyCustomeTableCell: UITableViewCell {
    private let button: UIButton = {
        let button = UIButton()
        button.backgroundColor = .systemBlue
        button.setTitle("Button 1", for: .normal)
        button.setTitleColor(.white, for: .normal)
        return button
    }()
    
    let action = PassthroughSubject<String,Never>()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(button)
        button.addTarget(self, action: #selector(didTapButton), for: .touchUpInside)
    }
    
    required init(coder: NSCoder) {
        fatalError()
    }
    
    @objc private func didTapButton(){
        action.send("Buuton was tapped")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        button.frame = CGRect(x: 10, y: 3, width: contentView.frame.width - 20, height: contentView.frame.height - 6)
    }
}

class ViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    var observers: [AnyCancellable] = []
    
    private var model = [String]()
    
    private let tableView:UITableView = {
        let table = UITableView()
        table.register(MyCustomeTableCell.self, forCellReuseIdentifier: "cell")
        return table
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.frame = view.bounds
        
        ApiCaller.shared.fetchCompanies()
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
            switch completion {
            case .finished:
                print("Success")
            case .failure(let error) :
                print(error)
            }
        }, receiveValue: { [weak self] value in
            self?.model = value
            self?.tableView.reloadData()
        }).store(in: &observers)
        
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? MyCustomeTableCell else {fatalError()}
//        cell.textLabel?.text = model[indexPath.row]
        cell.action.sink { string in
            print(string)
        }.store(in: &observers)
        return cell
    }
    


}

