{-# LANGUAGE NoMonomorphismRestriction #-}

import Diagrams.Backend.PGF
import Diagrams.Backend.PGF.CmdLine
import Diagrams.Prelude

box :: String -> Diagram PGF
box label =
  text label # fontSizeL 0.12
    <> roundedRect 2.4 0.72 0.08 # lwG 0.018

dia :: Diagram PGF
dia =
  hsep 0.8
    [ box "输入材料"
    , box "结构分析"
    , box "论文图示"
    ]
    # centerXY
    # pad 1.1

main :: IO ()
main = mainWith dia
