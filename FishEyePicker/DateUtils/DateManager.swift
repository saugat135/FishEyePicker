import UIKit

func ==(lhs: Date, rhs: Date) -> Bool {
  if (lhs.day == rhs.day) && (lhs.month == rhs.month) && (lhs.year == rhs.year) {
    return true
  } else {
    return false
  }
}

struct Date {
  let nsDate: NSDate
  let day: Int
  let month: Int
  let year: Int
  let dayOfWeek: Int
  var dayOfWeekString: String {
    get {
      switch dayOfWeek {
      case 1:
        return "Sun"
      case 2:
        return "Mon"
      case 3:
        return "Tue"
      case 4:
        return "Wed"
      case 5:
        return "Thu"
      case 6:
        return "Fri"
      case 7:
        return "Sat"
      default:
        return "NAN"
      }
    }
  }
  
  init(nsDate: NSDate) {
    let calendar = NSCalendar(identifier: NSCalendarIdentifierGregorian)!
    self.nsDate = nsDate
    day = calendar.component(.Day, fromDate: nsDate)
    month = calendar.component(.Month, fromDate: nsDate)
    year = calendar.component(.Year, fromDate: nsDate)
    dayOfWeek = calendar.component(.Weekday, fromDate: nsDate)
  }
  
}

extension Date: Equatable {
  
}

class DateManager {
  var dateFormat: String!
  
  func allNSDatesBetween(startDate: NSDate, endDate: NSDate) -> [NSDate] {
    var date = startDate // first date
    let endDate = endDate // last date
    
    // Calendar
    let calendar = NSCalendar(identifier: NSCalendarIdentifierGregorian)!
    
    // Formatter for printing the date, adjust it according to your needs:
    
    var dates = [NSDate]()
    
    // While date <= endDate ...
    while date.compare(endDate) != .OrderedDescending {
      // Advance by one day:
      date = calendar.dateByAddingUnit(.Day, value: 1, toDate: date, options: [])!
      dates.append(date)
    }
    
    return dates
  }
  
}
