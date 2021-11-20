import UIKit
import Foundation
import Darwin

public typealias Env = [String: Number]

//https://stackoverflow.com/questions/25329186/safe-bounds-checked-array-lookup-in-swift-through-optional-bindings
extension Collection {
    /// Returns the element at the specified index if it is within bounds, otherwise nil.
    subscript(safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}

public enum CalcError: String, LocalizedError {
    case LexicalError
    case SyntaxError
    case RuntimeMathError
}

public enum TokenType {
    case NUMBER
    case NAME
    case PLUS
    case MINUS
    case MULTIPLY
    case DIVIDE
    case POWER
    case ASSIGN
    case COMMA
    case LPAREN
    case RPAREN
    case EOF
}

public class Token: CustomStringConvertible {
    public var type: TokenType
    public var value: Float80? = nil
    public var name: String? = nil

    public var description: String {
        get {
            var s: String = "\(self.type)"
         
            if(self.type == TokenType.NUMBER) {
                s += ":\(self.value!)"
            }
            
            if(self.type == TokenType.NAME) {
                s += ":\(self.name!)"
            }
        
            return s
        }
    }
    
    public init(_ type: TokenType) {
        self.type = type
    }
    
    public init(_ type: TokenType, _ value: Float80?) {
        self.type = type
        self.value = value
    }
    
    public init(_ type: TokenType, _ name: String?) {
        self.type = type
        self.name = name
    }
}

public class Lexer {
    public static let WHITESPACE: String = " \n\t"
    public static let DIGITS: String = "0123456789"
    public static let LETTERS: String = "_$abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"

    public var text: [Character]
    public var index: Int
    public var current_char: Character {
        return self.text[self.index]
    }

    public init(_ text: String) {
        self.text = Array(text + "\0")
        self.index = -1
        self.advance()
    }

    public func advance() {
        self.index += 1
    }
    
    public func get_tokens() throws -> [Token] {
        var tokens: [Token] = []
        
        while(self.current_char != "\0") {
            if(Lexer.WHITESPACE.contains(self.current_char)) {
                self.advance()
            } else if(Lexer.DIGITS.contains(self.current_char)) {
                tokens.append(self.get_number())
            } else if(Lexer.LETTERS.contains(self.current_char)) {
                tokens.append(self.get_name())
            } else if(self.current_char == "+") {
                self.advance()
                tokens.append(Token(TokenType.PLUS))
            } else if(self.current_char == "-") {
                self.advance()
                tokens.append(Token(TokenType.MINUS))
            } else if(self.current_char == "*") {
                self.advance()
                tokens.append(Token(TokenType.MULTIPLY))
            } else if(self.current_char == "/") {
                self.advance()
                tokens.append(Token(TokenType.DIVIDE))
            } else if(self.current_char == "^") {
                self.advance()
                tokens.append(Token(TokenType.POWER))
            } else if(self.current_char == "=") {
                self.advance()
                tokens.append(Token(TokenType.ASSIGN))
            } else if(self.current_char == ",") {
                self.advance()
                tokens.append(Token(TokenType.COMMA))
            } else if(self.current_char == "(") {
                self.advance()
                tokens.append(Token(TokenType.LPAREN))
            } else if(self.current_char == ")") {
                self.advance()
                tokens.append(Token(TokenType.RPAREN))
            } else {
                throw CalcError.LexicalError;
            }
        }
        
        tokens.append(Token(TokenType.EOF))
        
        return tokens
    }

    public func get_number() -> Token {
        var decimal_point_count: Int = 0
        var number_str: [Character] = [self.current_char]
        self.advance()

        while(self.current_char != "\0" && (self.current_char == "." || Lexer.DIGITS.contains(self.current_char))) {
            if (self.current_char == ".") {
                decimal_point_count += 1
                if (decimal_point_count > 1) {
                    break;
                }
            }
            
            number_str.append(self.current_char)
            self.advance()
        }

        if (number_str[0] == ".") {
            number_str = "0" + number_str
        }

        if (number_str[number_str.count - 1] == ".") {
            number_str += "0"
        }
            
        return Token(TokenType.NUMBER, Float80(number_str.map { String($0) }.joined(separator: ""))!)
    }
    
    public func get_name() -> Token {
        var name_str: [Character] = [self.current_char]
        self.advance()

        while(self.current_char != "\0" && (Lexer.DIGITS.contains(self.current_char) || Lexer.LETTERS.contains(self.current_char))) {
            
            name_str.append(self.current_char)
            self.advance()
        }

            
        return Token(TokenType.NAME, (name_str.map { String($0) }.joined(separator: "")))
    }
}

public enum NodeType {
    case PlusNode
    case MinusNode
    case EmptyNode
    case NumberNode
    case NameNode
    case AddNode
    case SubtractNode
    case MultiplyNode
    case DivideNode
    case PowerNode
    case AssignNode
    case CallNode
}

public class Node: CustomStringConvertible {
    public var node_type: NodeType
    public var nodeA: Node? = nil
    public var nodeB: Node? = nil
    public var node_to_call: Node? = nil
    public var arg_nodes: [Node]? = nil
    public var value: Float80? = nil
    public var name: String? = nil

