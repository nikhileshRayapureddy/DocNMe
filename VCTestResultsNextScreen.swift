//
// Created by Sandeep Rana on 03/11/17.
// Copyright (c) 2017 DocNMe. All rights reserved.
//

import Foundation
import UIKit
import Photos
import ObjectMapper
import RealmSwift
import Toaster
import Toaster
import AlamofireObjectMapper
import Alamofire


class VCTestResultsNextScreen: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UICollectionViewDelegate, UICollectionViewDataSource {


    var personInfo: PersonInfoModel?;
    @IBOutlet weak var tIssuedBy: UITextField!;
    @IBOutlet weak var tDoctor: UITextField!;
    @IBOutlet weak var bSave: UIButton!;
    @IBOutlet weak var collectionView: UICollectionView!;
    let picker = UIImagePickerController();


//    private let dateFormatter = Utility

    var date: Date?;

    var onRecordAddedDelegate: OnRecordAddedDelegate?;

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.arrOfImages.count;
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: CellImageCollectionViewCellTestResults = collectionView.dequeueReusableCell(withReuseIdentifier: Names.VContIdentifiers.CELL_IMAGE, for: indexPath) as! CellImageCollectionViewCellTestResults;
        cell.iImage.image = self.arrOfImages[indexPath.row];
        cell.bRemoveImage.tag = indexPath.row;
        cell.bRemoveImage.addTarget(self, action: #selector(self.onRemoveButtonClicked(_:)), for: .touchUpInside)
        return cell;
    }


    func onRemoveButtonClicked(_ sender: UIButton) {
        self.arrOfImages.remove(at: sender.tag);
        self.collectionView.reloadData();
    }

    let realm = try? Realm();

    @IBAction func onClickAddRecordButton(_ sender: UIButton) {

        if (self.tIssuedBy.text?.isEmpty)! {
            Toast(text: "Field Issued id mandatory!").show();
            return;
        }

        if (self.tDoctor.text?.isEmpty)! {
            Toast(text: "Field Doctor is Mandatory!").show();
            return;
        }


        let record = Record();
        record.id = nil;
        record.parentId = nil;
        record.doctorName = self.tDoctor.text;
        record.issuerName = self.tIssuedBy.text;
        record.personId = self.personInfo?.id;
        record.name = self.personInfo?.name;
        record.type = "diagnostic_reports";
//        record.isdirectory = false;
//        record.uploadtime = Date(millisecon);
        record.dateofissue = (date?.millisecondsSince1970)!;
        record.visitId = nil;
        record.notes = "";
        record.mimetype = nil;
//        let strResults = Mapper().toJSONString(self.arrOfResults);

//        record.resultsString = strResults;
        record.language = nil;
//        record.keywords = nil;
        record.personPregnancyProfileId = nil;
        record.directoryId = Date().millisecondsSince1970.description;
        record.isUpdated = false;


        self.apiCallAddRecords(record, arrOfResults);


    }

    var arrOfImages = [UIImage]();

    private func apiCallAddRecords(_ record: Record, _ results: [Result]) {
        var arrOfObjects = [[String: Any]]();
        arrOfObjects.append(record.toJSONForBatchrequest());
        let requestUpdateBasicInfo = ApiServices.createPostRequest(urlStr:
        DAMUrls.urlAddRecord(), parameters: arrOfObjects);
        AlamofireManager.Manager.request(requestUpdateBasicInfo).responseArray {
//                response in
//                print(response.result.value ?? ":");
            (response: DataResponse<[Record]>) in
//                print(response.result.value)
            if response.response?.statusCode == 200 {
                if response.result.value != nil {
                    if let arr = response.result.value {
//                        saveRecords(arr);
                        if arr.count > 0 {
                            try? self.realm?.write({
                                self.realm?.add(arr[0]);
                                self.apiAddResults(arr[0]);
                            });

                        }

                    }
                }
            } else {
                print("Some Error Occured allergies");
                print(response.result.error?.localizedDescription);
            }

        };
    }

    private func apiAddResults(_ v: Record) {

        for item in arrOfResults {
            item.filedetailId = (v.id!);
            let requestUpdateBasicInfo = ApiServices.createPostRequest(urlStr:
            DAMUrls.urlAddRecord(), parameters: item.toJSON());
            AlamofireManager.Manager.request(requestUpdateBasicInfo).responseString {
                (response) in
                if response.result.isSuccess {
                    print(response.result.value)
                    try? self.realm?.write({
                        self.realm?.add(item);
                    });
                }
                
            }
        }


        if (self.onRecordAddedDelegate != nil) {
            self.onRecordAddedDelegate?.onRecordAdded([v]);
        }

        self.navigationController?.viewControllers.removeLast(2);
//        self.navigationController?.popViewController(animated: true);
        Toast(text: "🙂 Added successfully!").show();

    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String: Any]) {

        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            self.arrOfImages.append(pickedImage);
            self.collectionView.reloadData();
        }

        picker.dismiss(animated: true, completion: nil);
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil);
    }

    var arrOfResults = [Result]();

    @IBAction func onClickSelectImages(_ sender: UIButton) {
        picker.delegate = self;
        if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum) {
            print("Button capture")
            picker.sourceType = .savedPhotosAlbum;
            picker.allowsEditing = false
            picker.modalPresentationStyle = .overCurrentContext;
            self.present(picker, animated: true, completion: nil);

//            self.addChildViewController(picker)
//            picker.didMove(toParentViewController: self)
//            self.view!.addSubview(picker.view!)
        }
    }


    override func viewDidLoad() {
        super.viewDidLoad();
        let photoAuthorizationStatus = PHPhotoLibrary.authorizationStatus()
        switch photoAuthorizationStatus {
        case .authorized:
            print("Access is granted by user")
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization({
                (newStatus) in
                print("status is \(newStatus)")
                if newStatus == PHAuthorizationStatus.authorized {
                    /* do stuff here */
                    print("success")
                }
            })
            print("It is not determined until now")
        case .restricted:
            // same same
            print("User do not have access to photo album.")
        case .denied:
            // same same
            print("User has denied the permission.")
        }

        self.collectionView.delegate = self;
        self.collectionView.dataSource = self;
    }
}
