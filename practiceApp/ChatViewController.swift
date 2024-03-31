//
//  ChatViewController.swift
//  practiceApp
//
//  Created by t032fj on 2024/03/24.
//

import UIKit
import FirebaseFirestore
import DGCharts
import FirebaseAuth

class ChatViewController: BaseViewController, UITabBarDelegate, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var tabBar: UITabBar!
    @IBOutlet weak var baseView: UIView!
    @IBOutlet weak var tableView: UITableView!
    
    var chartView: LineChartView!
    var pieChartView: PieChartView!
    var lineDataSet: LineChartDataSet!
    
    private let data: [Double] = [100.0, 65.0, 90.0, 30.0, 45.0]
    private let labels: [String] = ["100.0", "65.0", "90.0", "30.0", "45.0"]
    
    var authors: [String] = []
    var pieDic: [String: Int] = [:] {
        didSet {
            authors = []
            var initialDic: [String: Double] = [:]
            let total = pieDic.reduce(0, { partialResult, key in
                partialResult + key.value
            })
            _ = pieDic.map { key, value in
                let ratio = Double(value) / Double(total)
                initialDic["\(key)"] = ratio
            }
            _ = pieDic.sorted { pie1, pie2 in
                pie1.value > pie2.value
            }.map { key, value in
                authors.append(key)
            }
            self.setupPieChartView(dic: initialDic)
            pieChartView.isHidden = true
            self.tableView.reloadData()
        }
    }
    
    var chartViewModel: ChartViewModel?
  
    override func viewDidLoad() {
        super.viewDidLoad()
        
        chartViewModel = model as? ChartViewModel
        
        tabBar.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        setupChart()
        setupChartView()
    }
    
    @IBAction func goBackView(_ sender: Any) {
        Router(viewController: self, nameVC: nil, model: nil).goBackView()
    }
    
    private func setupChartView() {
        chartView = LineChartView()
        var dataEntries: [ChartDataEntry] = []
        for (index, value) in data.enumerated() {
            let dataEntry = ChartDataEntry(x: Double(index), y: value)
            dataEntries.append(dataEntry)
        }
        lineDataSet = LineChartDataSet(entries: dataEntries, label: "冊数")
        chartView.data = LineChartData(dataSet: lineDataSet)
        chartView.xAxis.labelPosition = .bottom
        chartView.xAxis.labelCount = dataEntries.count - 1
        chartView.xAxis.valueFormatter = IndexAxisValueFormatter(values: labels)
        chartView.xAxis.axisLineColor = .black
        chartView.leftAxis.axisLineColor = .black
        chartView.doubleTapToZoomEnabled = false
        chartView.rightAxis.enabled = false
        
        chartView.translatesAutoresizingMaskIntoConstraints = false
        baseView.addSubview(chartView)
        chartView.centerXAnchor.constraint(equalTo: baseView.centerXAnchor).isActive = true
        chartView.topAnchor.constraint(equalTo: baseView.topAnchor, constant: 25).isActive = true
        chartView.widthAnchor.constraint(equalToConstant: 300).isActive = true
        chartView.heightAnchor.constraint(equalToConstant: 300).isActive = true
    }
    
    private func setupPieChartView(dic: [String: Double]) {
        pieChartView = PieChartView(frame: CGRect(x: 0, y: 0, width: 300, height: 300))
        pieChartView.highlightPerTapEnabled = false
        pieChartView.chartDescription.enabled = false  // グラフの説明を非表示
        pieChartView.legend.enabled = false  // グラフの注釈を非表示
        pieChartView.rotationEnabled = false // グラフがぐるぐる動くのを無効化
        pieChartView.entryLabelColor = UIColor.black
        pieChartView.centerText = "著者"
        
        var pieChartDateEntries: [PieChartDataEntry] = []
        _ = dic.map { key, value in
            let pieChartDateEntry: PieChartDataEntry?
            if key == "" {
                pieChartDateEntry = PieChartDataEntry(value: value * 100, label: "その他")
            } else {
                pieChartDateEntry = PieChartDataEntry(value: value * 100, label: key)
            }
            if let pieChart = pieChartDateEntry {
                pieChartDateEntries.append(pieChart)
                pieChartDateEntries = pieChartDateEntries.sorted { pie1, pie2 in
                    pie1.value > pie2.value
                }
            }
        }
        
        let dataSet = PieChartDataSet(entries: pieChartDateEntries, label: "Data")
        dataSet.setColors(UIColor.systemRed, UIColor.systemBlue, UIColor.systemGreen)
        dataSet.entryLabelColor = UIColor.black
        dataSet.valueTextColor = UIColor.black
        pieChartView.data = PieChartData(dataSet: dataSet)
        
        pieChartView.translatesAutoresizingMaskIntoConstraints = false
        baseView.addSubview(pieChartView)
        pieChartView.centerXAnchor.constraint(equalTo: baseView.centerXAnchor).isActive = true
        pieChartView.topAnchor.constraint(equalTo: baseView.topAnchor, constant: 25).isActive = true
        pieChartView.widthAnchor.constraint(equalToConstant: 300).isActive = true
        pieChartView.heightAnchor.constraint(equalToConstant: 300).isActive = true
    }
    
    private func setupChart() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        Firestore.firestore().collection("books").whereField("uid", in: [uid]).getDocuments(completion: { snapshots, error in
            if let error = error {
                print(error)
            }
            for document in snapshots!.documents {
                let dic = document.data()
                var author: String = dic["author"] as! String
                author = author.replacingOccurrences(of: " ", with: "")
                author = author.replacingOccurrences(of: "　", with: "")
                let isKey = self.pieDic.map { key, value in
                    return key == author
                }
                if !isKey.contains(true) {
                    self.pieDic["\(author)"] = 1
                } else {
                    self.pieDic["\(author)"] = (self.pieDic["\(author)"] ?? 0) + 1
                }
            }
        })
    }
    
    func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        if item.tag == 0 {
            chartView.isHidden = false
            pieChartView.isHidden = true
        } else {
            chartView.isHidden = true
            pieChartView.isHidden = false
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pieDic.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel!.text = (pieDic["\(authors[indexPath.row])"]?.description ?? "") + "：" + authors[indexPath.row].description
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
    }
}
