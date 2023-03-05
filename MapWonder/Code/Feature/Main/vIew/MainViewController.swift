//
//  MainViewController.swift
//  MapWonder
//
//  Created by Jaime Tejeiro on 22/2/23.
//

import UIKit
import MapKit
import Combine

class MainViewController: BaseViewController {
    // MARK: - Properties
    var presenter: MainPresenter?
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var heightCollectionConstraint: NSLayoutConstraint!
    @IBOutlet weak var searchBar: UISearchBar!
    
    private var isCollectionView:Bool = false
    var cancellables = Set<AnyCancellable>()
    
    //MARK: - View Life Cycle Methods.
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupInit()
        self.startLoading()
        self.presenter?.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.presenter?.viewWillAppear()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.presenter?.viewDidAppear()
    }
    
    @IBAction func clickCenterMap(_ sender: Any) {
        DispatchQueue.main.async {
            self.reloadCenterAnnotationsMapView()
        }
    }
    
    @IBAction func clickReloadMap(_ sender: Any) {
        self.startLoading()
        presenter?.reloadPoisApiClient()
            
    }
    
    @IBAction func clickShowListMap(_ sender: Any) {
        self.setCollectionView(isHidden: isCollectionView)
        isCollectionView = !isCollectionView
    }
    
    func setCollectionView(isHidden: Bool) {
        collectionView.isHidden = !collectionView.isHidden
        
        if isHidden {
            self.heightCollectionConstraint.constant = 120
        } else {
            self.heightCollectionConstraint.constant = 0
        }
    }
}
// MARK: - MainViewController
extension MainViewController: MainView {
    
    func configView(){
        self.stopLoading()
        if let poisAnnotation = self.presenter?.getlistPoisList() {
            self.setupMapView(annotations: poisAnnotation)
            DispatchQueue.main.async {
                self.setupCollectionView()
            }
        }
    }
    
    func reloadFilterView(){
        if let poisAnnotation = self.presenter?.getlistPoisList() {
            DispatchQueue.main.async {
                self.stopLoading()
                self.configMapView(annotations: poisAnnotation)
                self.collectionView.reloadData()
            }
        }
    }
    
}
// MARK: - Private methods
private extension MainViewController {
    
    // MARK: - Setup
    func setupInit() {
        self.navigationItem.title = "Stadium"
        createrBindingViewWithPresenter()
    }
    
    func createrBindingViewWithPresenter() {
        searchBar
            .searchTextField
            .textPublisher
            .assign(to: \MainPresenterImpl.textFilter, on: (presenter as! MainPresenterImpl))
                .store(in: &cancellables)
    }
    
    func setupCollectionView(){
        registerCollectionViewNib()
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.allowsMultipleSelection = false
        
        let widthView:CGFloat = collectionView.frame.height * 1.5
        let heightView:CGFloat = collectionView.frame.height - 10
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.sectionInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        layout.itemSize = CGSize(width: widthView , height: heightView)
        
        collectionView!.collectionViewLayout = layout
    }
    
    private func registerCollectionViewNib(){
        let nib = MainCollectionViewCell.nib()
        collectionView.register(nib, forCellWithReuseIdentifier: MainCollectionViewCell.name())
    }
    
    func setupMapView(annotations: [PoisAnnotation]?){
        self.mapView.delegate = self
        self.configMapView(annotations: annotations)
    }
    
    func configMapView(annotations: [PoisAnnotation]?) {
        removeAnnotationsMapView()
        if let poisAnnotation = annotations {
            DispatchQueue.main.async {
                self.mapView.addAnnotations(poisAnnotation)
                self.reloadCenterAnnotationsMapView()
            }
        }
    }
    
    func removeAnnotationsMapView() {
        if !self.mapView.annotations.isEmpty {
            self.mapView.annotations.forEach { annotation in
                DispatchQueue.main.async {
                    self.mapView.removeAnnotation(annotation)
                }
            }
        }
    }
    func reloadCenterAnnotationsMapView(){
        if presenter?.getlistPoisCount() == 1 {
            if let annotation = presenter?.getlistPoisList().first {
                self.setLocation(location: annotation.coordinate, inBottomCenterOfMapView: self.mapView)
                return
            }
        }
        
        self.mapView.setVisibleMapRectToFitAllAnnotations()
    }
    
    func setLocation(location: CLLocationCoordinate2D, inBottomCenterOfMapView: MKMapView) {
        let oldRegion = inBottomCenterOfMapView.regionThatFits(MKCoordinateRegion(center: location, latitudinalMeters: 800, longitudinalMeters: 800))
        let centerPointOfOldRegion = oldRegion.center
        let centerPointOfNewRegion = CLLocationCoordinate2DMake(centerPointOfOldRegion.latitude + oldRegion.span.latitudeDelta/10.0, centerPointOfOldRegion.longitude)
        let newRegion = MKCoordinateRegion(center: centerPointOfNewRegion, span: oldRegion.span)
        inBottomCenterOfMapView.setRegion(newRegion, animated: true)
    }
}
//MARK: - MKMapViewDelegate methods.
extension MainViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        if let vModel = annotation as? PoisAnnotation {
            let identifier = vModel.identifier ?? "map"
            var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
            
            if annotationView == nil {
                annotationView = MapPoisAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                annotationView?.image = UIImage(named: "ic_stadium")
            } else {
                annotationView!.annotation = annotation
            }
            
            return annotationView
        }
        
        return MKAnnotationView()
    }
    
    func mapView(_ mapView: MKMapView, didSelect annotation: MKAnnotation) {
        setLocation(location: annotation.coordinate, inBottomCenterOfMapView: mapView)
        if let cell = annotation as? PoisAnnotation {
            let n = Int(cell.identifier ?? "0") ?? 0
            goToCollectionCell(row: (n - 1))
        }
    }
}
extension MainViewController: UICollectionViewDelegate, UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return presenter?.getlistPoisCount() ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MainCollectionViewCell.name(), for: indexPath) as? MainCollectionViewCell else{
            return UICollectionViewCell()
        }
        if let pointer = presenter?.getlistPoisList()[indexPath.row]{
            cell.setupCell(model: pointer)
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) as? MainCollectionViewCell {
            if let poisAnnotation = presenter?.getlistPoisList().first(where: ( {$0.identifier == cell.identifier})) {
                DispatchQueue.main.async {
                    self.setLocation(location: poisAnnotation.coordinate , inBottomCenterOfMapView: self.mapView)
                }
            }
        }
    }
    
    func goToCollectionCell(row:Int){
        
        if presenter?.getlistPoisCount() == 1 {
            return
        }
        
        DispatchQueue.main.async {
            let allWidthCollection:CGFloat = self.collectionView.collectionViewLayout.collectionViewContentSize.width
            let spaceCellWidth:CGFloat = allWidthCollection / CGFloat(self.presenter?.getlistPoisCount() ?? 0)
            let pageWidthX:CGFloat = spaceCellWidth * CGFloat(row)
            let point:CGPoint = CGPoint(x: pageWidthX, y: 0.0)
            self.collectionView.setContentOffset(point, animated: true)
        }
    }
}
