//
//  ChartViewController.swift
//  BitCoin
//
//

import UIKit
import Charts

class ChartViewController: UIViewController {

    @IBOutlet weak var chartView: LineChartView!
    @IBOutlet weak var priceLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        DataManager.shared.delegate = self
        DataManager.shared.getMarketPrices()
        DataManager.shared.getActualPrice()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension ChartViewController: DataManagerDelegate {
    func updateMarketPrices(marketPrices: [MarketPrice]) {
        let prices = marketPrices.map({$0.price.roundTo(places: 2)})
        let timestamps = marketPrices.map({String($0.timestamp)})
        
        self.setChart(timestamps, numbers: prices)
    }
    
    func updateActualPrice(actualPrice: ActualPrice) {
        let price = actualPrice.price.roundTo(places: 2)
        self.priceLabel.text = "$ \(price)"
    }
}

extension ChartViewController {
    func setChart(_ dataPoints: [String], numbers: [Double]) {
        var lineChartEntry  = [ChartDataEntry]()

        if let _ = numbers.find ({ $0 > 1 }) {
            
            for i in 0..<dataPoints.count {
                let value = ChartDataEntry(x: Double(i), y: Double(numbers[i]))
                lineChartEntry.append(value)
            }
        }
        
        let lineChartDataSet = LineChartDataSet(values: lineChartEntry, label: nil)
        lineChartDataSet.colors = [NSUIColor.blue]
        lineChartDataSet.drawValuesEnabled = false
        lineChartDataSet.drawCirclesEnabled = false
        lineChartDataSet.setColor(UIColor.white)
        
        var chartDataSet: [LineChartDataSet] = [LineChartDataSet]()
        chartDataSet.append(lineChartDataSet)

        let data = LineChartData(dataSets: chartDataSet)
        chartView.data = data
        
        chartView.chartDescription?.enabled = false
        chartView.legend.enabled = false
        chartView.xAxis.enabled = false
        chartView.xAxis.drawGridLinesEnabled = false
        chartView.leftAxis.enabled = false
        chartView.leftAxis.drawGridLinesEnabled = false
        chartView.rightAxis.enabled = false
        chartView.rightAxis.drawGridLinesEnabled = false
        
        let marker = BalloonMarker(color: UIColor.white, font: UIFont.systemFont(ofSize: 12.0), textColor: UIColor.black, insets: UIEdgeInsetsMake(8.0, 8.0, 20.0, 8.0))
        chartView.marker = marker

        chartView.animate(xAxisDuration: 1.0, yAxisDuration: 0)
    }
}
