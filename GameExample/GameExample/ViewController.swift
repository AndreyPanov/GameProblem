import UIKit

class ViewController: UIViewController {

  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
  }

  func configureGrid() {
    
  }

}

// grid 6x7
// 4 steps to win
// only first player could win
protocol GameHandler {
  
  func player1Set(r: Int, c: Int) -> Bool
  func player2Set(r: Int, c: Int) -> Bool
}

enum GameState {
  case none, player1, player2
}

class GameHandlerImp {
  
  var grid: [[GameState]]
  
  init() {
    self.grid = Array(repeating: Array(repeating: GameState.none, count: 7), count: 6)
  }
  
  func player1Set(r: Int, c: Int) -> Bool {
    grid[r][c] = .player1
    return checkState()
  }
  
  func player2Set(r: Int, c: Int) -> Bool {
    grid[r][c] = .player2
    return checkState()
  }
  
  // finished and not finished
  private func checkState() -> Bool {
    
    for r in 0..<grid.count {
      var gameStateAssamption: GameState = .none
      for c in 0..<grid.first!.count {
        if grid[r][c] == .none {
          return false
        }
        if c == 0 {
          gameStateAssamption = grid[r][c]
        }
         else if grid[r][c] == .player1 {
          if grid[r][c] != gameStateAssamption {
            return false
          }
        } else if grid[r][c] == .player2 {
          if grid[r][c] != gameStateAssamption {
            return false
          }
        }
      }
    }
    for r in 0..<grid.first!.count {
      var gameStateAssamption: GameState = .none
      for c in 0..<grid.count {
        if grid[c][r] == .none {
          return false
        }
        if c == 0 {
          gameStateAssamption = grid[c][r]
        }
        else if grid[c][r] == .player1 {
          if grid[c][r] != gameStateAssamption {
            return false
          }
        } else if grid[c][r] == .player2 {
          if grid[c][r] != gameStateAssamption {
            return false
          }
        }
      }
    }
    return true
  }
}
