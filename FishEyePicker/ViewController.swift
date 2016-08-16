import UIKit

class ViewController: UIViewController {
  
  @IBOutlet var fisheyePickerView: AKPickerView!
  var datePicker: PickerView!
  
  var pickerTitles = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Satur"]
  var dates = [Date]()

  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
    
    guard let datePicker = NSBundle.mainBundle().loadNibNamed("PickerView", owner: self, options: nil).last as? PickerView else { return }
    self.datePicker = datePicker
    let rect = CGRect(x: 0, y: 60, width: view.frame.width, height: 70)
    datePicker.frame = rect
    datePicker.delegate = self
    datePicker.datasource = self
    datePicker.indicatorBarColor = UIColor.redColor()
    datePicker.indicatorThumbColor = UIColor.greenColor()
    datePicker.indicatorView.backgroundColor = UIColor.clearColor()
    datePicker.font = UIFont.systemFontOfSize(17)
    datePicker.highLightedFont = UIFont.systemFontOfSize(24)
    datePicker.pickerViewStyle = .StyleFlat
    datePicker.textColor = UIColor.whiteColor()
    datePicker.highlightedTextColor = UIColor.whiteColor()
    
    datePicker.backgroundColor = UIColor.blackColor()
    
    view.addSubview(datePicker)
    
    // Model Configuration
    
    let dateManager = DateManager()
    dateManager.dateFormat = "MMM dd"
    let startDate = NSDate(timeIntervalSinceNow: -1234567)
    let endDate = NSDate(timeIntervalSinceNow: 1234567)
    let nsDates = dateManager.allNSDatesBetween(startDate, endDate: endDate)
    dates = nsDates.map({Date.init(nsDate: $0)})
    
    datePicker.reloadData()
    let currentDateIndex = dates.indexOf {
      $0 == Date(nsDate: NSDate())
    }
    
    guard let index = currentDateIndex else { return }
    datePicker.selectItem(UInt(index), animated: false)

    
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    let rect = CGRect(x: 0, y: 60, width: view.frame.width, height: 70)
    datePicker.frame = rect
    
  }

}

extension ViewController: PickerViewDelegate {
  
  func pickerView(pickerView: AKPickerView!, marginForItem item: Int) -> CGSize {
    return CGSize(width: 15, height: 20)
  }
  
}

extension ViewController: PickerViewDatasource {
  func numberOfItemsInPickerView(pickerView: AKPickerView) -> UInt {
    return UInt(dates.count)
  }
  
  func pickerView(pickerView: AKPickerView!, titleForItem item: Int) -> String {
    return dates[item].dayOfWeekString
  }
  
  func pickerView(pickerView: AKPickerView!, subTitleForItem item: Int) -> String! {
    let formatter = NSDateFormatter()
    formatter.dateFormat = "MMM"
    let monthString = formatter.stringFromDate(dates[item].nsDate).lowercaseString
    return "\(monthString) \(dates[item].day)"
  }
}

