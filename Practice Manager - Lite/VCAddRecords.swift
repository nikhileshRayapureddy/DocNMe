//
// Created by Sandeep Rana on 05/10/17.
// Copyright (c) 2017 DocNMe. All rights reserved.
//

import Foundation
import UIKit
import Dropper
import DatePickerDialog
import Alamofire
import AlamofireObjectMapper
import Toaster
import RealmSwift
import Photos

class VCAddRecords: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.arrOfImages.count;
    }
    
    

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: CellImageCollectionViewCellTestResults = collectionView.dequeueReusableCell(withReuseIdentifier: Names.VContIdentifiers.CELL_IMAGE, for: indexPath) as! CellImageCollectionViewCellTestResults;
        cell.iImage.contentMode = .scaleAspectFit;
        cell.iImage.image = self.arrOfImages[indexPath.row];
    
        cell.bRemoveImage.tag = indexPath.row;
        cell.bRemoveImage.addTarget(self, action: #selector(self.onRemoveButtonClicked(_:)), for: .touchUpInside)
        return cell;
    }

    func onRemoveButtonClicked(_ sender: UIButton) {
        self.arrOfImages.remove(at: sender.tag);
        self.collectionView.reloadData();
    }


    var personInfo: PersonInfoModel?;

    private var dropper: Dropper?;

    @IBOutlet weak var eDoctor: UITextField!;
    @IBOutlet weak var eIssuer: UITextField!;
    @IBOutlet weak var eNote: UITextField!;
    @IBOutlet weak var bRecordDate: UIButton!;
    @IBOutlet weak var nothing: UIButton!;
    @IBOutlet weak var lReportType: UILabel!;
    @IBOutlet weak var collectionView: UICollectionView!;


    let dictRecordType = [
        "Diagnostic Reports": "diagnostic_reports",
        "Doctor Notes": "doctor_notes",
        "Doctor Visit": "doctor_visit",
        "Hospitalization": "hospitalization",
        "Imaging": "imaging",
        "Prescription": "prescription",
        "Procedure": "procedure"
    ]

    var dateFormatter: DateFormatter?;

    public var onRecordAddedDelegate: OnRecordAddedDelegate?;

    private let realm = try? Realm();
    @IBOutlet weak var scrollView: UIScrollView!

    var arrOfImages = [UIImage]();

    func onTouchScrollView(_ gesture: UITapGestureRecognizer) {
        Utility.hideDropper(self.dropper);
    }


    override func viewDidLoad() {
        super.viewDidLoad()

        let recogN = UITapGestureRecognizer(target: self, action: #selector(onTouchScrollView(_:)));
        recogN.cancelsTouchesInView = false;
        scrollView.addGestureRecognizer(recogN);


        self.dateFormatter = Utility.getDateFormatter(dateFormat: "dd/MM/yyyy")
        self.collectionView.delegate = self;
        self.collectionView.dataSource = self;

//        self.automaticallyAdjustsScrollViewInsets = false;
        checkPermission()
    }

    func checkPermission() {
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
    }
    @IBAction func onClickAddRecordButton(_ sender: UIButton) {
        
        if (self.bRecordDate.titleLabel?.text! == "Date"){
            Toast(text: "Please select a date").show();
            return;
        }
        
        if ((self.eDoctor.text?.characters.count)! < 1){
            Toast(text:"Doctor Name is mandatory").show();
            return;
        }
        
        if ((self.eIssuer.text?.characters.count)! < 1){
            Toast(text:"Issuer Name is mandatory").show();
            return;
        }
        
        
        let recordType = dictRecordType[self.lReportType.text!];
//        var params = [String: Any]();

        let dirId = Date().millisecondsSince1970.description;
        
        let record = Record();
        record.id = nil;
        record.parentId = nil;
        record.doctorName = self.eDoctor.text;
        record.issuerName = self.eIssuer.text;
        record.personId = self.personInfo?.id;
        record.name = self.personInfo?.name;
        record.type = self.lReportType.text;
//        record.isdirectory = false;
//        record.uploadtime = Date(millisecon);
        record.dateofissue = (self.dateFormatter?.date(from: (self.bRecordDate.titleLabel?.text)!)?.millisecondsSince1970)!;
        record.visitId = nil;
        record.notes = self.eNote.text;
        record.mimetype = nil;
        record.language = nil;
//        record.keywords = nil;
        record.personPregnancyProfileId = nil;
        record.directoryId = dirId;
        record.isUpdated = true;

        try? realm?.write({
            realm?.add(record);
        });
        
        for itemImage in self.arrOfImages {
            
            let recordImage = Record();
            recordImage.id = nil;
            recordImage.parentId = nil;
            recordImage.doctorName = self.eDoctor.text;
            recordImage.issuerName = self.eIssuer.text;
            recordImage.personId = self.personInfo?.id;
            recordImage.name = self.personInfo?.name;
            recordImage.type = self.lReportType.text;
            //        recordImage.isdirectory = false;
            //        recordImage.uploadtime = Date(millisecon);
            recordImage.dateofissue = record.dateofissue;
            recordImage.visitId = nil;
            recordImage.notes = self.eNote.text;
            recordImage.mimetype = "image/*";
            recordImage.language = nil;


            let imageData:Data =  UIImagePNGRepresentation(itemImage)!
            let base64String = imageData.base64EncodedString()

            recordImage.content = base64String;
            //        recordImage.keywords = nil;
            recordImage.personPregnancyProfileId = nil;
            recordImage.directoryId = dirId;
            recordImage.isUpdated = true;
            
            try? realm?.write({
                realm?.add(recordImage);
            });

        }


        if (self.onRecordAddedDelegate != nil) {
            self.onRecordAddedDelegate?.onRecordAdded([record]);
        }
        self.navigationController?.popViewController(animated: true);
        Toast(text: "🙂 Record added successfully!").show();


//        let arrObj = [record.toJSON()];
//
//        let url = DAMUrls.urlAddRecord();
//
//        let request = ApiServices.createPostRequest(urlStr: url, parameters: arrObj);
//
//        sender.isEnabled = false;
//        sender.setTitle("addding...", for: .normal);
//
//        (request).responseArray {
//            (response: DataResponse<[Record]>) in
//
//            sender.isEnabled = true;
//            sender.setTitle("ADD", for: .normal);
//
//            if (response.response?.statusCode == 200) {
//                if (self.onRecordAddedDelegate != nil) {
//                    self.onRecordAddedDelegate?.onRecordAdded(response.result.value!);
//                }
//                self.navigationController?.popViewController(animated: true);
//                Toast(text: "🙂 Record added successfully!").show();
//            } else {
//                Toast(text: "☹️ Something went wrong. Record add failed!").show();
//            }
//        }

//        "content"


    }

    @IBAction func onClickAddPhoto(_ sender: UIButton) {
        let imageController: UIImagePickerController = UIImagePickerController();
        imageController.modalPresentationStyle = .overCurrentContext;
        imageController.sourceType = .photoLibrary;
        imageController.allowsEditing = false;
        imageController.delegate = self;
        self.present(imageController, animated: true, completion: nil);

    }

    @IBAction func onClickAddCamera(_ sender: UIButton) {

        let imageController: UIImagePickerController = UIImagePickerController();
        imageController.modalPresentationStyle = .overCurrentContext;
        imageController.sourceType = .camera;
        imageController.allowsEditing = false;
        imageController.delegate = self;
        self.present(imageController, animated: true, completion: nil);

    }

    @IBAction func onClickSelectRecordDate(_ sender: UIButton) {
        DatePickerDialog().show("Date", doneButtonTitle: "Done", cancelButtonTitle: "Cancel", defaultDate: Date(), minimumDate: nil, maximumDate: Date(), datePickerMode: .date) {
//        DatePickerDialog().show("Date", doneButtonTitle: "Done", cancelButtonTitle: "Cancel", datePickerMode: .date) {
            (date) -> Void in
            if (date != nil) {
                sender.setTitle(self.dateFormatter?.string(from: date!), for: .normal);
            }
        }
    }

    @IBAction func onClickSelectRecordType(_ sender: UIButton) {
        if (self.dropper != nil) {
            self.dropper?.hide();
            self.dropper = nil;
            return;
        }

        self.dropper = Dropper.init(width: 140, height: 200);
        self.dropper?.items = Array(self.dictRecordType.keys);
        self.dropper?.delegate = self;
        self.dropper?.show(.left, button: nothing);

    }

}

extension VCAddRecords: DropperDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func DropperSelectedRow(_ path: IndexPath, contents: String, tag: Int) {
        self.lReportType.text = contents;
    }


    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {

    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String: Any]) {
//        let image: UIImage = info[UIImagePickerControllerOriginalImage] as! UIImage;
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            let resizedImage = UIImage(data: pickedImage.jpeg(.low)!);
            self.arrOfImages.append(resizedImage!);
            self.collectionView.reloadData();
        }
        
        picker.dismiss(animated: true, completion: nil);
    }
}

extension UIImage {
    enum JPEGQuality: CGFloat {
        case lowest  = 0
        case low     = 0.25
        case medium  = 0.5
        case high    = 0.75
        case highest = 1
    }
    
    /// Returns the data for the specified image in JPEG format.
    /// If the image object’s underlying image data has been purged, calling this function forces that data to be reloaded into memory.
    /// - returns: A data object containing the JPEG data, or nil if there was a problem generating the data. This function may return nil if the image has no data or if the underlying CGImageRef contains data in an unsupported bitmap format.
    func jpeg(_ quality: JPEGQuality) -> Data? {
        return UIImageJPEGRepresentation(self, quality.rawValue)
    }
}
