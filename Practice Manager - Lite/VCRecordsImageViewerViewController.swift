//
//  VCRecordsImageViewerViewController.swift
//  Practice Manager - Lite
//
//  Created by Sandeep Rana on 05/09/17.
//  Copyright © 2017 DocNMe. All rights reserved.
//

import UIKit
import AlamofireImage
import AlamofireObjectMapper
import Alamofire
import SKPhotoBrowser

class VCRecordsImageViewerViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    var urlArray: [Record]?;
    @IBOutlet weak var collectionView: UICollectionView!

    let photoCache = AutoPurgingImageCache(
            memoryCapacity: 100 * 1024 * 1024,
            preferredMemoryUsageAfterPurge: 60 * 1024 * 1024
    )

    override func viewDidLoad() {
        super.viewDidLoad()
        for object in self.urlArray!
        {
            if object.directoryId?.characters.count == 13 && object.content == nil{
                urlArray?.remove(at: (urlArray?.index(of: object))!)
            }
        }
        
        collectionView.delegate = self;
        collectionView.dataSource = self;
        
        
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (urlArray?.count)!;
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let record: Record = (urlArray?[indexPath.row])!;

        let cell: CellImageCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: Names.VContIdentifiers.CELL_IMAGE, for: indexPath) as! CellImageCollectionViewCell;


        if record.directoryId!.characters.count == 13 {
            let dataDecode:NSData = NSData(base64Encoded: record.content!, options: .ignoreUnknownCharacters)!;
            let decodedimage: UIImage = UIImage(data: dataDecode as Data)!

            cell.iImage?.image = decodedimage;
        } else {

            let request = ApiServices.createGetRequest(urlStr: (DAMUrls.urlForImage(imageID: record.id!)), parameters: []);
            if let image = photoCache.image(withIdentifier: record.id!) {
                cell.iImage?.image = image;
            } else {
                AlamofireManager.Manager.request(request).responseImage { response in
                    debugPrint(response)


                    debugPrint(response.result)

                    if let image = response.result.value {
                        cell.iImage?.image = image;
                        self.photoCache.add(image, withIdentifier: record.id!);
                    }
                }
            }
        }

        return cell;
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        var images = [SKPhoto]()

        let cell: CellImageCollectionViewCell = collectionView.cellForItem(at: indexPath) as! CellImageCollectionViewCell;
        if let image = cell.iImage?.image {
            let photo = SKPhoto.photoWithImage((image))// add some UIImage
            images.append(photo)

            // 2. create PhotoBrowser Instance, and present from your viewController.
            let browser = SKPhotoBrowser(photos: images)
            browser.initializePageIndex(0)
            present(browser, animated: true, completion: {})
        }
    }


}
