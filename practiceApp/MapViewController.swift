//
//  MapViewController.swift
//  practiceApp
//
//  Created by t032fj on 2024/02/29.
//

import UIKit
import MapKit
import CoreLocation
import Combine

class MapViewController: BaseViewController, CLLocationManagerDelegate, MKMapViewDelegate, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var mapTableView: UITableView!
    @IBOutlet weak var currentButton: UIButton!
    @IBOutlet weak var mapDetailView: UIView!
    
    var locationManager: CLLocationManager!
    var currentPlace: MKPlacemark?
    var route: MKRoute?
    var currentlocation: CLLocationCoordinate2D!
    var mapViewModel: MapViewMode?
    var isMapInitial: Bool = true
    
    private var cancellables = Set<AnyCancellable>()
    
    var locations: [Location] = [] {
        didSet {
            Task {
                do {
                    let systemIds = locations.map { location in
                        return location.systemid
                    }
                    for i in 0..<systemIds.count  {
                        var status: Int = 1
                        repeat {
                            status = try await mapViewModel?.searchBook(systemId: systemIds[i]) ?? 1
                        } while status != 0
                    }
                } catch {
                    print(error)
                }
            }
            
            DispatchQueue.main.async {
                _ = self.locations.map { location in
                    let geocodes: [String] = location.geocode.components(separatedBy: ",")
                    let pin = MKPointAnnotation()
                    pin.coordinate = CLLocationCoordinate2DMake(Double(geocodes[1])!, Double(geocodes[0])!)
                    pin.title = location.short
                    pin.subtitle = location.systemid
                    self.mapView.addAnnotation(pin)
                }
                
                self.mapTableView.reloadData()
            }
        }
    }
    
    var mapDetailViewController: MapDetailViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapViewModel = model as? MapViewMode
        
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        
        mapView.delegate = self
        mapView.userTrackingMode = MKUserTrackingMode.none
        mapView.showsUserLocation = true
 
        mapTableView.delegate = self
        mapTableView.dataSource = self
        mapTableView.register(UINib(nibName: "SearchTableViewCell", bundle: nil), forCellReuseIdentifier: "SearchTableViewCell")
        
        mapDetailViewController = self.children[0] as? MapDetailViewController
     
        setupCombine()
    }
    
    override func viewDidLayoutSubviews() {
        currentButton.layer.cornerRadius = 25
        mapDetailView.isHidden = true
    }
    
    private func setupCombine() {
        _ = mapViewModel?.subject.sink(receiveCompletion: { error in
            print(error)
        }, receiveValue: { statusDics in
            self.mapDetailViewController?.statusDics = statusDics
            self.mapTableView.reloadData()
        }).store(in: &cancellables)
        
        _ = mapDetailViewController?.buttonPressedSubject.sink(receiveValue: { _ in
            self.mapDetailView.isHidden = true
        }).store(in: &cancellables)
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .notDetermined:
            manager.requestWhenInUseAuthorization()
        case .restricted, .denied:
            break
        case .authorizedAlways, .authorizedWhenInUse:
            manager.startUpdatingLocation()
            break
        default:
            break
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        guard let newLocation = locations.last else { return }
        
        currentlocation
        = CLLocationCoordinate2DMake(newLocation.coordinate.latitude, newLocation.coordinate.longitude)
        
        if isMapInitial {
            var region: MKCoordinateRegion = self.mapView.region
            region.center = currentlocation
            region.span.latitudeDelta = 0.02 // 倍率の設定
            region.span.longitudeDelta = 0.02 // 倍率の設定
            self.mapView.setRegion(region, animated: false) // 倍率の適用
            isMapInitial = false
        }
 
        Task {
            do {
                guard let locations = try await mapViewModel?.getLocationData(location: currentlocation!) else { return }
                self.locations = locations
            } catch {
                print(error)
            }
        }
    }
    
    /// ピンをタップした時に呼ばれる(ピンの詳細情報を出したりする)
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        guard let annotation = view.annotation else { return }
        mapDetailView.isHidden = false
        print(annotation.title)
        print(annotation.subtitle)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return locations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SearchTableViewCell", for: indexPath) as! SearchTableViewCell
        cell.titleLabel.text = locations[indexPath.row].short
        cell.imageView1.image = mapViewModel?.itemUIImage
        if mapViewModel?.systemIds.contains(locations[indexPath.row].systemid) == true {
            cell.statusLabel.text = "本有"
        } else {
            cell.statusLabel.text = "本無"
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        let geocode: String = locations[indexPath.row].geocode
        let geocodes: [String] = geocode.components(separatedBy: ",")
        mapView.setCenter(CLLocationCoordinate2D(latitude: Double(geocodes[1])!, longitude: Double(geocodes[0])!), animated: false)
        
        mapDetailView.isHidden = false
        mapDetailViewController?.label?.text = locations[indexPath.row].systemid
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return  100
    }
    
    @IBAction func goBackView(_ sender: Any) {
        Router(viewController: self, nameVC: nil, model: nil).goBackView()
    }
    
    @IBAction func currentLocation(_ sender: Any) {
        var region: MKCoordinateRegion = mapView.region
        region.center = currentlocation!
        region.span.latitudeDelta = 0.02 // 倍率の設定
        region.span.longitudeDelta = 0.02 // 倍率の設定
        mapView.setRegion(region, animated: false) // 倍率の適用
    }
}
