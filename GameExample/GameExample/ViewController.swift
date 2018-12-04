import UIKit

protocol GameView: class {
  func paintInPlayer1(with number: Int) // red
  func paintInPlayer2(with number: Int) // black
  func showWin(with message: String) // Player1 is win!
  func refreshTheGrid()
}

class ViewController: UIViewController, GameView {
  
  @IBOutlet var steps: [UIView]!
  var presenter: GamePresenter!

  override func viewDidLoad() {
    super.viewDidLoad()
    
    configure()
  }

  func configure() {
    
    for i in 0..<steps.count {
      let step = steps[i]
      step.tag = i+10
      let recognizer: UITapGestureRecognizer = .init(target: self, action: #selector(stepTapped(_:)))
      step.addGestureRecognizer(recognizer)
      step.backgroundColor = .gray
    }
  }
  
  func stepTapped(sender: UIButton) {
    presenter.onButtonTapped(with: sender.tag-10)
  }
  
  func paintInPlayer1(with number: Int) {
    let step = steps.first(where: { $0.tag == number })
    step?.backgroundColor = .red
  }
  func paintInPlayer2(with number: Int) {
    let step = steps.first(where: { $0.tag == number })
    step?.backgroundColor = .black
  }
  func showWin(with message: String) {
    let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
    present(alert, animated: true) {
      self.presenter.onGameEnded()
    }
  }
  func refreshTheGrid() {
    steps.forEach {
      $0.backgroundColor = .gray
    }
  }
}


class GamePresenter {
  unowned let view: GameView
  let game: GameHandler
  private var isPlayer1Turn = false
  
  init(view: GameView, game: GameHandler = GameHandlerImp()) {
    self.view = view
    self.game = game
  }
  
  func onButtonTapped(with number: Int) {
    let rc = rowAndColums(with: number)
    if isPlayer1Turn {
      if game.player1Set(r: rc.r, c: rc.c) {
        view.showWin(with: "Player1 is win!")
      }
    } else {
      if game.player2Set(r: rc.r, c: rc.c) {
        view.showWin(with: "Player2 is win!")
      }
    }
    isPlayer1Turn = !isPlayer1Turn
  }
  
  func onGameEnded() {
    view.refreshTheGrid()
  }
  
  private func rowAndColums(with number: Int) -> (r: Int, c: Int) {
    return (7/number, 6%number)
  }
}

// grid 7x6
// 4 steps to win
// only first player could win
protocol GameHandler {
  
  func player1Set(r: Int, c: Int) -> Bool
  func player2Set(r: Int, c: Int) -> Bool
}

enum GameState {
  case none, player1, player2
}

class GameHandlerImp: GameHandler {
  
  var grid: [[GameState]]
  
  init() {
    self.grid = Array(repeating: Array(repeating: GameState.none, count: 7), count: 6)
  }
  
  func player1Set(r: Int, c: Int) -> Bool {
    grid[r][c] = .player1
    if lessThen4Steps {
      
    }
    return checkState(for: .player1)
  }
  
  func player2Set(r: Int, c: Int) -> Bool {
    grid[r][c] = .player2
    return checkState(for: .player2)
  }
  
  // finished and not finished
  private func checkState(for player: GameState) -> Bool {
    
    //  red black red red red red
    
    for r in 0..<grid.count {
      var playerStepsCount: Int = 0
      for c in 0..<grid.first!.count {
        if grid[r][c] == player {
          playerStepsCount += 1
        }
        if playerStepsCount == 4 {
          return true
        }
        if playerStepsCount > 0 && grid[r][c] != player {
          playerStepsCount = 0
        }
      }
    }
    /*
    
    
    for r in 0..<grid.first!.count {
      var gameStateAssamption: GameState = .none
      for c in 0..<grid.count {
        if grid[c][r] == .none {
          return false
        }
        if c == 0 {
          gameStateAssamption = grid[c][r]
        }
        else if grid[c][r] == player {
          if grid[c][r] != gameStateAssamption {
            return false
          }
        }
      }
    }
    
    for row in 0..<grid.count {
      for column in  0..<grid.first!.count {
        if row == 0 || column == 0 {
          var rr = row + 1
          var cc = column + 1
          while rr < grid.count && cc < grid[rr].count {
            if grid[row][column] != grid[rr][cc] {
              return false
            }
            rr += 1
            cc += 1
          }
        }
      }
    }*/
    return true
  }
}
