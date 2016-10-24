//
//  WOFTableViewController.swift
//  WalkOfFame
//
//  Created by Jason Gresh on 10/18/16.
//  Copyright © 2016 C4Q. All rights reserved.
//

import UIKit

class WOFTableViewController: UITableViewController {
    var walks = [Walk]()
    
    internal let walkJSONFileName: String = "walk_of_fame.json"
    internal let walkEndpoint: String = "https://data.cityofnewyork.us/resource/btth-hrxi.json"

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let resourceURL = getResourceURL(from: "walk_of_fame", withExt: "json"),
        let data = getData(from: resourceURL),
            let walks = getWalks(from: data) {
            self.walks = walks
        }
        
        getWalks(apiEndpoint: walkEndpoint){ (returnedWalks: [Walk]?) in
            if let newreturnedWalks = returnedWalks {
                self.walks = newreturnedWalks
               }
           DispatchQueue.main.sync {
               self.tableView.reloadData()
                }
        }
    }

    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func getWalks(apiEndpoint: String, callback: @escaping ([Walk]?) -> Void) {
        
        if let validWalkEndpoint: URL = URL(string: apiEndpoint) {
            
            // 1. URLSession/Configuration
            let session = URLSession(configuration: URLSessionConfiguration.default)
            
            // 2. dataTaskWithURL
            session.dataTask(with: validWalkEndpoint) { (data: Data?, response: URLResponse?, error: Error?) in
                
                // 3. check for errors right away
                if error != nil {
                    print("Error encountered!: \(error!)")
                }
                
                // 4. printing out the data
                if let validData: Data = data {
                    print(validData) // not of much use other than to tell us that data does exist
                    
                    if let allWalks: [Walk] = self.getWalks(from: validData) {
                        print(allWalks)
                        callback(allWalks)
                    }
                }
            }.resume()
        }
    }



    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return walks.count
    }
    
    
     override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
     let cell = tableView.dequeueReusableCell(withIdentifier: "WOFcell", for: indexPath)
     
     // Configure the cell...
        cell.textLabel?.text = walks[indexPath.row].designer
        cell.detailTextLabel?.text = walks[indexPath.row].location
     
     return cell
     }
    
    
    internal func getResourceURL(from fileName: String, withExt ext: String) -> URL? {
        let fileURL: URL? = Bundle.main.url(forResource: fileName, withExtension: ext)
        
        return fileURL
    }
    
    internal func getData(from url: URL) -> Data? {
        let fileData: Data? = try? Data(contentsOf: url)
        return fileData
    }
    
    internal func getWalks(from jsonData: Data) -> [Walk]? {
        // replace this return with a full implementation
        do {
        let walkJSONData: Any = try? JSONSerialization.jsonObject(with: jsonData, options: [])
        
//            guard let walkJSONCasted: [String : AnyObject] = walkJSONData as? [String : AnyObject],
//                let walkArray: [AnyObject] = walkJSONCasted["cats"] as? [AnyObject] else {
//                    return nil
//            }
            
            if let walkDict = walkJSONData as? [String:Any] {
                if let data = walkDict["data"] as? [[Any]] {
                    for walk in data {
                        if let wData = Walk(withArray: walk) {
                            walks.append(wData)
                        }
                    }
                }
            }
            
            return walks
    }

    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "walkDetailSegue" {
            let wof = segue.destination as? WalkDetailViewController
            let selectWalk = sender as? UITableViewCell
            let wofCell = self.tableView.indexPath(for: selectWalk!)!
            wof?.walkOfFame = walks[wofCell.row].description
        }
        
        
    }
    
        
}

