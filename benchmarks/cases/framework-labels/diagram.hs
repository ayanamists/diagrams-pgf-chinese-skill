import Diagrams.Backend.PGF
import Diagrams.Backend.PGF.CmdLine
import Diagrams.Prelude

card :: String -> Diagram PGF
card label =
  text label # fontSizeL 0.16 # fc black
  <> roundedRect 3.6 0.7 0.06
       # lwG 0.015
       # lc (sRGB24read "#5F574C")
       # fc (sRGB24read "#F8F5EC")

dia :: Diagram PGF
dia =
  vsep 0.22
    [ card "孤独体验"
    , card "社会支持感知"
    , card "AI 角色层"
    , card "社会工作介入策略"
    ]
  # centerXY

main :: IO ()
main = mainWith dia
