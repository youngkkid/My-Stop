import UIKit

final class AlertManager {
    
    static let shared = AlertManager()
    
    private init() {}
    
    func showDeleteConfirmation(on viewController: UIViewController, title: String, handler: @escaping () -> Void) {
        
        let alert = UIAlertController(title: title,
                                      message: nil,
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Удалить",
                                      style: .default) { _ in
            handler()
        })
        
        alert.addAction(UIAlertAction(title: "Отмена",
                                      style: .default,
                                      handler: nil))
        
        viewController.present(alert, animated: true)
    }
    
    func showPinInfo(with title: String, message: String?, from viewController: UIViewController, onAdd: (() -> Void)? = nil) {
        let alert = UIAlertController(title: title,
                                      message: message,
                                      preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "Добавить", style: .default) {_ in
            onAdd?()
        })
        
        alert.addAction(UIAlertAction(title: "Отмена", style: .cancel, handler: nil))
        
        viewController.present(alert, animated: true)
    }
}
