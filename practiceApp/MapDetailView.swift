//
//  MapDetailView.swift
//  practiceApp
//
//  Created by t032fj on 2024/03/18.
//

import UIKit

class MapDetailView: UIView, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var label: UILabel?
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var button: UIButton!

    override init(frame: CGRect) {
        super.init(frame: frame)
        nibInit()
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        nibInit()
    }
    
    override func layoutSubviews() {
        tableView.layer.borderColor = UIColor.systemGray4.cgColor
        tableView.layer.borderWidth = 1
        tableView.separatorStyle = .none
    }
    
    private func nibInit() {
        let nib = UINib(nibName: "MapDetailView", bundle: nil)
        guard let view = nib.instantiate(withOwner: self, options: nil).first as? UIView else { return }
        self.addSubview(view)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel!.text = "TODO[indexPath.row]"
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("select")
    }
   
    @IBAction func backView(_ sender: Any) {
        print("tap")
    }
}
