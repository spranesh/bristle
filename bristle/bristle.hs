-- Convert from really simple markup to latex beamer
-- Pranesh Srinivasan
-- June 17th 2010
--
-- First Three lines in Order are
--  Title
--  Author
--  Date
-- Each line must start with a percentage
--
-- Markup symbols:
--  #  Title - of a frame
--  #* Title of a Fragile Frame
--  ## End Frame
--  
--  (( (start of itemize)
--  )) (end of itemize)
--  [[ (start of enumeration)
--  ]] (end of enumeration)
--  *  point in itemize/enumeration
--  {{ (start of verbatim)
--  }} (end of verbatim)
--  
--  !! (pause)
--  C( (begin center)
--  C) (end center)
--
--  S# (section)

type LaTeX = String

translate :: String -> [LaTeX]
translate ('%':xs)     = [lId xs]
translate ('#':'#':xs) = [lCommand "end" "frame" ""]
translate ('#':'*':xs) = [lCommand "begin" "frame" "fragile",  lCommand "frametitle" (removeStartingSpaces xs) ""]
translate ('#':xs)     = [lCommand "begin" "frame" "",  lCommand "frametitle" (removeStartingSpaces xs) ""]

translate ('(':'(':xs) = [lCommand "begin" "itemize"   "" ++ " " ++ lId xs]
translate ('[':'[':xs) = [lCommand "begin" "enumerate" "" ++ " " ++ lId xs]
translate ('{':'{':xs) = [lCommand "begin" "verbatim"  "" ++ " " ++ lId xs]
translate (')':')':xs) = [lCommand "end"   "itemize"   "" ++ " " ++ lId xs]
translate (']':']':xs) = [lCommand "end"   "enumerate" "" ++ " " ++ lId xs]
translate ('}':'}':xs) = [lCommand "end"   "verbatim"  "" ++ " " ++ lId xs]

translate ('C':'(':xs) = [lCommand "begin"   "center"    "" ++ " " ++ lId xs]
translate ('C':')':xs) = [lCommand "end"     "center"    "" ++ " " ++ lId xs]

translate ('S':'#':xs) = [lCommand "section" (removeStartingSpaces xs)  ""]

translate ('!':'!':xs) = [lCommand "pause" ""  "" ++ " " ++ lId (removeStartingSpaces xs)]

translate ('*':xs) = [lCommand "item" "" "" ++ " " ++ lId (removeStartingSpaces xs)]

translate xs     = [lId xs]


splitStartingSpaces :: String -> (String, String)
splitStartingSpaces = span (\x -> (x == ' ') || (x == '\t'))


removeStartingSpaces :: String -> String
removeStartingSpaces = snd . splitStartingSpaces


backslash = "\\"

-- takes command name, optional parameter, optional box parameter, and returns
-- the latex command
lCommand :: String -> String -> String -> LaTeX
lCommand "" _  _ = error "Empty latex command"
lCommand c "" "" = backslash ++ c
lCommand c p ""  = backslash ++ c ++ "{" ++ p ++ "}"
lCommand c "" b  = backslash ++ c ++ "[" ++ b ++ "]"
lCommand c p  b  = backslash ++ c ++ "{" ++ p ++ "}"  ++ "[" ++ b ++ "]" 

lId :: String -> LaTeX
lId s = s

lNewline :: LaTeX
lNewline = lId "\n"

lConcat :: [LaTeX] -> LaTeX
lConcat = concat


beamer :: String -> [LaTeX]
beamer s = [lId spaces] ++ translate rest where
      (spaces, rest) = splitStartingSpaces s


assert :: (Show a) => (a -> Bool) -> a -> a
assert f a = if f a then a else error (show a)

startsWith :: Char -> String -> Bool
startsWith c s = head s == c

makeTitle :: String -> String -> String -> [LaTeX]
makeTitle title author date = [lCommand "title"  (removeStartingSpaces . tail . assert (startsWith '%') $ title)  ""
                              ,lCommand "author" (removeStartingSpaces . tail . assert (startsWith '%') $ author) ""
                              ,lCommand "date"   (removeStartingSpaces . tail . assert (startsWith '%') $ date)   ""]


makeHeader :: [LaTeX]
makeHeader = [lCommand "documentclass" "beamer"           ""
             ,lCommand "usepackage"    "graphicx"         ""
             ,lCommand "usepackage"    "beamerthemesplit" ""
             ,lCommand "usetheme"      "Warsaw"           ""]


beginDocument, endDocument :: [LaTeX]
beginDocument = [lCommand "begin" "document" ""]
endDocument   = [lCommand "end" "document" ""]



latexify :: String -> [LaTeX]
latexify s = header ++ document ++ end where
    header     = makeHeader ++ (makeTitle title author date) ++ beginDocument ++ titleFrame
    titleFrame = [lCommand "frame" (lCommand "maketitle" "" "") ""]
    document   = concatMap beamer contents
    end        = endDocument
    ([title, author, date], contents) = splitAt 3 (lines s)


main = getContents >>= mapM_ putStrLn . latexify