    public var description: String {
        switch (self.node_type) {
            case .NumberNode: return "\(self.value!)"
            case .NameNode: return "\(self.name!)"
            case .PlusNode: return "(+ \(self.nodeA))"
            case .MinusNode: return "(- \(self.nodeA))"
            case .AddNode: return "(\(self.nodeA) + \(self.nodeB))"
            case .SubtractNode: return "(\(self.nodeA) - \(self.nodeB))"
            case .MultiplyNode: return "(\(self.nodeA) * \(self.nodeB))"
            case .DivideNode: return "(\(self.nodeA) / \(self.nodeB))"
            case .PowerNode: return "(\(self.nodeA) ^ \(self.nodeB))"
            case .AssignNode: return "(\(self.nodeA) = \(self.nodeB))"
            case .CallNode: return "\(self.node_to_call)(\(self.arg_nodes))"
            default: return "()"
        }
    }
    
    public init(_ node_type: NodeType, _ nodeA: Node, _ nodeB: Node) {
        self.node_type = node_type
        self.nodeA = nodeA
        self.nodeB = nodeB
    }
    
    public init(_ node_type: NodeType, _ node_to_call: Node, _ arg_nodes: [Node]) {
        self.node_type = node_type
        self.node_to_call = node_to_call
        self.arg_nodes = arg_nodes
    }
    
    public init(_ node_type: NodeType, _ nodeA: Node) {
        self.node_type = node_type
        self.nodeA = nodeA
    }
    
    public init(_ node_type: NodeType, _ value: Float80) {
        self.node_type = node_type
        self.value = value
    }
    
    public init(_ node_type: NodeType, _ name: String) {
        self.node_type = node_type
        self.name = name
    }
    
    public init(_ node_type: NodeType) {
        self.node_type = node_type
    }
}

public class Parser {
    public var tokens: [Token]
    public var index: Int
    public var current: Token {
        return tokens[index]
    }
    
    public init(_ tokens: [Token]) {
        self.tokens = tokens
        self.index = 0
    }
    
    public func advance() {
        self.index += 1
    }
    
    public func parse() throws -> Node {
        if(self.current.type == TokenType.EOF) {
            return Node(NodeType.EmptyNode)
        }
        
        var node: Node = try self.expr()
        
//        print(node, self.current)
        if(self.current.type != TokenType.EOF) {
            throw CalcError.SyntaxError
        }
        
        return node
    }

    public func expr() throws -> Node {
        return try self.assign()
    }
    
    public func assign() throws -> Node {
        var result: Node = try self.sum()

        if (self.current.type == TokenType.ASSIGN) {
            self.advance()
            result = Node(NodeType.AssignNode, result, try self.assign())
        }

        return result
    }
    
    public func sum() throws -> Node {
        var result: Node = try self.term()

        while (self.current.type != TokenType.EOF && (self.current.type == TokenType.PLUS || self.current.type == TokenType.MINUS)) {
            if (self.current.type == TokenType.PLUS) {
                self.advance()
                result = Node(NodeType.AddNode, result, try self.term())
            } else if (self.current.type == TokenType.MINUS) {
                self.advance()
                result = Node(NodeType.SubtractNode, result, try self.term())
            }
        }

        return result
    }

    
    public func term() throws -> Node {
        var result: Node = try self.exponent()

        while (self.current.type != TokenType.EOF && (self.current.type == TokenType.MULTIPLY || self.current.type == TokenType.DIVIDE)) {
            if (self.current.type == TokenType.MULTIPLY) {
                self.advance()
                result = Node(NodeType.MultiplyNode, result, try self.exponent())
            } else if (self.current.type == TokenType.DIVIDE) {
                self.advance()
                result = Node(NodeType.DivideNode, result, try self.exponent())
            }
        }

        return result
    }
    
    public func exponent() throws -> Node {
        var result: Node = try self.call()

        if (self.current.type == TokenType.POWER) {
            self.advance()
            result = Node(NodeType.PowerNode, result, try self.exponent())
        }

        return result
    }
    
    public func call() throws -> Node {
        var result: Node = try self.factor()

        while (self.current.type != TokenType.EOF && self.current.type == TokenType.LPAREN) {
            var arg_nodes: [Node] = []
            self.advance()
            
            if(self.current.type == TokenType.RPAREN) {
                self.advance()
                result = Node(NodeType.CallNode, result, arg_nodes)
                continue
            }
            

            arg_nodes.append(try self.expr())
                  
            if(self.current.type == TokenType.RPAREN) {
                self.advance()
                result = Node(NodeType.CallNode, result, arg_nodes)
                continue
            }
            
            while(self.current.type == TokenType.COMMA) {
                self.advance()
                arg_nodes.append(try self.expr())
            }
            
            result = Node(NodeType.CallNode, result, arg_nodes)
        }

        return result
    }

