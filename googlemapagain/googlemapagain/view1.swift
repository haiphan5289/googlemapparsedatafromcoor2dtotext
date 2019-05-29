//
//  view1.swift
//  googlemapagain
//
//  Created by HaiPhan on 5/29/19.
//  Copyright © 2019 HaiPhan. All rights reserved.
//

import UIKit

class view1: UIViewController {

    @IBOutlet weak var lbllong: UILabel!
    @IBOutlet weak var lbllat: UILabel!
    @IBOutlet weak var lbltitle: UILabel!
    var texttitle: String!
    var textlat: String!
    var textlong: String!
    override func viewDidLoad() {
        super.viewDidLoad()
        lbllat.text = textlat
        lbllong.text = textlong
        lbltitle.text = texttitle

    }

    @IBAction func move(_ sender: UIButton) {
        let screen = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "view2") as! ViewController
        self.navigationController?.pushViewController(screen, animated: true)
    }
    
    
}
