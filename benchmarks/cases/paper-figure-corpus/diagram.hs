{-# LANGUAGE FlexibleContexts #-}
{-# LANGUAGE NoMonomorphismRestriction #-}
{-# LANGUAGE TypeFamilies #-}

import Diagrams.Backend.PGF
import Diagrams.Backend.PGF.CmdLine
import Diagrams.Prelude hiding (D, arrow, frame)

type D = Diagram PGF

ink, muted, lineC, paper, fillA, fillB, fillC, fillD, fillE :: Colour Double
ink = sRGB24read "#25211D"
muted = sRGB24read "#6F675E"
lineC = sRGB24read "#756D62"
paper = sRGB24read "#FFFFFF"
fillA = sRGB24read "#FBF8F1"
fillB = sRGB24read "#EFE7D5"
fillC = sRGB24read "#D9CBA8"
fillD = sRGB24read "#F5F7FA"
fillE = sRGB24read "#E7F0EA"

txt :: Double -> String -> D
txt size value = text value # fontSizeL size # fc ink

mutedTxt :: Double -> String -> D
mutedTxt size value = text value # fontSizeL size # fc muted

nodeBox :: Double -> Double -> String -> D
nodeBox w h value =
  txt 0.088 value
    <> roundedRect w h 0.035 # lwG 0.005 # lc lineC # fc fillA

node2 :: Double -> Double -> String -> String -> D
node2 w h top bottom =
  (txt 0.086 top # translateY 0.045)
    <> (mutedTxt 0.068 bottom # translateY (-0.060))
    <> roundedRect w h 0.035 # lwG 0.005 # lc lineC # fc fillB

diamond :: String -> D
diamond value =
  txt 0.074 value
    <> square 0.42 # rotateBy (1/8) # lwG 0.005 # lc lineC # fc fillD

circleNode :: Double -> String -> D
circleNode r value =
  txt 0.080 value
    <> circle r # lwG 0.005 # lc lineC # fc fillE

arrH :: Double -> D
arrH len =
  arrowBetween' (with & headLength .~ local 0.050
                      & shaftStyle %~ lwG 0.004
                      & headStyle %~ fc lineC . lc lineC)
                (p2 (-len / 2, 0)) (p2 (len / 2, 0))
  # lc lineC

arrV :: Double -> D
arrV len =
  arrowBetween' (with & headLength .~ local 0.050
                      & shaftStyle %~ lwG 0.004
                      & headStyle %~ fc lineC . lc lineC)
                (p2 (0, len / 2)) (p2 (0, -len / 2))
  # lc lineC

connectorH :: Double -> D
connectorH len = hrule len # lwG 0.004 # lc lineC

connectorV :: Double -> D
connectorV len = vrule len # lwG 0.004 # lc lineC

panel :: String -> String -> D -> D
panel title subtitle body =
  (txt 0.096 title # bold # translateY 0.765)
    <> (mutedTxt 0.066 subtitle # translateY 0.620)
    <> (body # translateY (-0.060))
    <> roundedRect 3.15 1.80 0.045 # lwG 0.005 # lc lineC # fc paper

chainH :: [D] -> D
chainH [] = mempty
chainH [x] = x
chainH (x:xs) = hsep 0.105 (go (x:xs))
  where
    go [] = []
    go [y] = [y]
    go (y:ys) = y : arrH 0.155 : go ys

chainV :: [D] -> D
chainV [] = mempty
chainV [x] = x
chainV (x:xs) = vsep 0.075 (go (x:xs))
  where
    go [] = []
    go [y] = [y]
    go (y:ys) = y : arrV 0.170 : go ys

paper01 :: D
paper01 =
  panel "P01 egg" "[PL] 等式饱和"
    (mconcat
      [ nodeBox 0.62 0.25 "Expr" # translate (r2 (-0.86, 0.28))
      , nodeBox 0.64 0.25 "E-graph" # translate (r2 (0, 0.28))
      , nodeBox 0.60 0.25 "Extract" # translate (r2 (0.86, 0.28))
      , arrH 0.28 # translate (r2 (-0.43, 0.28))
      , arrH 0.28 # translate (r2 (0.43, 0.28))
      , node2 0.72 0.30 "Rewrite" "rules" # translate (r2 (-0.42, -0.42))
      , node2 0.72 0.30 "Analysis" "merge" # translate (r2 (0.42, -0.42))
      , connectorH 0.84 # translateY (-0.42)
      ])

paper02 :: D
paper02 =
  panel "P02 Build Systems" "[PL] 依赖图"
    (mconcat
      [ nodeBox 0.50 0.23 "A" # translate (r2 (-0.86, 0.34))
      , nodeBox 0.50 0.23 "B" # translate (r2 (0.00, 0.34))
      , nodeBox 0.50 0.23 "C" # translate (r2 (0.86, 0.34))
      , nodeBox 0.58 0.23 "Task" # translate (r2 (-0.42, -0.34))
      , nodeBox 0.58 0.23 "Store" # translate (r2 (0.42, -0.34))
      , arrH 0.30 # translate (r2 (-0.43, 0.34))
      , arrH 0.30 # translate (r2 (0.43, 0.34))
      , arrH 0.30 # translate (r2 (0, -0.34))
      , mutedTxt 0.064 "scheduler / rebuilder" # translateY (-0.72)
      ])

paper03 :: D
paper03 =
  panel "P03 MLIR" "[PL] 多层 IR"
    (vsep 0.065
      [ node2 1.20 0.25 "Dialect" "Tensor"
      , node2 1.20 0.25 "Dialect" "Affine"
      , node2 1.20 0.25 "Dialect" "LLVM"
      , node2 1.20 0.25 "Codegen" "lowering"
      ])

paper04 :: D
paper04 =
  panel "P04 LLVM" "[PL] 编译器流水线"
    (chainH
      [ nodeBox 0.52 0.25 "C/C++"
      , nodeBox 0.56 0.25 "IR"
      , nodeBox 0.62 0.25 "Opt"
      , nodeBox 0.60 0.25 "Target"
      ]
     <> mutedTxt 0.064 "front end - optimizer - back end" # translateY (-0.52))

paper05 :: D
paper05 =
  panel "P05 Transformer" "注意力架构"
    (mconcat
      [ node2 0.78 0.28 "Encoder" "N layers" # translate (r2 (-0.52, 0.18))
      , node2 0.78 0.28 "Decoder" "N layers" # translate (r2 (0.52, 0.18))
      , arrH 0.32 # translateY 0.18
      , nodeBox 0.62 0.23 "Input" # translate (r2 (-0.52, -0.38))
      , nodeBox 0.62 0.23 "Output" # translate (r2 (0.52, -0.38))
      , arrV 0.22 # translate (r2 (-0.52, -0.12))
      , arrV 0.22 # translate (r2 (0.52, -0.12))
      ])

paper06 :: D
paper06 =
  panel "P06 ResNet" "残差块"
    (mconcat
      [ nodeBox 0.54 0.24 "x" # translate (r2 (-0.94, 0.02))
      , nodeBox 0.64 0.24 "Conv" # translate (r2 (-0.22, 0.02))
      , nodeBox 0.64 0.24 "Conv" # translate (r2 (0.50, 0.02))
      , nodeBox 0.48 0.24 "+" # translate (r2 (1.15, 0.02))
      , arrH 0.22 # translate (r2 (-0.58, 0.02))
      , arrH 0.22 # translate (r2 (0.14, 0.02))
      , arrH 0.20 # translate (r2 (0.83, 0.02))
      , connectorV 0.50 # translate (r2 (-0.94, 0.37))
      , connectorH 2.09 # translate (r2 (0.10, 0.62))
      , connectorV 0.45 # translate (r2 (1.15, 0.38))
      , mutedTxt 0.064 "identity skip" # translateY (-0.50)
      ])

paper07 :: D
paper07 =
  panel "P07 U-Net" "编码-解码"
    (mconcat
      [ nodeBox 0.50 0.22 "64" # translate (r2 (-0.92, 0.38))
      , nodeBox 0.50 0.22 "128" # translate (r2 (-0.46, 0.04))
      , nodeBox 0.50 0.22 "256" # translate (r2 (0, -0.30))
      , nodeBox 0.50 0.22 "128" # translate (r2 (0.46, 0.04))
      , nodeBox 0.50 0.22 "64" # translate (r2 (0.92, 0.38))
      , arrH 0.18 # rotateBy (-1/10) # translate (r2 (-0.70, 0.22))
      , arrH 0.18 # rotateBy (-1/10) # translate (r2 (-0.24, -0.14))
      , arrH 0.18 # rotateBy (1/10) # translate (r2 (0.24, -0.14))
      , arrH 0.18 # rotateBy (1/10) # translate (r2 (0.70, 0.22))
      , connectorH 1.35 # translateY 0.38
      ])

paper08 :: D
paper08 =
  panel "P08 BERT" "预训练任务"
    (mconcat
      [ nodeBox 0.70 0.25 "Tokens" # translate (r2 (-0.78, 0.25))
      , nodeBox 0.74 0.25 "Encoder" # translate (r2 (0, 0.25))
      , hsep 0.18 [node2 0.66 0.28 "MLM" "mask", node2 0.66 0.28 "NSP" "pair"] # translateY (-0.36)
      , arrH 0.25 # translate (r2 (-0.39, 0.25))
      , arrV 0.28 # translate (r2 (-0.20, -0.03))
      , arrV 0.28 # translate (r2 (0.20, -0.03))
      ])

paper09 :: D
paper09 =
  panel "P09 AlphaFold" "结构预测"
    (chainV
      [ node2 1.18 0.24 "Sequence" "MSA / templates"
      , node2 1.18 0.24 "Evoformer" "pair update"
      , node2 1.18 0.24 "Structure" "3D output"
      ])

paper10 :: D
paper10 =
  panel "P10 MapReduce" "分布式执行"
    (mconcat
      [ nodeBox 0.58 0.23 "Input" # translate (r2 (-1.04, 0.32))
      , nodeBox 0.58 0.23 "Map" # translate (r2 (-0.36, 0.32))
      , nodeBox 0.64 0.23 "Shuffle" # translate (r2 (0.36, 0.32))
      , nodeBox 0.58 0.23 "Reduce" # translate (r2 (1.05, 0.32))
      , nodeBox 0.70 0.23 "Master" # translateY (-0.35)
      , arrH 0.20 # translate (r2 (-0.70, 0.32))
      , arrH 0.20 # translate (r2 (0.00, 0.32))
      , arrH 0.20 # translate (r2 (0.70, 0.32))
      , connectorV 0.38 # translateY (-0.02)
      ])

paper11 :: D
paper11 =
  panel "P11 Raft" "状态机"
    (mconcat
      [ circleNode 0.25 "Follower" # translate (r2 (-0.75, 0.15))
      , circleNode 0.25 "Candidate" # translate (r2 (0.10, 0.15))
      , circleNode 0.25 "Leader" # translate (r2 (0.90, 0.15))
      , arrH 0.27 # translate (r2 (-0.32, 0.15))
      , arrH 0.27 # translate (r2 (0.50, 0.15))
      , mutedTxt 0.064 "timeout / vote / heartbeat" # translateY (-0.48)
      ])

paper12 :: D
paper12 =
  panel "P12 D3" "数据驱动文档"
    (chainH
      [ nodeBox 0.52 0.25 "Data"
      , nodeBox 0.50 0.25 "Join"
      , nodeBox 0.50 0.25 "DOM"
      , nodeBox 0.54 0.25 "View"
      ]
     <> mutedTxt 0.064 "enter - update - exit" # translateY (-0.52))

paper13 :: D
paper13 =
  panel "P13 PRISMA 2020" "综述流程"
    (chainV
      [ node2 1.08 0.22 "Identification" "records"
      , node2 1.08 0.22 "Screening" "excluded"
      , node2 1.08 0.22 "Included" "studies"
      ]
     <> nodeBox 0.68 0.22 "Reasons" # translate (r2 (0.88, -0.10)))

paper14 :: D
paper14 =
  panel "P14 CONSORT 2010" "试验报告"
    (chainV
      [ nodeBox 1.02 0.22 "Assessed"
      , nodeBox 1.02 0.22 "Randomized"
      , nodeBox 1.02 0.22 "Analyzed"
      ]
     <> hsep 0.12 [nodeBox 0.55 0.20 "Arm A", nodeBox 0.55 0.20 "Arm B"] # translateY (-0.12))

paper15 :: D
paper15 =
  panel "P15 EBM-DPSER" "因果链"
    (chainH
      [ nodeBox 0.50 0.24 "Driver"
      , nodeBox 0.56 0.24 "Pressure"
      , nodeBox 0.45 0.24 "State"
      , nodeBox 0.58 0.24 "Response"
      ]
     <> mutedTxt 0.064 "ecosystem services feedback" # translateY (-0.52))

paper16 :: D
paper16 =
  panel "P16 EGT" "三元模型"
    (mconcat
      [ nodeBox 0.72 0.25 "Seeing" # translate (r2 (0, 0.48))
      , nodeBox 0.72 0.25 "Feeling" # translate (r2 (-0.78, -0.28))
      , nodeBox 0.72 0.25 "Doing" # translate (r2 (0.78, -0.28))
      , node2 0.74 0.28 "Technology" "use"
      , connectorH 1.20 # translateY (-0.28)
      , connectorV 0.52 # translateY 0.16
      ])

paper17 :: D
paper17 =
  panel "P17 WASH" "实施科学"
    (chainH
      [ node2 0.58 0.30 "Interv." "strategy"
      , node2 0.60 0.30 "Barriers" "context"
      , node2 0.68 0.30 "Impl." "outcomes"
      , node2 0.58 0.30 "Impact" "health"
      ])

paper18 :: D
paper18 =
  panel "P18 DTx RWE" "证据生命周期"
    (chainH
      [ nodeBox 0.44 0.23 "Design"
      , diamond "Review"
      , nodeBox 0.48 0.23 "Test"
      , diamond "Scale"
      , nodeBox 0.50 0.23 "Monitor"
      ])

paper19 :: D
paper19 =
  panel "P19 UFIT" "以用户为中心"
    (mconcat
      [ circleNode 0.29 "User"
      , nodeBox 0.56 0.22 "UCD" # translate (r2 (0, 0.54))
      , nodeBox 0.56 0.22 "HFE" # translate (r2 (-0.74, -0.24))
      , nodeBox 0.62 0.22 "CFIR" # translate (r2 (0.74, -0.24))
      , connectorV 0.28 # translateY 0.31
      , connectorH 1.10 # translateY (-0.24)
      ])

paper20 :: D
paper20 =
  panel "P20 NASSS" "多域框架"
    (mconcat
      [ node2 0.94 0.30 "Scale-up" "spread sustain"
      , hsep 0.07 [nodeBox 0.52 0.20 "Condition", nodeBox 0.58 0.20 "Tech", nodeBox 0.44 0.20 "Value"] # translateY 0.49
      , hsep 0.07 [nodeBox 0.52 0.20 "Adopter", nodeBox 0.68 0.20 "Org"] # translateY (-0.47)
      , nodeBox 0.58 0.20 "System" # translate (r2 (-0.95, 0))
      , nodeBox 0.44 0.20 "Time" # translate (r2 (0.95, 0))
      ])

dia :: D
dia =
  vsep 0.16
    [ hsep 0.16 [paper01, paper02, paper03, paper04]
    , hsep 0.16 [paper05, paper06, paper07, paper08]
    , hsep 0.16 [paper09, paper10, paper11, paper12]
    , hsep 0.16 [paper13, paper14, paper15, paper16]
    , hsep 0.16 [paper17, paper18, paper19, paper20]
    ]
  # centerXY
  # pad 1.02

main :: IO ()
main = mainWith dia
