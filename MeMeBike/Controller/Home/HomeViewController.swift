//
//  HomeViewController.swift
//  MeMeBike
//
//  Created by Rey on 13/05/21.
//  Copyright © 2021 MeMeWorldWide. All rights reserved.
//


import UIKit
import GoogleMaps
import CoreLocation
import SideMenu
import Alamofire
import SwiftyJSON
import ProgressHUD
import AVFoundation

class HomeViewController: UIViewController ,SideMenuNavigationControllerDelegate,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,CLLocationManagerDelegate,UIScrollViewDelegate,UITableViewDelegate,UITableViewDataSource,AVCaptureMetadataOutputObjectsDelegate{
    
    @IBOutlet weak var locationTxt: UITextField!
    @IBOutlet weak var iconBtn: UIButton!
    @IBOutlet weak var destinationTxt: UITextField!
    @IBOutlet weak var locationStack: UIStackView!
    @IBOutlet weak var destinationStack: UIStackView!
    @IBOutlet weak var locationIcon: UIImageView!
    @IBOutlet weak var destinationIcon: UIImageView!
    @IBOutlet weak var scanView: UIView!
    @IBOutlet weak var metroStationCollectionView: UICollectionView!
    @IBOutlet weak var gpsButton: UIButton!
    @IBOutlet weak var destinationButton: UIButton!
    @IBOutlet weak var startRiewView: UIView!
    @IBOutlet weak var rideDetailsView: UIView!
    @IBOutlet weak var helpBtn: UIButton!
    @IBOutlet weak var cancelBtn: UIButton!
    @IBOutlet weak var startRideBtn: UIButton!
    @IBOutlet weak var startImage: UIButton!
    @IBOutlet weak var startImageView: UIView!
    @IBOutlet weak var startRideView: UIView!
    @IBOutlet weak var endRide: UIButton!
    @IBOutlet weak var startRide: UILabel!
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var timeElapsedStackView: UIStackView!
    @IBOutlet weak var yourRideHasStarted: UILabel!
    @IBOutlet weak var pleaseParkRide: UILabel!
    @IBOutlet weak var endRideView: UIView!
    @IBOutlet weak var rupeeButton: UIButton!
    @IBOutlet weak var payButton: UIButton!
  
    @IBOutlet weak var dropDownTableView: UITableView!
    @IBOutlet weak var lineView: UIView!
    
