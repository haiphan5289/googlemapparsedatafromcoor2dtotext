//
//  ViewController.swift
//  googlemapagain
//
//  Created by HaiPhan on 5/29/19.
//  Copyright © 2019 HaiPhan. All rights reserved.
//

import UIKit
import GooglePlaces
import GoogleMaps

//Key lấy từ dev google sdk
var google_api_key = "AIzaSyBDLBpnBwc1JqWyThVSp7XOgjILXpyAjCw"

class ViewController: UIViewController {


    @IBOutlet weak var btxacnhan: UIButton!
    @IBOutlet weak var lblhienthi: UILabel!
    //drag uiview
    //chọn view thuộc tính: GMSMapview
    //Drag qua
    @IBOutlet weak var mapView: GMSMapView!
    //khởi tạo sau khi extension CLLocation2d
    var locationmanage = CLLocationManager()
    //tạo 1 biến marker
    var marker = GMSMarker()
    //tạo cờ để bật btxacnhac
    var dem = 1
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        autolayoutmapview()
        
        //setup to get my current location
        locationmanage.delegate = self
        locationmanage.requestWhenInUseAuthorization()
        locationmanage.desiredAccuracy = kCLLocationAccuracyBest
        locationmanage.startUpdatingLocation()
        
        //setup để parse data từ lat long >>> text
        mapView.delegate = self
        lblhienthi.backgroundColor = .gray
        btxacnhan.backgroundColor = .gray
    }
    
    //Chuyển dữ liệu về screen1
    @IBAction func passdata(_ sender: UIButton) {
        let screen1 = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "view1") as! view1
        screen1.texttitle = "111"
        screen1.textlat = "2"
        screen1.textlong = "3"
        self.present(screen1, animated: true, completion: nil)
    }
    
    //marker sẽ di chuyển theo map
    func mapView(_ mapView: GMSMapView, didChange position: GMSCameraPosition) {
        var destinationLocation = CLLocation()
        destinationLocation = CLLocation(latitude: position.target.latitude,  longitude: position.target.longitude)
        createmarrker(location: destinationLocation.coordinate)
//        createmarrker(location: position.target)
    }
    //parse data tưd coor2d >>> text
    private func reverseGeocodeCoordinate(_ coordinate: CLLocationCoordinate2D){
        let geocode = GMSGeocoder()
        geocode.reverseGeocodeCoordinate(coordinate) { (res, err) in
            if err != nil {
                print(err?.localizedDescription ?? "hihi")
            }
            guard let adđress = res?.firstResult(), let line = adđress.lines else {
                return
            }
            //truyền giái trị vào lbl
            //Chuyển [String] >>> String
            self.lblhienthi.text = line.joined(separator: "\n")
            self.dem += 1
            if self.dem > 2 {
                self.btxacnhan.isEnabled = true
            }
            else {
                self.btxacnhan.isEnabled = false
            }
            print(self.dem)
            //khở tại button marker
            self.createmarrker(location: adđress.coordinate)
            //animation
            UIView.animate(withDuration: 0.5, animations: {
                let labelheight = self.lblhienthi.intrinsicContentSize.height
                self.mapView.padding = UIEdgeInsets(top: self.view.safeAreaInsets.top, left: 0,
                                                    bottom: labelheight, right: 0)
                self.view.layoutIfNeeded()
            })
        }
        
    }
    //create marker & thuộc tính
    func createmarrker(location: CLLocationCoordinate2D){
        if marker == nil {
            let marker = GMSMarker()
            marker.position = location
            marker.icon = UIImage(named: "place-marker.png")
            marker.appearAnimation = GMSMarkerAnimation.pop
            marker.map = self.mapView
            
        }
        else{
            //Animation khi move marker
            CATransaction.begin()
            CATransaction.animationDuration()
            marker.position = location
            marker.icon = UIImage(named: "place-marker.png")
            marker.appearAnimation = GMSMarkerAnimation.pop
            marker.map = self.mapView
            CATransaction.commit()
        }
    }
    
    //Khởi tạo layout
    func autolayoutmapview(){
        mapView.translatesAutoresizingMaskIntoConstraints = false
        lblhienthi.translatesAutoresizingMaskIntoConstraints = false
        btxacnhan.translatesAutoresizingMaskIntoConstraints = false
        btxacnhan.isEnabled = false
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[v0]|", options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: ["v0":mapView]))
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[v0]|", options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: ["v0":mapView]))
        aulayout1contraints(text: "V:|-60-[v0(60)]", Object: lblhienthi)
        aulayout1contraints(text: "H:|[v0]|", Object: lblhienthi)
        aulayout1contraints(text: "V:[v0(60)]|", Object: btxacnhan)
        aulayout1contraints(text: "H:|[v0]|", Object: btxacnhan)
        
    }
    func aulayout1contraints(text: String, Object: AnyObject){
                view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: text, options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: ["v0":Object]))
    }

}
extension ViewController: CLLocationManagerDelegate {
    //Get my current location
    // 2 hàm này đi chung với nhay
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        guard status == .authorizedWhenInUse else {
            return
        }
        locationmanage.startUpdatingLocation()
        mapView.isMyLocationEnabled = true
        mapView.settings.myLocationButton = true
    }
    //update location
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else {
            return
        }
        mapView.camera = GMSCameraPosition(target: location.coordinate, zoom: 16, bearing: 0, viewingAngle: 0)
        locationmanage.stopUpdatingLocation()
    }
}
extension ViewController: GMSMapViewDelegate{
    //khơi tạo cùng lúc với reverseGeocodeCoordinate , để hàm reverseGeocodeCoordinate có thể work
    func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {
        reverseGeocodeCoordinate(position.target)
    }
}

