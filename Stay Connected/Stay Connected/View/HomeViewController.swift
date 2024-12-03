import UIKit
import Combine

class HomeViewController: UIViewController, UITableViewDataSource {

    private let viewModel = HomeViewModel()
    private var cancellables = Set<AnyCancellable>()


    private let tableView = UITableView()

    private let questionsLabel: UILabel = {
        let label = UILabel()
        label.text = "Questions"
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        label.textAlignment = .left
        return label
    }()
    
    private let addButton: UIButton = {
        let button = UIButton()
        button.setTitle("+", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 35)
        button.setTitleColor(.systemPurple, for: .normal)
        button.backgroundColor = UIColor.white
        button.layer.cornerRadius = 16
        button.addTarget(self, action: #selector(addButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private let generalButton: UIButton = {
        let button = UIButton()
        button.setTitle("General", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        button.backgroundColor = UIColor(red: 78/255, green: 83/255, blue: 162/255, alpha: 1)
        button.layer.cornerRadius = 12
        button.setTitleColor(.white, for: .normal)
        return button
    }()
    
    private let personalButton: UIButton = {
        let button = UIButton()
        button.setTitle("Personal", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        button.backgroundColor = UIColor(red: 119/255, green: 126/255, blue: 153/255, alpha: 1)
        button.layer.cornerRadius = 12
        button.setTitleColor(.white, for: .normal)
        return button
    }()
    
    private let searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.placeholder = "Search"
        searchBar.searchTextField.font = UIFont.systemFont(ofSize: 17)
        searchBar.searchTextField.backgroundColor = UIColor(white: 0.9, alpha: 1)
        searchBar.searchTextField.leftView?.tintColor = UIColor(white: 0.6, alpha: 1)
        return searchBar
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bindViewModel()
       viewModel.fetchQuestions()
        self.navigationItem.hidesBackButton = true
        navigationController?.setNavigationBarHidden(true, animated: false)
    }

    private func setupUI() {
        view.backgroundColor = .white
        questionsLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(questionsLabel)

        addButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(addButton)

        generalButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(generalButton)

        personalButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(personalButton)

        searchBar.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(searchBar)

        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(QuestionTableViewCell.self, forCellReuseIdentifier: QuestionTableViewCell.identifier)
        view.addSubview(tableView)
        tableView.backgroundColor = .white
        tableView.dataSource = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 80
        tableView.separatorStyle = .none
        tableView.contentInset = UIEdgeInsets(top: 8, left: 0, bottom: 8, right: 0)
        
        NSLayoutConstraint.activate([
            questionsLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 5),
            questionsLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 12),
            questionsLabel.widthAnchor.constraint(equalToConstant: 120),
            questionsLabel.heightAnchor.constraint(equalToConstant: 21),

            addButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 5),
            addButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            addButton.widthAnchor.constraint(equalToConstant: 32),
            addButton.heightAnchor.constraint(equalToConstant: 32),
            
            generalButton.topAnchor.constraint(equalTo: questionsLabel.bottomAnchor, constant: 20),
            generalButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            generalButton.widthAnchor.constraint(equalToConstant: 180),
            generalButton.heightAnchor.constraint(equalToConstant: 39),
            
            personalButton.topAnchor.constraint(equalTo: questionsLabel.bottomAnchor, constant: 20),
            personalButton.leadingAnchor.constraint(equalTo: generalButton.trailingAnchor, constant: 10),
            personalButton.widthAnchor.constraint(equalToConstant: 170),
            personalButton.heightAnchor.constraint(equalToConstant: 39),

            searchBar.topAnchor.constraint(equalTo: generalButton.bottomAnchor, constant: 20),
            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            searchBar.heightAnchor.constraint(equalToConstant: 38),

            tableView.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 10),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    @objc private func addButtonTapped() {
        print("Add button tapped")
    }

    private func bindViewModel() {
        viewModel.$questions
            .receive(on: RunLoop.main)
            .sink { [weak self] _ in
                self?.tableView.reloadData()
            }
            .store(in: &cancellables)

        viewModel.$errorMessage
            .receive(on: RunLoop.main)
            .sink { [weak self] error in
                if let error = error {
                    self?.showAlert(title: "Error", message: error)
                }
            }
            .store(in: &cancellables)
    }

    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.questions.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: QuestionTableViewCell.identifier, for: indexPath) as? QuestionTableViewCell else {
            return UITableViewCell()
        }

        let question = viewModel.questions[indexPath.row]
        let tagTitle = viewModel.tagTitles[indexPath.row]
        let repliesCount = viewModel.repliesCount[indexPath.row]

        cell.configure(with: question, tagTitle: tagTitle, repliesCount: repliesCount)
        return cell
    }
}
