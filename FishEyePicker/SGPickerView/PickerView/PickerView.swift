import UIKit

@objc protocol PickerViewDelegate: class {
  optional func pickerView(pickerView: AKPickerView!, didSelectItem item: Int)
  optional func pickerView(pickerView: AKPickerView!, marginForItem item: Int) -> CGSize
  optional func pickerView(pickerView: AKPickerView!, configureLabel label: UILabel!, forItem item: Int)
}

@objc protocol PickerViewDatasource: class {
  func numberOfItemsInPickerView(pickerView: AKPickerView) -> UInt
  optional func pickerView(pickerView: AKPickerView!, titleForItem item: Int) -> String
  optional func pickerView(pickerView: AKPickerView!, subTitleForItem item: Int) -> String!
  optional func pickerView(pickerView: AKPickerView!, imageForItem item: Int) -> UIImage!
}

class PickerView: UIView {
  
  weak var delegate: PickerViewDelegate?
  weak var datasource: PickerViewDatasource?

  @IBOutlet var pickerPlaceHolderView: UIView!
  @IBOutlet var indicatorPlaceHolderView: UIView!
  
  // Indicator Properties
  var indicatorView: IndicatorView!
  
  // Picker Properties
  var font: UIFont!
  var highLightedFont: UIFont!
  var textColor: UIColor!
  var highlightedTextColor: UIColor!
  var interitemSpacing: CGFloat!
  var fisheyeFactor: CGFloat! // 0...1
  var maskDisabled: Bool!
  var pickerViewStyle: AKPickerViewStyle! = .StyleFlat
  var selectedItem: UInt {
    get {
      return picker.selectedItem
    }
  }
  var contentOffset: CGPoint {
    get {
      return picker.contentOffset
    }
  }

  private var picker: AKPickerView!
  
  
  var indicatorThumbColor = UIColor.greenColor() {
    didSet {
      indicatorView.indicatorThumb.backgroundColor = indicatorThumbColor
    }
  }
  var indicatorBarColor = UIColor.grayColor() {
    didSet{
      indicatorView.indicatorBar.backgroundColor = indicatorBarColor
    }
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
  
  override func awakeFromNib() {
    super.awakeFromNib()
    initializeView()
  }
  
  private func initializeView() {
    
    picker = AKPickerView(frame: pickerPlaceHolderView.bounds)
    picker.backgroundColor = UIColor.clearColor()
    picker.delegate = self
    picker.dataSource = self
    
    pickerPlaceHolderView.addSubview(picker)
    
    guard let indicatorView = NSBundle.mainBundle().loadNibNamed("IndicatorView", owner: self, options: nil).last as? IndicatorView else { return }
    self.indicatorView = indicatorView
    indicatorView.indicatorThumb.backgroundColor = indicatorThumbColor
    indicatorView.indicatorBar.backgroundColor = indicatorBarColor
    indicatorPlaceHolderView.addSubview(indicatorView)
    
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    guard let picker = picker else { return }
    picker.frame = pickerPlaceHolderView.bounds
    
    guard let indicatorView = indicatorView else { return }
    indicatorView.frame = indicatorPlaceHolderView.bounds
    
  }
  
  func reloadData() {
    if let font = font {
      picker.font = font
    }
    if let highLightedFont = highLightedFont {
      picker.highlightedFont = highLightedFont
    }
    if let textColor = textColor {
      picker.textColor = textColor
    }
    if let highlightedTextColor = highlightedTextColor {
      picker.highlightedTextColor = highlightedTextColor
    }
    if let interitemSpacing = interitemSpacing {
      picker.interitemSpacing = interitemSpacing
    }
    if let fisheyeFactor = fisheyeFactor {
      picker.fisheyeFactor = fisheyeFactor
    }
    if let maskDisabled = maskDisabled {
      picker.maskDisabled = maskDisabled
    }
    if let pickerViewStyle = pickerViewStyle {
      picker.pickerViewStyle = pickerViewStyle
    }
    picker.reloadData()
  }
  
  func scrollToItem(item: UInt, animated: Bool) {
    picker.scrollToItem(item, animated: animated)
  }
  
  func selectItem(item: UInt, animated: Bool) {
    picker.selectItem(item, animated: animated)
  }

}

extension PickerView: AKPickerViewDelegate {
  
  func pickerView(pickerView: AKPickerView!, didSelectItem item: Int) {
    delegate?.pickerView?(pickerView, didSelectItem: item)
  }
  
  func pickerView(pickerView: AKPickerView!, marginForItem item: Int) -> CGSize {
    guard let size = delegate?.pickerView?(pickerView, marginForItem: item) else { return CGSize(width: 5, height: 20) }
    return size
  }
  
  func pickerView(pickerView: AKPickerView!, configureLabel label: UILabel!, forItem item: Int) {
    delegate?.pickerView?(pickerView, configureLabel: label, forItem: item)
  }
  
}

extension PickerView: AKPickerViewDataSource {
  
  func numberOfItemsInPickerView(pickerView: AKPickerView!) -> UInt {
    guard let datasource = datasource else { return 0 }
    return datasource.numberOfItemsInPickerView(pickerView)
  }
  
  func pickerView(pickerView: AKPickerView!, titleForItem item: Int) -> String! {
    guard let datasource = datasource else { return nil }
    return datasource.pickerView?(pickerView, titleForItem: item)
  }
  
  func pickerView(pickerView: AKPickerView!, subTitleForItem item: Int) -> String! {
    guard let datasource = datasource else { return nil }
    return datasource.pickerView?(pickerView, subTitleForItem: item)
  }
  
  func pickerView(pickerView: AKPickerView!, imageForItem item: Int) -> UIImage! {
    guard let datasource = datasource else { return nil }
    return datasource.pickerView?(pickerView, imageForItem: item)
  }
  
}
