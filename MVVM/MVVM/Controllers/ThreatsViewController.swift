import UIKit

class ThreatsViewController: UIViewController {
    private let cellIdentifier = "ImageCell"
    private let headerIdentifier = "HeaderView"
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    let viewModel = ThreatsViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if !LoginService.isAuthenticated {
            presentLoginViewController()
        }
    }
}

// MARK: UICollectionViewDataSource
extension ThreatsViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath as IndexPath) as! ImageCollectionViewCell
        
        /// Retrieve an object in section
        let images = viewModel.threats[indexPath.section]
        /// Retrieve every image in object image array
        let imagepath = images.imagePaths[indexPath.row]
        cell.imageView.image = UIImage(named: imagepath)
        
        return cell
    }
    
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        /// Retrieve number of section based on number of object in threats
        return  viewModel.threats.count
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        /// Retrive number of cell to show from number of images in array
        return  viewModel.threats[section].imagePaths.count
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerIdentifier, for: indexPath)
            as! ResultsHeaderView
            
            let threat = viewModel.threats[indexPath.section]
            headerView.titleLabel.text = threat.firstName + " " + threat.lastName
            return headerView
        }
        assert(false, "Unexpected element kind")
    }
    
}

// MARK: UICollectionViewDelegateFlowLayout
extension ThreatsViewController: UICollectionViewDelegateFlowLayout {
    private func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        let cellWidth = (collectionView.bounds.width - CGFloat(30)) / 2.0
        return CGSize(width: cellWidth, height: cellWidth)
    }
}

// MARK: Actions
extension ThreatsViewController {
    @IBAction func logoutPressed() {
        LoginService.logout {
            self.presentLoginViewController() {
                /// Clear data after user log out
                self.viewModel.removeThreats()
            }
        }
    }
}

// MARK: Private Methods
private extension ThreatsViewController {
    func presentLoginViewController(completion: (() -> Void)? = nil) {
        let loginVC = storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
        loginVC.loginSuccess = {
            self.activityIndicator.startAnimating()
            self.dismiss(animated: true) {
                
                /// Fetch threats from api after user login
                self.viewModel.fetchThreats()
            }
        }
        present(loginVC, animated: true, completion: completion)
    }
}

//MARK: - ThreatsViewModelDelegate
extension ThreatsViewController : ThreatsViewModelDelegate {
    func didReceiveThreatsData(_ viewModel: ThreatsViewModel) {
        activityIndicator.stopAnimating()
        collectionView.reloadData()
    }
}
