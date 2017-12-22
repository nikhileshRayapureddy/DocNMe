//
//  VCDoctorsListofClinic.swift
//  Practice Manager - Lite
//
//  Created by Sandeep Rana on 18/08/17.
//  Copyright © 2017 DocNMe. All rights reserved.
//

import Foundation
import Alamofire;

import AlamofireObjectMapper
import InitialsImageView
import UIKit
import RealmSwift
import SwiftHEXColors

class VCDoctorsListofClinicCollectionView: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate,UICollectionViewDelegateFlowLayout {
    var dataListDoctors = [DoctorModel]();

    var onDoctorClickedDelegate: OnDoctorClickedDelegate?;
    let realm = try? Realm()
    @IBOutlet weak var collectionView: UICollectionView!

//    @IBOutlet weak var indicator: UIActivityIndicatorView!

    private var colorCircle: UIColor?;

    override func viewDidLoad() {
        super.viewDidLoad();

        colorCircle = UIColor(hexString: "#01715C")
        self.getDoctorsListAndShow();
        self.collectionView.dataSource = self;
        self.collectionView.delegate = self;
        if (UserPrefUtil.getClinicResponse() != nil) {
            self.title = "Doctors | " + (UserPrefUtil.getClinicResponse()?.clinic?.name!)!;
        }
    }
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        if UIDevice.current.orientation.isLandscape {
            print("Landscape")
        } else {
            print("Portrait")
        }
        self.collectionView.reloadData()
        app_delegate.reloadLoader()
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataListDoctors.count;
    }

    @IBOutlet weak var indicator: UIActivityIndicatorView!

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cellIdentifier: String = Names.VContIdentifiers.CELL_DOCTORSLISTCOLLECTIONVIEW;
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! DoctorCollectionViewCell

        let doctor: DoctorModel = dataListDoctors[indexPath.row];
        cell.dName.text = doctor.name;
        cell.dEmail.text = doctor.email;
        cell.dMobile.text = doctor.phonenumber;
        if (doctor.name != nil) {
            cell.iImage.setImageForName(string: doctor.name, backgroundColor: self.colorCircle, circular: true,

                    textAttributes: [NSForegroundColorAttributeName: UIColor.white]);
        }
        return cell;
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        collectionView.deselectRow(at: indexPath, animated: false);
//        self.navigationController?.popViewController(animated: false);
        if (onDoctorClickedDelegate != nil) {
            onDoctorClickedDelegate?.onClickDoctor(doctor: dataListDoctors[indexPath.row]);
        }
    }
  func collectionView(_ collectionView: UICollectionView,
                             layout collectionViewLayout: UICollectionViewLayout,
                             sizeForItemAt indexPath: IndexPath) -> CGSize
  {
    print("UIScreen.main.bounds.width  : \(UIScreen.main.bounds.width )")
    if(UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.pad)
    {
        return CGSize(width: (UIScreen.main.bounds.width - 76 - 20)/2, height: 144)
    }
    else
    {
        return CGSize(width: (UIScreen.main.bounds.width - 76 - 10), height: 144)
    }
    
    }


    private func getDoctorsListAndShow() {
        app_delegate.showLoader(message: "Fetching Details...")

        let dataObjects = self.realm?.objects(DoctorModel.self);
        if (dataObjects != nil) {
            for item in dataObjects! {
                let docMod = DoctorModel();
                docMod.setFields(item);
                self.dataListDoctors.append(docMod);

            }
            self.collectionView.reloadData();
        }

        let urlRequest = ApiServices.createGetRequest(urlStr: DAMUrls.urlDoctorsList(), parameters: []);
        AlamofireManager.Manager.request(urlRequest).responseArray {
            (response: DataResponse<[DoctorModel]>) in
            DispatchQueue.main.async {
                app_delegate.removeloder()
                if (response.response?.statusCode == 200) {
                    self.dataListDoctors.removeAll();
                    self.dataListDoctors.append(contentsOf: response.result.value!);
                    self.collectionView.reloadData();
                    self.writeToDatabase(response.result.value);
                }
            }
        }
    }

    private func writeToDatabase(_ value: [DoctorModel]?) {
        if let objects = value {
            try! realm?.write {
                let result = realm?.objects(DoctorModel.self);
                realm?.delete(result!)

                realm?.add(objects);
            };
        }
    }
}
