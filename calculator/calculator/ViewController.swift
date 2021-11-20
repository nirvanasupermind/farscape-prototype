//
//  ViewController.swift
//  calculator
//
//  Created by Nirvana Choudhury on 10/20/21.
//  Copyright © 2021 Sugar Glider/. All rights reserved.


import UIKit

// concatenate attributed strings
func + (left: NSAttributedString, right: NSAttributedString) -> NSAttributedString {
    let result = NSMutableAttributedString()
    result.append(left)
    result.append(right)
    return result
}

public extension NSMutableAttributedString {
    var fontSize:CGFloat { return 14 }
    var boldFont:UIFont { return UIFont(name: "System Bold", size: fontSize) ?? UIFont.boldSystemFont(ofSize: fontSize) }
    var normalFont:UIFont { return UIFont(name: "System Regular", size: fontSize) ?? UIFont.systemFont(ofSize: fontSize)}
    
    func bold(_ value:String) -> NSMutableAttributedString {
        
        let attributes:[NSAttributedString.Key : Any] = [
            .font : boldFont
        ]
        
        self.append(NSAttributedString(string: value, attributes:attributes))
        return self
    }
    
    func normal(_ value:String) -> NSMutableAttributedString {
        
        let attributes:[NSAttributedString.Key : Any] = [
            .font : normalFont,
        ]
        
        self.append(NSAttributedString(string: value, attributes:attributes))
        return self
    }
    /* Other styling methods */
    func orangeHighlight(_ value:String) -> NSMutableAttributedString {
        
        let attributes:[NSAttributedString.Key : Any] = [
            .font :  normalFont,
            .foregroundColor : UIColor.white,
            .backgroundColor : UIColor.orange
        ]
        
        self.append(NSAttributedString(string: value, attributes:attributes))
        return self
    }
    
    func blackHighlight(_ value:String) -> NSMutableAttributedString {
        
        let attributes:[NSAttributedString.Key : Any] = [
            .font :  normalFont,
            .foregroundColor : UIColor.white,
            .backgroundColor : UIColor.black
            
        ]
        
        self.append(NSAttributedString(string: value, attributes:attributes))
        return self
    }
    
    func underlined(_ value:String) -> NSMutableAttributedString {
        
        let attributes:[NSAttributedString.Key : Any] = [
            .font :  normalFont,
            .underlineStyle : NSUnderlineStyle.single.rawValue
            
        ]
        
        self.append(NSAttributedString(string: value, attributes:attributes))
        return self
    }
}


class ViewController: UIViewController {
    
    var count: Int = 1
    
    var interpreter: Interpreter = Interpreter([:])

    @IBOutlet weak var textView: UITextView!
    
    @IBOutlet weak var textField: UITextField!
    
    @IBAction func submitButton(_ sender: Any) {
        var text: String = textField.text!
        
        var res: String = ""
        

        do {
            var lexer: Lexer = Lexer(text)
            var tokens: [Token] = try lexer.get_tokens()
            
            var parser: Parser = Parser(tokens)
            var tree: Node = try parser.parse()

            res = "\(try self.interpreter.visit(tree))"
            
        } catch let error as CalcError {
            res = "\(error.rawValue)"
        } catch {
            fatalError(error.localizedDescription)
        }
        
        var tmp: String = "In[\(self.count)] := \(text)\nOut[\(self.count)] = "
        
        
        var attributedString: NSMutableAttributedString = NSMutableAttributedString()
            .normal(tmp)
            .bold("\(res)")
                
        
        if(textView.text == "") {
            textView.attributedText = attributedString
        } else {
            textView.attributedText = textView.attributedText + NSMutableAttributedString(string: "\n\n") + attributedString
        }
        
        self.count = self.count + 1
    }
    
    @IBAction func clearButton(_ sender: Any) {
        textView.text = ""
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
}
