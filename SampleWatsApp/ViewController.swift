//
//  ViewController.swift
//  SampleWatsApp
//
//  Created by Developer on 29/09/17.
//  Copyright © 2017 Developer. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController {
    
    fileprivate let imageArray = ["https://1.img-dpreview.com/files/p/TS600x450~sample_galleries/1681863120/8441359954.jpg","","","","", "https://3.img-dpreview.com/files/p/TS600x450~sample_galleries/1681863120/9705472459.jpg", "https://1.img-dpreview.com/files/p/TS600x450~sample_galleries/1681863120/2872407387.jpg","","","","","https://4.img-dpreview.com/files/p/TS1200x900~sample_galleries/1681863120/1345368158.jpg","https://3.img-dpreview.com/files/p/TS600x450~sample_galleries/1681863120/6861901384.jpg","https://4.img-dpreview.com/files/p/TS600x450~sample_galleries/1681863120/4961500260.jpg","","","","","https://1.img-dpreview.com/files/p/TS600x450~sample_galleries/1681863120/0499670227.jpg","","","","https://2.img-dpreview.com/files/p/TS600x450~sample_galleries/1681863120/4865216366.jpg"]
    
    
    private let context = AppDelegate.shared.getContext()
    private let NewsEntity = "News"
    private var newsArray = [News]()
    
    @IBOutlet private var tableViewList : UITableView!
    
    fileprivate let cellId = "cellId"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        WebService.get(completion: { val in
            
            // print(val.value(forKey: "sources") as? [NSDictionary])
            
            if let dict = val.value(forKey: "sources") as? [NSDictionary] {
                self.store(values: dict)
            }
            
        })
        
    }
    
    
    private func save(){
        
        DispatchQueue.main.async {
            
            do{
                try self.context.save()
                
            }catch let err {
                print("Error::: "+err.localizedDescription)
            }
            
        }
    }
    
    
    
    private func store(values : [NSDictionary]){
        
        print("--->>",values.count)
        
        for val in values {
            
            let entity = NSEntityDescription.insertNewObject(forEntityName: NewsEntity, into: context) as? News
            
            entity?.id = val.value(forKey: "id") as? String
            entity?.name = val.value(forKey: "name") as? String
            entity?.desc = val.value(forKey: "description") as? String
        }
        
        save()
        
        fetchResults()
        
    }
    
    
    
    
    
    @IBAction private func fetchAction(sender : UIButton){
        
        
        
    }
    
    
    fileprivate func fetchResults(){
        
        let fetch = News.fetch()
        
        fetch.fetchOffset = newsArray.count
        fetch.fetchLimit = 5
        
        do {
            
            let arr = try context.fetch(fetch)
            newsArray.append(contentsOf: arr)
            
            
        } catch let err {
            print(err.localizedDescription)
        }
        
        print("Total Count --",newsArray.count)
        
        reload()
        
    }
    
    
    private func reload(){
        
        DispatchQueue.main.async {
            self.tableViewList.reloadData()
        }
        
    }
    
    
}

extension ViewController : UIScrollViewDelegate {
    
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        
         fetchResults()
    }
    
}




extension ViewController : UITableViewDataSource, UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let tableCell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! TableViewCell
        
       /* tableCell.detailTextLabel?.backgroundColor = UIColor.clear
        tableCell.textLabel?.backgroundColor = UIColor.clear
        
        tableCell.detailTextLabel?.text = newsArray[indexPath.row].desc
        tableCell.textLabel?.text = newsArray[indexPath.row].name */
        
        tableCell.imageViewCell.image = #imageLiteral(resourceName: "Preview")
        
        tableCell.labelTitle.text = newsArray[indexPath.row].name
        tableCell.labelDescription.text = newsArray[indexPath.row].desc
        if getHeight(index: indexPath.row) > 0, imageArray.count>indexPath.row {
            
            tableCell.heightContraint.constant = 50
            Cache.get(image: imageArray[indexPath.row], completion: { image in
                
                DispatchQueue.main.async {
                    
                    tableCell.imageViewCell.image = image==nil ? #imageLiteral(resourceName: "Error"):image
                    
                }
                
            })
            
        }
        tableCell.layer.cornerRadius = 10
        return tableCell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return newsArray.count
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
     //   print(tableView.estimatedRowHeight,getHeight(index: indexPath.row), tableView.estimatedRowHeight.advanced(by: getHeight(index: indexPath.row)))
        
        return tableView.estimatedRowHeight
    }
    
    
    private func getHeight(index : Int)->CGFloat{
         return 50//CGFloat(index%2 == 0 ? 50 : 0)
    }
    
    
}


class TableViewCell : UITableViewCell {
    
    @IBOutlet var labelTitle : UILabel!
    @IBOutlet var labelDescription : UILabel!
    @IBOutlet var heightContraint : NSLayoutConstraint!
    @IBOutlet var imageViewCell : UIImageView!
    
}



class Cache {
    
    static let shared = NSCache<AnyObject, UIImage>()
    
    class func get(image : String?, completion : @escaping (UIImage?)->()){
      
        DispatchQueue.global(qos: .utility).async {
            
            var uiImage : UIImage?
            
            guard let imageUrl = image else {
                completion(uiImage)
                return
            }
            
            uiImage = self.shared.object(forKey: imageUrl as AnyObject)
            
            if uiImage == nil, let url = URL(string: imageUrl){
                
                do {
                    
                    let data = try Data(contentsOf: url)
                    uiImage = UIImage(data: data)
                    
                    if uiImage != nil {
                        self.shared.setObject(uiImage!, forKey: imageUrl as AnyObject)
                    }
                    
                    completion(uiImage)
                    
                }catch let err {
                    
                    print(err.localizedDescription)
                    completion(uiImage)
                    return
                }
            }
            
            completion(uiImage)
            
        }
    }
    
    
    
}




