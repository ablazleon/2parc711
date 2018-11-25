//
//  ItemTableViewController.swift
//  2parc711
//
//  Created by Adrian on 24/11/2018.
//  Copyright © 2018 Adrian. All rights reserved.
//

import UIKit

struct Item: Decodable {
    let title: String
    let image1: String
    let image2: String
}

class ItemTableViewController: UITableViewController {

    let URLBASE = "https://www.dit.upm.es/santiago/examen/datos711.json"
    var items = [Item]()
    var imagesCache = [String:UIImage]()
    
    @IBOutlet weak var img1View: UIImageView!
    
    @IBOutlet weak var img2View: UIImageView!
    
    @IBOutlet weak var urlLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateItems()
        tableView.estimatedRowHeight = 120
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return items.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "myCell", for: indexPath) as! MyTableViewCell

        // Configure the cell...

        let item = items[indexPath.row]
        cell.urlLabel?.text = item.title
        // print(item.title)
        
        let imgurl1 = items[indexPath.row].image1
        if let img1 = imagesCache[imgurl1] {
            cell.img1View.image = img1
            print(imgurl1)
        } else {
            updateImage(urls: imgurl1, indexPath: indexPath)
        }
        
        
        
        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    // Download the items, store and relaod the data.
    func updateItems() {
        
        // 1. Get url and escape it
        
        guard let escapedUrl = URLBASE.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
            print("Bad escaping")
            return
        }
        
        guard let url =  URL(string: escapedUrl) else {
            print("Bad Url")
            return
        }
        
        // 2. Get data in queue
        
        DispatchQueue.global().async{
            
            guard let data = try? Data(contentsOf: url) else{
                print("Bad data")
                return
            }
            
        // 3. Transform the data, to a json
            
            let decoder = JSONDecoder()
            if let itemsDecoded = try? decoder.decode([Item].self, from: data){
            
                DispatchQueue.main.async {
                    // 4. Store them in items
                    
                    self.items = itemsDecoded
                    print(self.items.count)
                    // 5. Reload the table
                    
                    self.tableView.reloadData()
                }
            } else {
                print("Bad decoding")
            }
        }
    }
    
    // Update teh images cache
    func updateImage(urls: String, indexPath: IndexPath){
        
        // 1. Get url and escaped it, in a global queue
        
        // DispatchQueue.global().async {
            guard let urlEscaped = urls.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
                print( "Bad escaping")
                return
            }
            guard let url = URL(string: urlEscaped) else { print("Bad URL"); return }
            
            // 2. Get data, using a data task
            
            let session = URLSession(configuration: URLSessionConfiguration.default)
            DispatchQueue.main.async{
                UIApplication.shared.isNetworkActivityIndicatorVisible = true
            }
            let task = session.downloadTask(with: url) { (location: URL?,
                                                          response: URLResponse?,
                                                          error: Error?) in
                guard error == nil && (response as! HTTPURLResponse).statusCode == 200 else {
                    print("Bad downloading"); return
                }
                guard let data = try? Data(contentsOf: location!) else { print("Bada data"); return}
                
                // 3. Trasnform it to image
                
                let img = UIImage(data: data)
                
                // 4. Store it in img cache
                DispatchQueue.main.async{
                    self.imagesCache[urls] = img
                    
                    // 5. Reload rows
                    
                    print(indexPath)
                    self.tableView.reloadRows(at: [indexPath], with: .fade)
                    // print(urls)
                    UIApplication.shared.isNetworkActivityIndicatorVisible = false
                }
            }
            task.resume()
        //}
    }
    
}