    @IBOutlet var scanBtn: UIButton!
    
    
    let newerpage: Int = 0
    let pageControl = UIPageControl()
    var stationaddress : [String] = []
    var stationLatitude : [Double] = []
    var stationLongitude : [Double] = []
    var mapView = GMSMapView()
    var manager = CLLocationManager()
    var captureSession: AVCaptureSession!
    var previewLayer: AVCaptureVideoPreviewLayer!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigation()
        textPlacholderColor()
        sidemenuCustomView()
        addPageControl()
        initializeAuthendication()
        tapGesture()
        scanQRCode()
    }
    
    func navigation() {
        metroStationCollectionView.delegate = self
        metroStationCollectionView.dataSource = self
        navigationController?.navigationBar.isHidden = true
        self.navigationItem.leftBarButtonItem?.isEnabled = true
        self.navigationItem.leftBarButtonItem?.tintColor = .blue
        metroStationCollectionView.isPagingEnabled = true
        startRiewView.isHidden = true
        rideDetailsView.isHidden = true
        startImage.tag = 0
        endRideView.layer.cornerRadius = 10
        dropDownTableView.delegate = self
        dropDownTableView.dataSource = self
        
        ProgressHUD.show()
        ProgressHUD.animationType = .circleStrokeSpin

    }
    
    func initializeAuthendication() {
        manager.delegate = self
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
        manager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    func scanQRCode() {
        view.backgroundColor = UIColor.black
                captureSession = AVCaptureSession()
                guard let videoCaptureDevice = AVCaptureDevice.default(for: .video)
                else {
                    
                    print("your device is not applicable for video processing")
                    return
                    
                }
                let videoInput: AVCaptureDeviceInput
                do {
                    videoInput = try AVCaptureDeviceInput(device: videoCaptureDevice)
                } catch {
                    return
                }

                if (captureSession.canAddInput(videoInput)) {
                    captureSession.addInput(videoInput)
                } else {
                    failed()
                    return
                }

                let metadataOutput = AVCaptureMetadataOutput()

                if (captureSession.canAddOutput(metadataOutput)) {
                    captureSession.addOutput(metadataOutput)

                    metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
                    metadataOutput.metadataObjectTypes = [.qr]
                } else {
                    failed()
                    return
                }

                previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
                previewLayer.frame = view.layer.bounds
                previewLayer.videoGravity = .resizeAspectFill
                view.layer.addSublayer(previewLayer)

                captureSession.startRunning()
    }
    
    func failed() {
            let ac = UIAlertController(title: "Scanning not supported", message: "Your device does not support scanning a code from an item. Please use a device with a camera.", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
            captureSession = nil
        }
    
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
           captureSession.stopRunning()
           if let metadataObject = metadataObjects.first {
               guard let readableObject = metadataObject as? AVMetadataMachineReadableCodeObject else { return }
               guard let stringValue = readableObject.stringValue else { return }
               AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
               found(code: stringValue)
           }

           dismiss(animated: true)
       }
    
    func found(code: String) {
            print(code)
        }
    
    
    @IBAction func scanQRCode(_ sender: UIButton){
        
        scanQRCode()
    }
    
    func tapGesture() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
         destinationTxt.addGestureRecognizer(tap)
        locationTxt.addGestureRecognizer(tap)
    
    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer? = nil) {
        dropDownTableView.isHidden = false
        
        scanQRCode()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return stationaddress.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = dropDownTableView.dequeueReusableCell(withIdentifier: "dropdown", for: indexPath) as! DropDownTableViewCell
        
        for i in 0 ..< stationaddress.count
        {
            DispatchQueue.main.async { [self] in
                cell.dropDownLabel.text = stationaddress[indexPath.row]
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        var selectedCell = indexPath.row
        var destionation = stationaddress[indexPath.row]
        destinationTxt.text = destionation
        dropDownTableView.isHidden = true
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 45.0;
    }
   
    func startRideScreen() {
        rideDetailsView.layer.cornerRadius = 20
        cancelBtn.layer.cornerRadius = 10
        let originalImage  = UIImage(named: "logout")
        startImage.setImage(originalImage, for: .normal)
        startImage.tintColor = UIColor(rgb: 0x00A7FC)
        startImageView.layer.cornerRadius = 20
        startRiewView.roundCorners(corners: [.topLeft,.topRight,.bottomLeft,.bottomRight], radius: 20)
    }
    
    func pauseRideScreen() {
        startRideView.layer.cornerRadius = 20
        endRide.layer.cornerRadius = 10
        startImageView.layer.cornerRadius = 20
        let originalImage  = UIImage(named: "pause-1")
        startImage.setImage(originalImage, for: .normal)
        startImage.tintColor = UIColor(rgb: 0x00A7FC)
    }

    override func viewWillAppear(_ animated: Bool) {
        DispatchQueue.main.async { [self] in
            getMetroStation()
        }
        
     
    }
    
    func googlemap() {
       
//        let camera = GMSCameraPosition.camera(withLatitude: -33.86, longitude: 151.20, zoom: 6.0)
//        mapView = GMSMapView.map(withFrame: self.view.frame, camera: camera)
//        self.view.addSubview(mapView)
    
//        let marker = GMSMarker()
//        marker.position = CLLocationCoordinate2D(latitude: -33.86, longitude: 151.20)
//        marker.title = "Sydney"
//        marker.snippet = "Australia"
//        marker.map = mapView
        
        self.view.bringSubviewToFront(locationStack)
        self.view.bringSubviewToFront(destinationStack)
        self.view.bringSubviewToFront(scanView)
        self.view.bringSubviewToFront(scanBtn)
        self.view.bringSubviewToFront(metroStationCollectionView)
        self.view.bringSubviewToFront(iconBtn)
        self.view.bringSubviewToFront(locationIcon)
        self.view.bringSubviewToFront(destinationIcon)
        self.view.bringSubviewToFront(gpsButton)
        self.view.bringSubviewToFront(destinationButton)
        
        self.view.bringSubviewToFront(rideDetailsView)
        self.view.bringSubviewToFront(startRiewView)
        self.view.bringSubviewToFront(startRideView)
        self.view.bringSubviewToFront(endRideView)
        self.view.bringSubviewToFront(dropDownTableView)
    }
    
    func addPageControl() {
        self.view.addSubview(pageControl)
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        pageControl.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0.0).isActive = true
        pageControl.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0.0).isActive = true
        pageControl.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0.0).isActive = true
        pageControl.heightAnchor.constraint(equalToConstant: 50).isActive = true
        pageControl.isHidden = true
        pageControl.backgroundColor = UIColor.clear
        pageControl.numberOfPages = 5
        pageControl.currentPage = 0
        pageControl.pageIndicatorTintColor = .clear
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView,indexPath:IndexPath) {
        pageControl.currentPage = Int(scrollView.contentOffset.x) / Int(scrollView.frame.width)
    }
    
    func scrollViewDidScroll(indexPath: IndexPath) {
        var selectedCell = indexPath.item
        
        if (selectedCell == indexPath.item) {
            
            let camera = GMSCameraPosition.camera(withLatitude: stationLatitude[indexPath.row], longitude: stationLongitude[indexPath.row], zoom: 18)
            mapView = GMSMapView.map(withFrame: self.view.frame, camera: camera)
            self.view.addSubview(mapView)
            
            let marker = GMSMarker()
            marker.position = CLLocationCoordinate2D(latitude: stationLatitude[indexPath.row], longitude: stationLongitude[indexPath.row])
            print(marker.position.latitude)
            print(marker.position.longitude)
            marker.map = mapView
            
            DispatchQueue.main.async { [self] in
                self.googlemap()
            }
        }
}
    
    func sidemenuCustomView() {
        self.navigationController?.navigationBar.isTranslucent = false
        let Menu = storyboard?.instantiateViewController(withIdentifier: "LeftMenuNavigationController") as? SideMenuNavigationController
        Menu?.leftSide = true
        Menu?.settings = makeSettings()
        SideMenuManager.default.leftMenuNavigationController = Menu
        SideMenuManager.default.addPanGestureToPresent(toView: view)
        SideMenuManager.default.addScreenEdgePanGesturesToPresent(toView: view)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let sideMenuNavigationController = segue.destination as? SideMenuNavigationController else { return }
        sideMenuNavigationController.leftSide = true
        sideMenuNavigationController.settings = makeSettings()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            DispatchQueue.main.async { [self] in
            self.stationaddress.count
        }
        return stationaddress.count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            let cell = metroStationCollectionView.dequeueReusableCell(withReuseIdentifier:"metrostation" , for: indexPath) as! MetroStationCollectionViewCell
            for i in 0 ..< stationaddress.count{
                DispatchQueue.main.async { [self] in
                    cell.joggersLabel.text = stationaddress[indexPath.row]
                }
            }
            cell.layer.cornerRadius = 10
            cell.nearestMeme.layer.cornerRadius = 10
            return cell
        
    }

   func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    
    print("selected cell \(indexPath.item)")
    
    /* start ride view in future it will be added*/
    //  scanView.isHidden = true
    // metroStationCollectionView.isHidden = true
    //startRideScreen()
    //rideDetailsView.isHidden = false
    //  startRiewView.isHidden = false
    
    var selectedItem = stationaddress[indexPath.row]
    locationTxt.text = selectedItem
    
    
    var selectedCell = indexPath.item
    
  
    if (selectedCell == indexPath.item) {
        let camera = GMSCameraPosition.camera(withLatitude: stationLatitude[indexPath.row], longitude: stationLongitude[indexPath.row], zoom: 18)
        mapView = GMSMapView.map(withFrame: self.view.frame, camera: camera)
        self.view.addSubview(mapView)
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: stationLatitude[indexPath.row], longitude: stationLongitude[indexPath.row])
        print(marker.position.latitude)
        print(marker.position.longitude)
        marker.map = mapView
        
        DispatchQueue.main.async { [self] in
            self.googlemap()
        }
      }
    
   }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: metroStationCollectionView.frame.size.width - 15, height:metroStationCollectionView.frame.size.height)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets.init(top: 8, left: 8, bottom: 8, right: 8)
    }
    
    @IBAction func startRide(_ sender: UIButton) {
        
        rideDetailsView.isHidden = true
        startRideView.isHidden = false
        pauseRideScreen()
        startRide.text = "PAUSE RIDE"
    }
    
    
    @IBAction func startImage(_ sender: UIButton) {
        
        if (startImage.tag == 0) {
            rideDetailsView.isHidden = true
            startRideView.isHidden = false
            pauseRideScreen()
            startRide.text = "PAUSE RIDE"
            startImage.tag = startImage.tag + 1
        }
    
        else if (startImage.tag == 1) {
            startRide.text = "RESUME RIDE"
            yourRideHasStarted.text = "Your Ride is Paused"
            let originalImage  = UIImage(named: "end-1")
            startImage.setImage(originalImage, for: .normal)
            startImage.tintColor = UIColor(rgb: 0x00A7FC)
            timeElapsedStackView.isHidden = false
            timerLabel.text = "00:44"
            startImage.tag = startImage.tag + 1
        }
        
        else if (startImage.tag == 2){
            startRideView.isHidden = true
            endRideView.isHidden = false
            endRideView.layer.cornerRadius = 10
            pleaseParkRide.layer.borderColor = UIColor(rgb: 0x00A7FC).cgColor
            lineView.layer.borderColor = UIColor(rgb: 0x00A7FC).cgColor
            pleaseParkRide.layer.borderWidth = 1.0
            startRide.isHidden = true
            startImage.isHidden = true
            startImageView.isHidden = true
            payButton.isHidden = false
            rupeeButton.isHidden = false
            lineView.layer.borderWidth = 2.0
        }
    }
    
    
    private func makeSettings() -> SideMenuSettings {
        let presentationStyle = SideMenuPresentationStyle.menuSlideIn
        presentationStyle.backgroundColor = .gray
        presentationStyle.presentingEndAlpha = 0.5
        var settings = SideMenuSettings()
        settings.presentationStyle = presentationStyle
        return settings
    }
    
    func textPlacholderColor() {
        locationTxt.attributedPlaceholder = NSAttributedString(string: "Enter your location ",attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray])
        locationStack.layer.cornerRadius = 20
        destinationStack.layer.cornerRadius = 20
        locationTxt.layer.cornerRadius = 10
        destinationTxt.layer.cornerRadius = 10
        destinationTxt.attributedPlaceholder = NSAttributedString(string: "Enter your Destination",attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray])
        scanView.layer.cornerRadius = 10
        locationIcon.layer.cornerRadius = 10
        destinationIcon.layer.cornerRadius = 10
    }
    
    func menuSettings() -> SideMenuSettings {
        let menu = storyboard!.instantiateViewController(withIdentifier: "LeftMenuNavigationController") as! SideMenuNavigationController
        menu.leftSide = true
        menu.settings = SideMenuSettings()
        var set = SideMenuSettings()
        set.presentationStyle = SideMenuPresentationStyle.menuSlideIn
        set.presentationStyle.presentingEndAlpha = 0.5
        var settings = SideMenuSettings()
        set.menuWidth = max(view.frame.width , view.frame.height)
        menu.settings = set
        SideMenuManager.default.leftMenuNavigationController = menu
        return settings
    }
    
    @IBAction func toggleButtonTapped(_ sender: UIBarButtonItem) {
        SideMenuManager.default.leftMenuNavigationController = storyboard?.instantiateViewController(withIdentifier: "LeftMenuNavigationController") as? SideMenuNavigationController
        var sideMenuSet = SideMenuSettings()
        sideMenuSet.presentationStyle = SideMenuPresentationStyle.viewSlideOutMenuOut
        SideMenuManager.default.menuPresentMode = .menuSlideIn
        sideMenuSet.menuWidth = UIScreen.main.bounds.width * 0.8
        let viewMenuBack : UIView = view.subviews.last!
        SideMenuManager.default.addPanGestureToPresent(toView: navigationController!.navigationBar)
        SideMenuManager.default.addScreenEdgePanGesturesToPresent(toView: view)
    }
    
    
    func getMetroStation() {
        
        let headers : HTTPHeaders = [
                "Authorization": "Bearer MEMESECRATELOGIN2001",
                "Content-Type": "application/json"
            ]
        
        let url = "https://api.memebike.tv:2001/api/stations"
        AF.request(url, method: .get,encoding: JSONEncoding.default, headers: headers)
            .responseJSON { [self] response in
                switch response.result {
                case .success(let data):
                //print("isi: \(data)")
                let json = JSON(data)
                    let stationsData = json["stations"].arrayValue
                     for stationData in stationsData {
                        if let fetchedAddress = stationData["name"].string {
                            stationaddress.append(fetchedAddress)
                            DispatchQueue.main.async {
                                metroStationCollectionView.reloadData()
                                ProgressHUD.dismiss()
                                dropDownTableView.reloadData()
                                
                            }
                        }
                        
                        if let fetchedLatitiude = stationData["latitude"].double {
                            stationLatitude.append(fetchedLatitiude)
                            print("0",stationLatitude)
                            
                            if let fetchedLongitude = stationData["longitude"].double {
                                stationLongitude.append(fetchedLongitude)
                                
                                let camera = GMSCameraPosition.camera(withLatitude: stationLatitude[0], longitude: stationLongitude[0], zoom: 18)
                             mapView = GMSMapView.map(withFrame: self.view.frame, camera: camera)
                             self.view.addSubview(mapView)
                    
                                let marker = GMSMarker()
                                marker.position = CLLocationCoordinate2D(latitude: stationLatitude[0], longitude: stationLongitude[0])
                                marker.map = mapView
                                
                                DispatchQueue.main.async {
                                    googlemap()
                                }
                           }
                        }
                    }
               
                case .failure(let error):
                    print("Request failed with error: \(error)")
                }
            }
        }
    
    
}

extension UIView {
   func roundCorners(corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
    }
}


