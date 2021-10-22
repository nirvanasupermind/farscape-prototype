//
//  ViewController.swift
//  calculator
//
//  Created by Nirvana Choudhury on 10/20/21.
//  Copyright © 2021 Sugar Glider/. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var count: Int = 0
    
    var interpreter: Interpreter = Interpreter([:])

    @IBOutlet weak var textView: UITextView!
    
    @IBOutlet weak var textField: UITextField!
    
    @IBAction func submitButton(_ sender: Any) {
        var text: String = textField.text!
        
        var result: String = ""
        
        do {
            var lexer: Lexer = Lexer(text)
            var tokens: [Token] = try lexer.get_tokens()
            
            var parser: Parser = Parser(tokens)
            var tree: Node = try parser.parse()

            var value: Number = try self.interpreter.visit(tree)
            
            result = "In[\(self.count)] := \(text)\nOut[\(self.count)] = \(value)"
        } catch let error as CalcError {
            result = "\(error.rawValue)"
        } catch {
            
        }
        
        if(textView.text == "") {
            textView.text = result
        } else {
            textView.text += "\n\n\(result)"
        }
        
        self.count += 1
    }
    
    @IBAction func clearButton(_ sender: Any) {
        textView.text = ""
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
}

