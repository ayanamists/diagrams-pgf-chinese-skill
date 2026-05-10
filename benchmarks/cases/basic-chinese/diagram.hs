import Diagrams.Backend.PGF
import Diagrams.Backend.PGF.CmdLine
import Diagrams.Prelude

dia :: Diagram PGF
dia =
  text "汉字测试" # fontSizeL 0.24 # fc black
  <> roundedRect 2.8 0.8 0.08 # lwG 0.02 # lc black

main :: IO ()
main = mainWith dia
