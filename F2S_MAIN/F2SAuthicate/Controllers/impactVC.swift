//
//  DashboardVC.swift
//  DonationProject
//
//  Created by wael on 25/12/2025.
//


import UIKit
import Charts
import DGCharts

class impactVC: UIViewController {

    @IBOutlet weak var weeklyContainer: UIView!
    @IBOutlet weak var weeklyChart: LineChartView!

    @IBOutlet weak var categoriesContainer: UIView!
    @IBOutlet weak var categoriesChart: PieChartView!

    @IBOutlet weak var monthlyContainer: UIView!
    @IBOutlet weak var monthlyChart: BarChartView!

    @IBOutlet weak var mealNumbersLbl: UILabel!

    private var lastAnimationTime: Date?

    override func viewDidLoad() {
        super.viewDidLoad()

        styleCard(weeklyContainer)
        styleCard(categoriesContainer)
        styleCard(monthlyContainer)

        setupWeeklyLineChart()
        setupPieChart()
        setupMonthlyBarChart()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        // Reset counters and redraw state before animation
        mealNumbersLbl.text = "0"
        weeklyChart.data?.notifyDataChanged()
        weeklyChart.notifyDataSetChanged()

        categoriesChart.data?.notifyDataChanged()
        categoriesChart.notifyDataSetChanged()

        monthlyChart.data?.notifyDataChanged()
        monthlyChart.notifyDataSetChanged()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        // Avoid animation if screen reappears in < 0.3s due to small layout update
        if let last = lastAnimationTime, Date().timeIntervalSince(last) < 0.3 { return }
        lastAnimationTime = Date()

        animateCharts()
        animateMealCounter(to: 200, duration: 1.4)
    }

    private func styleCard(_ view: UIView) {
        view.backgroundColor = .white
        view.layer.cornerRadius = 20
        view.layer.masksToBounds = true
    }

    // MARK: WEEKLY LINE CHART
    private func setupWeeklyLineChart() {
        let entries = [
            ChartDataEntry(x: 1, y: 22),
            ChartDataEntry(x: 2, y: 26),
            ChartDataEntry(x: 3, y: 18),
            ChartDataEntry(x: 4, y: 32),
            ChartDataEntry(x: 5, y: 25)
        ]

        let set = LineChartDataSet(entries: entries, label: "")
        set.colors = [.systemPurple]
        set.circleColors = [.systemPurple]
        set.circleRadius = 5
        set.lineWidth = 3
        set.mode = .cubicBezier
        set.drawValuesEnabled = false

        let data = LineChartData(dataSet: set)
        weeklyChart.data = data

        weeklyChart.rightAxis.enabled = false
        weeklyChart.leftAxis.enabled = false
        weeklyChart.xAxis.enabled = false
        weeklyChart.legend.enabled = false
        weeklyChart.chartDescription.enabled = false
        weeklyChart.backgroundColor = .clear
    }

    // MARK: PIE / DONUT
    private func setupPieChart() {
        let entries = [
            PieChartDataEntry(value: 30, label: "Bread"),
            PieChartDataEntry(value: 50, label: "Meals"),
            PieChartDataEntry(value: 20, label: "Produce")
        ]

        let set = PieChartDataSet(entries: entries, label: "")
        set.colors = [
            UIColor.systemPurple,
            UIColor.systemPurple.withAlphaComponent(0.6),
            UIColor.systemPurple.withAlphaComponent(0.3)
        ]
        set.drawValuesEnabled = false
        set.selectionShift = 6

        categoriesChart.data = PieChartData(dataSet: set)
        categoriesChart.holeRadiusPercent = 0.68
        categoriesChart.transparentCircleColor = .clear
        categoriesChart.legend.enabled = false
        categoriesChart.chartDescription.enabled = false
        categoriesChart.backgroundColor = .clear
    }

    // MARK: ROUNDED BAR CHART
    private func setupMonthlyBarChart() {
        let entries = [
            BarChartDataEntry(x: 1, y: 16),
            BarChartDataEntry(x: 2, y: 20),
            BarChartDataEntry(x: 3, y: 18),
            BarChartDataEntry(x: 4, y: 19)
        ]

        let set = BarChartDataSet(entries: entries, label: "")
        set.drawValuesEnabled = false

        monthlyChart.data = BarChartData(dataSet: set)
        monthlyChart.legend.enabled = false
        monthlyChart.rightAxis.enabled = false
        monthlyChart.leftAxis.enabled = false
        monthlyChart.xAxis.enabled = false
        monthlyChart.chartDescription.enabled = false
        monthlyChart.backgroundColor = .clear

        monthlyChart.renderer = RoundedBarChartRenderer(
            dataProvider: monthlyChart,
            animator: monthlyChart.chartAnimator,
            viewPortHandler: monthlyChart.viewPortHandler
        )
    }

    // MARK: ANIMATION FUNCTIONS
    private func animateCharts() {
        weeklyChart.animate(xAxisDuration: 1.2, yAxisDuration: 1.0, easingOption: .easeOutQuart)
        categoriesChart.animate(yAxisDuration: 1.0, easingOption: .easeOutBack)
        monthlyChart.animate(yAxisDuration: 1.0, easingOption: .easeOutQuart)
    }

    private func animateMealCounter(to value: Int, duration: TimeInterval) {
        let start = 0
        let end = value
        let delta = end - start

        var currentTime: TimeInterval = 0
        let interval: TimeInterval = 0.02

        Timer.scheduledTimer(withTimeInterval: interval, repeats: true) { timer in
            currentTime += interval
            let percent = min(currentTime / duration, 1.0)
            let number = start + Int(Double(delta) * percent)
            self.mealNumbersLbl.text = "\(number)"

            if percent >= 1.0 { timer.invalidate() }
        }
    }
}


// MARK: ROUNDED BAR CHART RENDERER
class RoundedBarChartRenderer: BarChartRenderer {

    override func drawDataSet(context: CGContext, dataSet: BarChartDataSetProtocol, index: Int) {
        guard let dataProvider = dataProvider else { return }
        let trans = dataProvider.getTransformer(forAxis: dataSet.axisDependency)

        var barRect = CGRect()

        for i in 0 ..< Int(dataSet.entryCount) {
            guard let entry = dataSet.entryForIndex(i) as? BarChartDataEntry else { continue }
            barRect = CGRect(x: CGFloat(entry.x) - 0.3, y: 0, width: 0.6, height: CGFloat(entry.y))
            trans.rectValueToPixel(&barRect)

            let radius = min(barRect.width, barRect.height) / 3
            let path = UIBezierPath(roundedRect: barRect, cornerRadius: radius)
            context.setFillColor(UIColor.systemPurple.cgColor)
            context.addPath(path.cgPath)
            context.fillPath()
        }
    }
}
