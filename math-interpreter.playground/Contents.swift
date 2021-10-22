import UIKit
import Foundation

public enum CalcError: LocalizedError {
    case LexicalError
    case SyntaxError
    case RuntimeMathError
}

public enum TokenType {
    case NUMBER
    case PLUS
    case MINUS
    case MULTIPLY
    case DIVIDE
    case LPAREN
    case RPAREN
    case POWER
    case EOF
}

public class Token: CustomStringConvertible {
    public var type: TokenType
    public var value: Float80? = nil
    
    public var description: String {
        get {
            var s: String = "\(self.type)"
         
            if(self.type == TokenType.NUMBER) {
                s += ":\(self.value!)"
            }
        
            return s
        }
    }
    
    public init(_ type: TokenType, _ value: Float80? = nil) {
        self.type = type
        self.value = value
    }
}

public class Lexer {
    public static let WHITESPACE: String = " \n\t"
    public static let DIGITS: String = "0123456789"

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
}

public enum NodeType {
    case PlusNode
    case MinusNode
    case EmptyNode
    case NumberNode
    case AddNode
    case SubtractNode
    case MultiplyNode
    case DivideNode
    case PowerNode
}

public class Node: CustomStringConvertible {
    public var node_type: NodeType
    public var nodeA: Node? = nil
    public var nodeB: Node? = nil
    public var value: Float80? = nil
    
    public var description: String {
        switch (self.node_type) {
            case .NumberNode: return "\(self.value!)"
            case .PlusNode: return "(+ \(self.nodeA))"
            case .MinusNode: return "(- \(self.nodeA))"
            case .AddNode: return "(\(self.nodeA) + \(self.nodeB))"
            case .SubtractNode: return "(\(self.nodeA) - \(self.nodeB))"
            case .MultiplyNode: return "(\(self.nodeA) * \(self.nodeB))"
            case .DivideNode: return "(\(self.nodeA) / \(self.nodeB))"
            case .PowerNode: return "(\(self.nodeA) ^ \(self.nodeB))"
            default: return "()"
        }
    }
    
    public init(_ node_type: NodeType, _ nodeA: Node, _ nodeB: Node) {
        self.node_type = node_type
        self.nodeA = nodeA
        self.nodeB = nodeB
    }
    
    public init(_ node_type: NodeType, _ nodeA: Node) {
        self.node_type = node_type
        self.nodeA = nodeA
    }
    
    public init(_ node_type: NodeType, _ value: Float80) {
        self.node_type = node_type
        self.value = value
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
        
        if(self.current.type != TokenType.EOF) {
            throw CalcError.SyntaxError
        }
        
        return node
    }
    
    public func expr() throws -> Node {
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
        var result: Node = try self.factor()

        while (self.current.type != TokenType.EOF && (self.current.type == TokenType.POWER)) {
            if (self.current.type == TokenType.POWER) {
                self.advance()
                result = Node(NodeType.PowerNode, result, try self.factor())
            }
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
    public func visit(_ node: Node) throws -> Number {
        switch(node.node_type) {
            case .NumberNode:
                return try self.visit_number_node(node)
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
            default:
                fatalError("Unknown node type")
        }
    }
    
    public func visit_number_node(_ node: Node) throws -> Number {
        return Number(node.value!)
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
}


func main() {
    var text: String = "10^1000"
    
    do {
        var lexer: Lexer = Lexer(text)
        var tokens: [Token] = try lexer.get_tokens()
        
        var parser: Parser = Parser(tokens)
        var tree: Node = try parser.parse()
        
        var interpreter: Interpreter = Interpreter()
        var value: Number = try interpreter.visit(tree)

        print(value)
    } catch {
        print(error.localizedDescription)
    }
    
}

main()
