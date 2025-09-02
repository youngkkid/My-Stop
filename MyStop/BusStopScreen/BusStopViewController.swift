import UIKit
import CoreLocation
import SnapKit

final class BusStopViewController: UIViewController {
    
    // MARK: - Static Properties
    
    private let manager: BusStopManaging
    private let locationManager = CLLocationManager()
    
    // MARK: - Init
    
    init(manager: BusStopManaging) {
        self.manager = manager
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UI Elements
    
    private lazy var busStopTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Остановки"
        label.font = .systemFont(ofSize: UIConstants.busStopTitleLabelFont , weight: .bold)
        label.textColor = .label
        
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
        label.font = .systemFont(ofSize: UIConstants.stopTextStubFont, weight: .medium)
        label.textColor = .secondaryLabel
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
        button.titleLabel?.font = .systemFont(ofSize: UIConstants.newStopButtonFont, weight: .medium)
        button.layer.cornerRadius = UIConstants.newStopButtonCorner
        button.layer.masksToBounds = true
        
        button.addTarget(self, action: #selector(newStopButtonTapped), for: .touchUpInside)
        
        return button
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        setNavItem()
        setupLocationManager()
        
        manager.addObserver { [weak self] stops in
            DispatchQueue.main.async {
                self?.stopsTableView.reloadData()
                self?.updateStubVisibility(stops: stops)
            }
        }
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
    
    private func updateStubVisibility(stops: [BusStopItemModel]) {
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
        let mapView = MapViewController(manager: manager)
        navigationController?.pushViewController(mapView, animated: true)
    }
    
}

// MARK: - UITableViewDataSource

extension BusStopViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        manager.stops.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: BusStopTableViewCell.reuseIdentifier, for: indexPath)
        guard let cell = cell as? BusStopTableViewCell else {
            return UITableViewCell()
        }
        
        let model = manager.stops[indexPath.row]
        cell.configure(with: model)
        return cell
    }
}

// MARK: - UITableViewDelegate

extension BusStopViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "") { [weak self] action, view, completion in
            guard let self = self else {return}
            
            let stop = self.manager.stops[indexPath.row]
            
            AlertManager.shared.showDeleteConfirmation(on: self, title: "Вы действительно хотите удалить остановку?") {
                
                self.manager.removeStop(stop)
            }
            completion(true)
        }
        
        deleteAction.image = UIImage(systemName: "trash")
        
        let config = UISwipeActionsConfiguration(actions: [deleteAction])
        config.performsFirstActionWithFullSwipe = false
        return config
    }
}

// MARK: - CLLocationManagerDelegate

extension BusStopViewController: CLLocationManagerDelegate {
    private func setupLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.allowsBackgroundLocationUpdates = true
        locationManager.pausesLocationUpdatesAutomatically = false
        
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .authorizedWhenInUse:
            manager.requestAlwaysAuthorization()
        case .authorizedAlways:
            manager.startUpdatingLocation()
        default:
            break
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else {return}
        
        NoNotificationManager.shared.locationManager(for: self.manager.stops, userLocations: location)
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
