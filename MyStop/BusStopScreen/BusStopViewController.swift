import UIKit
import SnapKit

final class BusStopViewController: UIViewController {
    
    private var stops: [BusStopItemModel] = [
        BusStopItemModel(street: "Петроградская", busses: "1, 46, 76"),
        BusStopItemModel(street: "Горьковская", busses: "228, 1488")
    ]
    
    private lazy var busStopTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Остановки"
        label.font = .systemFont(ofSize: 34 , weight: .bold)
        label.textColor = .black
        
        return label
    }()
    
    private lazy var stopImageStub: UIImageView = {
        let image = UIImage(resource: .imageStub)
        let imageView = UIImageView(image: image)
        return imageView
    }()
    
    private lazy var stopTextStub: UILabel = {
        let label = UILabel()
        label.text = "Здесь будут ваши остановки"
        label.font = .systemFont(ofSize: 12, weight: .medium)
        label.textColor = .black
        return label
    }()
    
    private lazy var stopsTableView: UITableView = {
        let tableView = UITableView()
        tableView.register(BusStopTableViewCell.self, forCellReuseIdentifier: BusStopTableViewCell.reuseIdentifier) // добавить класс ячейки
        tableView.delegate = self
        tableView.dataSource = self
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialize()
        updateUI()
    }
    
    private func updateUI() {
        let isEmpty = stops.isEmpty
        stopsTableView.isHidden = isEmpty
        stopImageStub.isHidden = !isEmpty
        stopTextStub.isHidden = !isEmpty
    }
}

extension BusStopViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        stops.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: BusStopTableViewCell.reuseIdentifier, for: indexPath)
        guard let cell = cell as? BusStopTableViewCell else {
            return UITableViewCell()
        }
        
        let model = stops[indexPath.row]
        cell.configure(with: model)
        return cell
    }
    
}

extension BusStopViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "") { [weak self] action, view, completion in
            guard let self = self else {return}
            
            AlertManager.shared.showDeleteConfirmation(on: self, title: "Вы действительно хотите удалить остановку?") {
                
                self.stops.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .automatic)
                self.updateUI()
            }
            completion(true)
        }
        
        deleteAction.image = UIImage(systemName: "trash")
        
        let config = UISwipeActionsConfiguration(actions: [deleteAction])
        config.performsFirstActionWithFullSwipe = false
        return config
    }
}

extension BusStopViewController {
    private func initialize() {
        view.backgroundColor = .systemBackground
        
        setupStubView()
        setupBusStopTitleLabel()
        setupTableView()
    }
    
    private func setupStubView() {
        [stopImageStub,
         stopTextStub].forEach{
            view.addSubview($0)
        }
        
        stopImageStub.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
        }
        
        stopTextStub.snp.makeConstraints { make in
            make.centerX.equalTo(stopImageStub.snp.centerX)
            make.top.equalTo(stopImageStub.snp.bottom).offset(4)
        }
    }
    
    private func setupBusStopTitleLabel() {
        view.addSubview(busStopTitleLabel)
        
        busStopTitleLabel.snp.makeConstraints {make in
            make.leading.equalTo(view.safeAreaLayoutGuide.snp.leading).offset(16)
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(19)
        }
    }
    
    private func setupTableView() {
        view.addSubview(stopsTableView)
        stopsTableView.snp.makeConstraints {make in
            make.top.equalTo(busStopTitleLabel.snp.bottom).offset(28)
            make.leading.trailing.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
}
