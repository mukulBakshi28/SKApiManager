//
//  TextFieldHelper.swift
//  LaundaryApp
//
//  Created by Mukul Bakshi on 09/11/17.
//  Copyright © 2017 Apptunix. All rights reserved.
//

import UIKit


//MARK: TextField Helper
class TextFieldHelper: UITextField {
    
    
     
    
    //PlaceHolder
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return CGRect(x: bounds.origin.x + 10, y: bounds.origin.y, width: bounds.size.width, height: bounds.size.height)
    }
    //Text
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return CGRect(x: bounds.origin.x + 10, y: bounds.origin.y, width: bounds.size.width, height: bounds.size.height)
    }
    
    @IBInspectable var borderColor:UIColor = UIColor.white
        {
        didSet {
             self.layer.borderColor =  borderColor.cgColor
        }
     }
    
    @IBInspectable var borderWidth:CGFloat = 0.0
        {
        didSet {
            layer.borderWidth = borderWidth
        }
     }
  }

//MARK: View Helper
class ViewHelper: UIView
{
    
    @IBInspectable  var cornerRadius:CGFloat = 0.0{
    didSet{
         layer.cornerRadius = CGFloat(cornerRadius)
    }
  }
    
}

//MARK: Button Helper
class ButtonHelper:UIButton
{
    
     override func draw(_ rect: CGRect) {
        super.draw(rect)
          self.addTarget(self, action: #selector(self.touchDown), for: .touchDown)
        self.addTarget(self, action: #selector(self.touchUp), for: .touchUpInside)
    }
    
    func touchUp(sender:UIButton)
    {
         self.transform    = CGAffineTransform(scaleX: 1, y: 1)
     }
    
    func touchDown(sender:UIButton)
    {
         self.transform    = CGAffineTransform(scaleX: 0.9, y: 0.9)
    }
     @IBInspectable var cornerRadius:CGFloat = 0.0
        {
        didSet{
            layer.cornerRadius = cornerRadius
        }
    }
         @IBInspectable var borderWidth:CGFloat = 0.0
        {
        
        didSet {
            layer.borderWidth = borderWidth
            layer.borderColor = UIColor.lightGray.cgColor
        }
     }
 }

extension UINavigationController
{
    
     //MARK: Set Navigation Title
     func setNavigationTitle(titleStr:String)
     {
          self.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.white , NSFontAttributeName: UIFont(name: "HelveticaNeue-Bold", size: 16.0)! ]
     }
    
    //MARK: Push Controller With Id
    func pushControllerWithId(identifier:String)
    {
         let vc = self.storyboard?.instantiateViewController(withIdentifier: identifier)
         self.pushViewController(vc!, animated: true)
     }
}
extension String
{
         func isValidEmail() -> Bool
        {
            let emailRegEx = "[A-Z0-9a-z_%+-]+@[A-Za-z0-9_-]+\\.[A-Z.a-z]{2,5}"
            let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
            return emailTest.evaluate(with: self)
        }
 }

extension UIViewController
{
    func showAlertWithOkAndCancel(message: String ,strtitle: String, okTitle : String, cancel : String, handler:((UIAlertAction) -> Void)! = nil)
    {
        let alert = UIAlertController(title: strtitle,
                                      message:message,
                                      preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: okTitle,
                                      style: .default,
                                      handler: handler))
        
        alert.addAction(UIAlertAction(title: cancel,
                                      style: .cancel,
                                      handler: nil))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    
}
extension NSDictionary
{
    func stringWithBlank(forKey key : Any) -> String
    {
        if let str = self.object(forKey: key)
        {
            if str is NSNull
            {
                return ""
            }
            
            return "\(str)"
        }
        
        return ""
    }
    
    
}


extension DateFormatter
{
    
    func strTimeFromDt(dT:Date) -> String
    {
        let df = DateFormatter()
        df.dateFormat = "hh:mm a"
        df.timeZone = TimeZone.current
        let dString = df.string(from: dT)
        return dString
    }
  
    func strDateFromDt(dT:Date) -> String
    {
        let df = DateFormatter()
        df.dateFormat = "yyyy/MM/dd"
        df.timeZone = TimeZone.current
        let dString = df.string(from: dT)
        return dString
    }
    
    func strDateTimeFromDt(strDate:String) -> Date
    {
        let df = DateFormatter()
        df.dateFormat = "yyyy/MM/dd HH:mm:ss"
        df.timeZone = TimeZone.current
        let dString = df.date(from: strDate)
        return dString!
    }
    
    //mark: Get time Date
     func getDateFromStr(dateStr:String) -> Date
     {
        let df = DateFormatter()
        df.dateFormat  = "hh:mm a"
        let timeDate =  df.date(from: dateStr)
        print("timeDate is",timeDate)
        return timeDate!
     }
 
    
}


extension Date {
    
    
    //MARK: Calculate Difference Between Dates
    func offsetFrom(date: Date) -> String {
        
        let dayHourMinuteSecond: Set<Calendar.Component> = [.day, .hour, .minute, .second]
        let difference = NSCalendar.current.dateComponents(dayHourMinuteSecond, from: date, to: self);
        
        let seconds = "\(difference.second ?? 0)s"
        let minutes = "\(difference.minute ?? 0)m" + " " + seconds
        let hours = "\(difference.hour ?? 0)h" + " " + minutes
        let days = "\(difference.day ?? 0)d" + " " + hours
        
        if let day    = difference.day, day          > 0 { return days }
        if let hour   = difference.hour, hour       > 0 { return hours }
        if let minute = difference.minute, minute > 0 { return minutes }
        if let second = difference.second, second > 0 { return seconds }
        return ""
    }
    
}