    public func factor() throws -> Node {
        var current_token: Token = self.current

        if (current_token.type == TokenType.LPAREN) {
            self.advance()
            var result: Node = try self.expr()

            if (self.current.type != TokenType.RPAREN) {
                throw CalcError.SyntaxError
            }

            self.advance()
            return result
        } else if (current_token.type == TokenType.NUMBER) {
            self.advance()
            return Node(NodeType.NumberNode, current_token.value!)
        } else if (current_token.type == TokenType.NAME) {
            self.advance()
            return Node(NodeType.NameNode, current_token.name!)
        } else if (current_token.type == TokenType.PLUS) {
            self.advance()
            return Node(NodeType.PlusNode, try self.factor())
        } else if (current_token.type == TokenType.MINUS) {
            self.advance()
            return Node(NodeType.MinusNode, try self.factor())
        }
        
        throw CalcError.SyntaxError
    }
}

public class Number: CustomStringConvertible {
    public var value: Float80
    public var description: String {
        return "\(self.value)"
    }
    
    public init(_ value: Float80) {
        self.value = value
    }
}

public class Interpreter {
    public var env: Env
    
    public init(_ env: Env) {
        self.env = env
    }
    
    public func visit(_ node: Node) throws -> Number {
        switch(node.node_type) {
            case .EmptyNode:
                return try self.visit_empty_node(node)
            case .NumberNode:
                return try self.visit_number_node(node)
            case .NameNode:
                return try self.visit_name_node(node)
            case .PlusNode:
                return try self.visit_plus_node(node)
            case .MinusNode:
                return try self.visit_minus_node(node)
            case .AddNode:
                return try self.visit_add_node(node)
            case .SubtractNode:
                return try self.visit_subtract_node(node)
            case .MultiplyNode:
                return try self.visit_multiply_node(node)
            case .DivideNode:
                return try self.visit_divide_node(node)
            case .PowerNode:
                return try self.visit_power_node(node)
            case .AssignNode:
                return try self.visit_assign_node(node)
            case .CallNode:
                return try self.visit_call_node(node)
            default:
                fatalError("Unknown node type")
        }
    }

    public func visit_empty_node(_ node: Node) throws -> Number {
        return Number(0.0)
    }
    
    public func visit_number_node(_ node: Node) throws -> Number {
        return Number(node.value!)
    }
    
    public func visit_name_node(_ node: Node) throws -> Number {
        return self.env[node.name!] ?? Number(0.0)
    }

    public func visit_plus_node(_ node: Node) throws -> Number {
        return Number(try +self.visit(node.nodeA!).value)
    }

    public func visit_minus_node(_ node: Node) throws -> Number {
        return Number(try -self.visit(node.nodeA!).value)
    }
    
    public func visit_add_node(_ node: Node) throws -> Number {
        return Number(try self.visit(node.nodeA!).value + self.visit(node.nodeB!).value)
    }

    public func visit_subtract_node(_ node: Node) throws -> Number {
        return Number(try self.visit(node.nodeA!).value - self.visit(node.nodeB!).value)
    }

    public func visit_multiply_node(_ node: Node) throws -> Number {
        return Number(try self.visit(node.nodeA!).value * self.visit(node.nodeB!).value)
    }

    public func visit_divide_node(_ node: Node) throws -> Number {
        return Number(try self.visit(node.nodeA!).value / self.visit(node.nodeB!).value)
    }
    
    public func visit_power_node(_ node: Node) throws -> Number {
        return Number(try pow(self.visit(node.nodeA!).value, self.visit(node.nodeB!).value))
    }
    
    public func visit_assign_node(_ node: Node) throws -> Number {
        if(node.nodeA!.node_type != NodeType.NameNode) {
            throw CalcError.RuntimeMathError
        }
        
        var value: Number = try self.visit(node.nodeB!)
        
        self.env.updateValue(value, forKey: node.nodeA!.name!)
                
        return value
    }
    
    public func visit_call_node(_ node: Node) throws -> Number {
        if(node.node_to_call!.node_type != NodeType.NameNode) {
            throw CalcError.RuntimeMathError
        }
        
        var arg0: Number = node.arg_nodes!.count <= 0 ? Number(0.0) : try self.visit(node.arg_nodes![0])

        var arg1: Number = node.arg_nodes!.count <= 1 ? Number(0.0) : try self.visit(node.arg_nodes![1])

        var arg2: Number = node.arg_nodes!.count <= 2 ? Number(0.0) : try self.visit(node.arg_nodes![2])

        var arg3: Number = node.arg_nodes!.count <= 3 ? Number(0.0) : try self.visit(node.arg_nodes![3])

        var arg4: Number = node.arg_nodes!.count <= 4 ? Number(0.0) : try self.visit(node.arg_nodes![4])
        
        switch node.node_to_call!.name {
            case "PI":
                return Number(Float80.pi)
            case "E":
                return Number(exp(Float80(1.0)))
            case "SIN":
                return Number(sin(arg0.value))
            case "COS":
                return Number(cos(arg0.value))
            case "TAN":
                return Number(tan(arg0.value))
            case "LOG":
                return Number(log(arg0.value))
            case "EXP":
                return Number(exp(arg0.value))
            case "SQRT":
                return Number(sqrt(arg0.value))
            case "RAND":
                return Number(Float80.random(in: 0...1))
            default:
                throw CalcError.RuntimeMathError
        }
    }
}

