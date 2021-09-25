import MapKit
import UIKit

protocol DetailViewModelProtocol {
    func didLoad(detailView: DetailViewProtocol)
}

struct CellModel {
    let name: String
    let distance: Double
}

class DetailViewController: UIViewController, UITableViewDataSource, DetailViewProtocol {
    
    // MARK: - Initializers
    
    static func newInstance(viewModel: DetailViewModelProtocol) -> DetailViewController {
        
        let storyboard = UIStoryboard(name: "Detail", bundle: nil)
        guard let viewController = storyboard.instantiateInitialViewController(creator: { coder in
            return DetailViewController(coder: coder, viewModel: viewModel)
        }) else {
            fatalError("DetailViewController failed to instantiate")
        }
        return viewController
    }
    
    init?(coder: NSCoder, viewModel: DetailViewModelProtocol) {
        self.viewModel = viewModel
        super.init(coder: coder)
    }
    
    required init?(coder: NSCoder) {
        fatalError("DetailViewModel object required at initialization")
    }
    
    // MARK: - Properties
    
    let viewModel: DetailViewModelProtocol
    var cellModels = [CellModel]()
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.didLoad(detailView: self)
    }
    
    // MARK: - Action
    
    @IBAction func dismissAction() {
        dismiss(animated: true)
    }
    
    // MARK: - DetailViewProtocol
    
    func updateView(with models: [CellModel]) {
        cellModels = models
        tableView.reloadData()
    }

    // MARK: - UITableViewDataSource

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        min(3, cellModels.count)
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let result = tableView.dequeueReusableCell(withIdentifier: "DetailCell", for: indexPath)
        let model = cellModels[indexPath.row]
        let distanceString = String(format: "%.2f", model.distance)
        result.textLabel?.text = model.name
        result.detailTextLabel?.text = "\(distanceString) miles"
        return result
    }
}

