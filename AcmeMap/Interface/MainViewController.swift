import MapKit
import UIKit

protocol MainViewModelProtocol {
    func didLoad(mainView: MainViewProtocol)
    func didSelect(annotation: MKAnnotation?)
    func updateGeoJSON()
}

class MainViewController: UIViewController, MKMapViewDelegate, MainViewProtocol {
    
    // MARK: - Initializers
    
    static func newInstance(viewModel: MainViewModelProtocol) -> MainViewController {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let viewController = storyboard.instantiateInitialViewController(creator: { coder in
            return MainViewController(coder: coder, viewModel: viewModel)
        }) else {
            fatalError("MainViewController failed to instantiate")
        }
        return viewController
    }
    
    init?(coder: NSCoder, viewModel: MainViewModelProtocol) {
        self.viewModel = viewModel
        super.init(coder: coder)
    }
    
    required init?(coder: NSCoder) {
        fatalError("MainViewModel object required at initialization")
    }
    
    // MARK: - Properties
    
    let viewModel: MainViewModelProtocol
    @IBOutlet private var mapView: MKMapView!
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.didLoad(mainView: self)
    }
    
    // MARK: - MainViewProtocol
    
    func addFeatureAnnotations(annotations: [AcmePointAnnotation]) {
        mapView.addAnnotations(annotations)
    }
    
    func presentDetailView(with detailInfo: DetailInfo) {
        let detailViewModel = DetailViewModel(detailInfo: detailInfo)
        let detailViewController = DetailViewController.newInstance(viewModel: detailViewModel)
        present(detailViewController, animated: true)
    }
    
    func showNetworkAlert(message: String) {
        
        let alertController = UIAlertController(
            title: "Feature Import Failed",
            message: "\(message)",
            preferredStyle: .alert
        )
        
        alertController.addAction(
            UIAlertAction(title: "Retry", style: .default, handler: { [weak self] _ in
                self?.viewModel.updateGeoJSON()
            })
        )
        
        alertController.addAction(
            UIAlertAction(title: "Dismiss", style: .cancel)
        )
        
        self.present(alertController, animated: true, completion: nil)

    }
    
    // MARK: - MKMapViewDelegate
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        viewModel.didSelect(annotation: view.annotation)
    }
}
