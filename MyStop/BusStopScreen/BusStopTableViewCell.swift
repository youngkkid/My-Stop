import UIKit
import SnapKit

final class BusStopTableViewCell: UITableViewCell {
    
    // MARK: - Static Properties
    
    static let reuseIdentifier = "BusStopTableViewCell"
    
    // MARK: - UI Elements
    
    let stopImageView: UIImageView = {
        let image = UIImage(resource: .stop)
        let imageView = UIImageView(image: image)
        imageView.layer.cornerRadius = 12
        imageView.clipsToBounds = true
        
        return imageView
    }()
    
    private let stopTitleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.font = .systemFont(ofSize: 17, weight: .regular)
        label.textColor = .black
        
        return label
    }()
    
    private let busListTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Автобусы"
        label.numberOfLines = 1
        label.font = .systemFont(ofSize: 17, weight: .bold)
        label.textColor = .black
        
        return label
    }()
    
    private let busListLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17, weight: .regular)
        label.textColor = .green
        
        return label
    }()
    
    private var infoVStack = UIStackView()
    private var busListHStack = UIStackView()
    private var titleAndBusListVSStack = UIStackView()
    
    // MARK: - Init
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
        contentView.addSubview(stopImageView)
        
        setupImage()
        setupStopInfo()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(
            top: 4,
            left: 4,
            bottom: 4,
            right: 4
        )
        )
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        stopTitleLabel.text = nil
        busListLabel.text = nil
    }
    
    // MARK: - Public Methods
    
    func configure(with model: BusStopItemModel) {
        stopTitleLabel.text = model.street
        busListLabel.text = model.busses
    }
    
    // MARK: - Private Methods
    
    private func setupImage() {
        stopImageView.snp.makeConstraints { make in
            make.leading.equalTo(contentView.snp.leading)
            make.verticalEdges.equalTo(contentView.snp.verticalEdges)
            make.size.equalTo(stopImageView.snp.height)
        }
    }
    
    private func setupStopInfo() {
        titleAndBusListVSStack = UIStackView(arrangedSubviews: [stopTitleLabel])
        
        let busVSStack = UIStackView(arrangedSubviews: [busListTitleLabel, busListLabel])
        let infoVSStack = UIStackView(arrangedSubviews: [titleAndBusListVSStack, busVSStack])
        
        [infoVSStack,
         titleAndBusListVSStack,
         busVSStack].forEach {
            $0.axis = .vertical
            $0.alignment = .leading
        }
        
        titleAndBusListVSStack.spacing = 4
        busVSStack.spacing = 12
        infoVSStack.spacing = 12
        
        self.infoVStack = infoVSStack
        contentView.addSubview(self.infoVStack)
        self.infoVStack.snp.makeConstraints { make in
            make.verticalEdges.equalTo(contentView.snp.verticalEdges).inset(8)
            make.leading.equalTo(stopImageView.snp.trailing).offset(20)
        }
    }
}
