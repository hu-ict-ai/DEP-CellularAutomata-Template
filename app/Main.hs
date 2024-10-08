{-# LANGUAGE ScopedTypeVariables #-}

module Main where

import Lib
import Text.Read
import Data.Maybe (fromMaybe)
import Control.Exception
import Lib

data Colour = Reset | Red | Yellow | Green | Grey

instance Show Colour where
  show Reset = "\ESC[0m"
  show Red = "\ESC[31m"
  show Yellow = "\ESC[33m"
  show Green = "\ESC[32m"
  show Grey = "\ESC[1;30m"

colour :: Colour -> String -> String
colour c = (show c <>) . (<> show Reset)

successString :: String -> String
successString n = colour Green $ "Cool! Functie " ++ n ++ " werkt!"

incorrectString :: Show a => String -> a -> a -> String
incorrectString n r e = (colour Yellow $ "\nHet uitvoeren van " ++ n ++ " werkt nog niet...\n")
  <> "Je antwoord was " <> (colour Red $ show r)
  <> ", maar dit moest " <> (colour Green $ show e) <> " zijn.\n"

errorString :: String -> String
errorString n = colour Red $ "De functie " ++ n ++ " werkt nog niet, je error was:"

data ThreeCase x a b c = ThreeLeft x a | ThreeMiddle x b | ThreeRight x c

singleTest :: forall a. (Eq a, Show a) => String -> (a, a, String) -> IO (ThreeCase String SomeException (a, a) a)
singleTest funcname (given, expected, operationname) = do
  res <- try (evaluate $ given) :: IO (Either SomeException a)
  case res of
    Left error -> do return (ThreeLeft funcname error)
    Right value -> if value == expected then return (ThreeRight funcname value)
                                        else return (ThreeMiddle (funcname ++ " " ++ operationname) (value, expected))

lowestCase :: IO (ThreeCase x a b c) -> IO (ThreeCase x a b c) -> IO (ThreeCase x a b c)
lowestCase x y = do
  first <- x
  second <- y
  case (first, second) of
    (x@(ThreeLeft _ _), _)   -> return x
    (_, y@(ThreeLeft _ _))   -> return y
    (x@(ThreeMiddle _ _), _) -> return x
    (_, y@(ThreeMiddle _ _)) -> return y
    otherwise                -> return first

multiTest :: forall a. (Eq a, Show a) => String -> [(a, a, String)] -> IO()
multiTest fn l = do
  result <- foldl1 lowestCase $ map (singleTest fn) l
  case result of
    ThreeLeft s x -> do putStrLn $ errorString s
                        putStrLn $ colour Grey $ displayException x
                        putStrLn $ colour Reset ""
    ThreeMiddle s (x, y) -> putStrLn $ incorrectString s x y
    ThreeRight s x -> putStrLn $ successString s

-- Enkele waarden om de functies mee te testen:
tFLInt1 :: FocusList Int
tFLInt1 = FocusList [1,3,5,7,9] []

tFLInt2 :: FocusList Int
tFLInt2 = FocusList [13] [11,7,5,3,2]

tFLInt3 :: FocusList Int
tFLInt3 = FocusList [1,5,9,2] [4,1,3]

tLInt1 :: [Int]
tLInt1 = [0,1,2,3,4,5]

tLInt2 :: [Int]
tLInt2 = [1,3,5,7,9]

tLInt3 :: [Int]
tLInt3 = [2,3,5,7,11,13]

tFLString1 :: FocusList String
tFLString1 = FocusList ["1","3","5","7","9"] []

tFLString2 :: FocusList String
tFLString2 = FocusList ["13"] ["11","7","5","3","2"]

tFLString3 :: FocusList String
tFLString3 = FocusList ["1","5","9","2"] ["4","1","3"]

tFLString4 :: FocusList String
tFLString4 = FocusList [""] []

tFLNone :: FocusList a
tFLNone = FocusList [] []

tFLAut1 :: Automaton
tFLAut1 = FocusList [Alive, Alive] [Alive]

tFLAut2 :: Automaton
tFLAut2 = FocusList [Alive] []

tFLAut3 :: Automaton
tFLAut3 = FocusList [] []

tFLAut4 :: Automaton
tFLAut4 = FocusList [Alive, Dead] [Alive]

-- rLIF, "really Long Inputs Function", is een implementatie van inputs om mee te testen,
-- maar omdat je pluspunten kunt verdienen met een mooie implementatie, is die hier zo lang (en lelijk!) mogelijk.
rLIF :: [Context]
rLIF = [[Alive, Alive, Alive], [Alive, Alive, Dead], [Alive, Dead, Alive], [Alive, Dead, Dead], [Dead, Alive, Alive], [Dead, Alive, Dead], [Dead, Dead, Alive], [Dead, Dead, Dead]]

-- quickBin, "quickBinary", is een aparte functie die even snel een regel omzet naar een getal.
-- Ik raad je aan geen onderdelen van deze functie te gebruiken - hij is quick and dirty, alleen voor testdoeleinden.
quickBin :: Rule -> Int
quickBin x = foldl1 (+) $ zipWith (*) [128,64,32,16,8,4,2,1] $ map ((\y -> if y == Alive then 1 else 0) . x) rLIF

-- ftst, "full test"
ftst :: IO ()
ftst = do multiTest "toList" [((toList intVoorbeeld), [0,1,2,3,4,5], "intVoorbeeld"), 
                     ((toList tFLInt1), [1,3,5,7,9], "$ FocusList [1,3,5,7,9] []"),
                     ((toList tFLInt2), [2,3,5,7,11,13], "$ FocusList [13] [11,7,5,3,2]"),
                     ((toList tFLInt3), [3,1,4,1,5,9,2], "$ FocusList [1,5,9,2] [4,1,3]")]
          multiTest "fromList" [((fromList tLInt1), FocusList [0,1,2,3,4,5] [], "[0,1,2,3,4,5]"),
                     ((fromList tLInt2), FocusList [1,3,5,7,9] [], "[1,3,5,7,9]"),
                     ((fromList tLInt3), FocusList [2,3,5,7,11,13] [], "[2,3,5,7,11,13]")]
          multiTest "goRight" [((goRight intVoorbeeld), FocusList [4,5] [3,2,1,0], "intVoorbeeld"),
                     ((goRight tFLInt1), FocusList [3,5,7,9] [1], "$ FocusList [1,3,5,7,9] []"),
                     ((goRight tFLInt3), FocusList [5,9,2] [1,4,1,3], "$ FocusList [1,5,9,2] [4,1,3]")]
          multiTest "leftMost" [((leftMost intVoorbeeld), FocusList [0,1,2,3,4,5] [], "intVoorbeeld"),
                     ((leftMost tFLInt2), FocusList [2,3,5,7,11,13] [], "$ FocusList [13] [11,7,5,3,2]"),
                     ((leftMost tFLInt3), FocusList [3,1,4,1,5,9,2] [], "$ FocusList [1,5,9,2] [4,1,3]")]
          multiTest "rightMost" [((rightMost intVoorbeeld), FocusList [5] [4,3,2,1,0], "intVoorbeeld"),
                     ((rightMost tFLInt1), FocusList [9] [7,5,3,1], "$ FocusList [1,3,5,7,9] []"),
                     ((rightMost tFLInt3), FocusList [2] [9,5,1,4,1,3], "$ FocusList [1,5,9,2] [4,1,3]")]
          multiTest "totalLeft" [((totalLeft stringVoorbeeld), FocusList ["2","3","4","5"] ["1","0"], "stringVoorbeeld"),
                     ((totalLeft tFLString1), FocusList ["","1","3","5","7","9"] [], "$ FocusList [\"1\",\"3\",\"5\",\"7\",\"9\"] []"),
                     ((totalLeft tFLString4), FocusList ["",""] [], "$ FocusList [\"\"] []")]
          multiTest "totalRight" [((totalRight stringVoorbeeld), FocusList ["4","5"] ["3","2","1","0"], "stringVoorbeeld"),
                     ((totalRight tFLString2), FocusList [""] ["13","11","7","5","3","2"], "$ FocusList [\"13\"] [\"11\",\"7\",\"5\",\"3\",\"2\"]"),
                     ((totalRight tFLString4), FocusList [""] [""], "$ FocusList [\"\"] []")]
          multiTest "mapFocusList" [((mapFocusList (* 2) intVoorbeeld), FocusList [6,8,10] [4,2,0], "(* 2) intVoorbeeld"),
                     ((mapFocusList (+ 1) tFLInt3), FocusList [2,6,10,3] [5,2,4], "(+ 1) $ FocusList [1,5,9,2] [4,1,3]"),
                     ((mapFocusList (* 100) tFLNone), FocusList [] [], "(* 100) $ FocusList [] []")]
          multiTest "zipFocusListWith" [((zipFocusListWith (*) intVoorbeeld tFLInt3), FocusList [3,20,45] [8,1,0], "(*) intVoorbeeld $ FocusList [1,5,9,2] [4,1,3]"),
                     ((zipFocusListWith (-) tFLInt2 tFLInt3), FocusList [12] [7,6,2], "(-) (FocusList [13] [11,7,5,3,2]) $ FocusList [1,5,9,2] [4,1,3]"),
                     ((zipFocusListWith (+) tFLNone intVoorbeeld), FocusList [] [], "(+) (FocusList [] []) intVoorbeeld")]
          multiTest "{- deel 1, voor getallen -} foldFocusList" [((foldFocusList (+) intVoorbeeld), 15, "(+) intVoorbeeld"), 
                     ((foldFocusList (-) intVoorbeeld), 7, "(-) intVoorbeeld"),
                     ((foldFocusList (*) tFLInt1), 945, "(*) $ FocusList [1,3,5,7,9] []")]
          multiTest "{- deel 2, voor strings -} foldFocusList" [((foldFocusList (++) stringVoorbeeld), "012345", "(++) stringVoorbeeld")]
          multiTest "safeHead" [((safeHead 0 tLInt3), 2, "0 [2,3,5,7,11,13]"),
                     ((safeHead 1 []), 1, "1 []")]
          multiTest "takeAtLeast" [((takeAtLeast 3 0 tLInt3), [2,3,5], "3 0 [2,3,5,7,11,13]"),
                     ((takeAtLeast 4 1 [2,3]), [2,3,1,1], "4 1 [2,3]"),
                     ((takeAtLeast 5 2 []), [2,2,2,2,2], "5 2 []")]
          multiTest "context" [((context tFLAut1), [Alive, Alive, Alive], "$ FocusList [Alive, Alive] [Alive]"),
                     ((context tFLAut2), [Dead, Alive, Dead], "$ FocusList [Alive] []"),
                     ((context tFLAut3), [Dead, Dead, Dead], "$ FocusList [] []"),
                     ((context tFLAut4), [Alive, Alive, Dead], "$ FocusList [Alive, Dead] [Alive]")]
          multiTest "expand" [((expand tFLAut1), FocusList [Alive, Alive, Dead] [Alive, Dead], "$ FocusList [Alive, Alive] [Alive]"), -- 05 expand
                     ((expand tFLAut2), FocusList [Alive, Dead] [Dead], "$ FocusList [Alive] []"),
                     ((expand tFLAut3), FocusList [Dead] [Dead], "$ FocusList [] []"),
                     ((expand tFLAut4), FocusList [Alive, Dead, Dead] [Alive, Dead], "$ FocusList [Alive, Dead] [Alive]")]
          multiTest "rule30" [(quickBin rule30, 30, "omzetten naar een integer")]
          multiTest "inputs" [((and (map (\x -> elem x inputs) rLIF) && and (map (\x -> elem x rLIF) inputs)), True, "- een check of alle nodige waarden in inputs zitten")]
          multiTest "volgorde inputs (OPTIONEEL) werkt nog niet... " [(inputs, rLIF, "Door de inputs op de zelfde volgorde terug te geven als op de Wolfram pagina maak je het jezelf bij \"rule\" een stuk makkelijker. Je functie werkt maar de optionele test")]
          multiTest "mask" [((Lib.mask [True, False, True, True, False] tLInt2), [1,5,7], "[True, False, True, True, False] [1,3,5,7,9]"),
                     ((Lib.mask [True, True] tLInt1), [0,1], "[True, True] [0,1,2,3,4,5]"),
                     ((Lib.mask [True, False, True, True, False] []), [], "[True, False, True, True, False] []")]
          multiTest "rule" [((quickBin $ rule 94), 94, "94 meegeven en het resultaat weer omzetten naar een integer"),
                     ((quickBin $ rule 182), 182, "182 meegeven en het resultaat weer omzetten naar een integer"),
                     ((quickBin $ rule 220), 220, "220 meegeven en het resultaat weer omzetten naar een integer")]

draw :: IO ()
draw = do putStrLn "Geef het getal van de gewenste rule? [18]"
          nr <- fromMaybe 18 . readMaybe <$> getLine
          putStrLn "Geef het gewenste aantal iteraties? [15]"
          n <- fromMaybe 15 . readMaybe <$> getLine
          putStrLn $ showPyramid $ iterateRule (rule nr) n start

main :: IO ()
main = do putStrLn "Wil je je code laten testen (t), een piramide tekenen (d) of stoppen (q)?"
          choice <- getLine
          case choice of
            "t"       -> do ftst
                            main
            "d"       -> do draw
                            main
            "q"       -> return ()
            otherwise -> main
