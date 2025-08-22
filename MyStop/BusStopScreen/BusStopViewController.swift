import UIKit
import SnapKit

final class BusStopViewController: UIViewController {
    
    // MARK: - Static Properties
    
    private var stops: [BusStopItemModel] = []
    
    // MARK: - UI Elements
    
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
        tableView.register(BusStopTableViewCell.self, forCellReuseIdentifier: BusStopTableViewCell.reuseIdentifier)
        tableView.delegate = self
        tableView.dataSource = self
        return tableView
    }()
    
    private lazy var newStopButton: UIButton = {
        let button = UIButton()
        button.setTitle("Новая остановка", for: .normal)
        button.titleLabel?.numberOfLines = 2
        button.titleLabel?.textAlignment = .center
        button.backgroundColor = .systemBlue
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 17, weight: .medium)
        button.layer.cornerRadius = 16
        button.layer.masksToBounds = true
        
        button.addTarget(self, action: #selector(newStopButtonTapped), for: .touchUpInside)
        
        return button
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        updateStubVisibility()
        setNavItem()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    // MARK: - Private Methods
    
    private func updateStubVisibility() {
        let isEmpty = stops.isEmpty
        stopsTableView.isHidden = isEmpty
        stopImageStub.isHidden = !isEmpty
        stopTextStub.isHidden = !isEmpty
    }
    
    private func setNavItem() {
        navigationController?.navigationBar.tintColor = .black
        navigationItem.backButtonDisplayMode = .minimal
    }
    
    @objc
    private func newStopButtonTapped() {
        let mapView = MapViewController()
        
        mapView.onBusStopSelected = { [weak self] stop in
            guard let self = self else {return}
            self.stops.append(stop)
            self.stopsTableView.reloadData()
            self.updateStubVisibility()
        }
        
        navigationController?.pushViewController(mapView, animated: true)
    }
    
}

// MARK: - UITableViewDataSource

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

// MARK: - UITableViewDelegate

extension BusStopViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "") { [weak self] action, view, completion in
            guard let self = self else {return}
            
            AlertManager.shared.showDeleteConfirmation(on: self, title: "Вы действительно хотите удалить остановку?") {
                
                self.stops.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .automatic)
                self.updateStubVisibility()
            }
            completion(true)
        }
        
        deleteAction.image = UIImage(systemName: "trash")
        
        let config = UISwipeActionsConfiguration(actions: [deleteAction])
        config.performsFirstActionWithFullSwipe = false
        return config
    }
}

// MARK: - Layout

extension BusStopViewController {
    private func setupViews() {
        view.backgroundColor = .systemBackground
        
        setupStubView()
        setupBusStopTitleLabel()
        setupTableView()
        setupNewStopButton()
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
    
    private func setupNewStopButton() {
        view.addSubview(newStopButton)
        
        newStopButton.snp.makeConstraints {make in
            make.centerX.equalTo(view.snp.centerX)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).inset(26)
            make.height.equalTo(50)
            make.width.equalTo(114)
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
