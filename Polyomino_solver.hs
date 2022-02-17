import System.IO;
import System.Environment;

type Figure = [Block];
type Block = (Int, Int);

main :: IO ()        
main = do
        (firstArg:_) <-getArgs
        fileContent <- readFile firstArg
        let (shapeString:figuresString) = lines fileContent
        let shape = parseshape shapeString
        let figures = parsefigures figuresString
        putStr "shape: "
        print shape
        putStr "figures: "
        print figures
        putStr "Solution? - "
        print (fitfigures figures shape)


----PARSING INPUT-------
removeBrackets :: String -> String
removeBrackets = filter (\char -> char /= '(' && char /= ')')

putToArrayString :: String -> [String]  --1,0 0,1 -> ["1", "0", "0", "1"]
putToArrayString (f:fs) = foldl(\acc el -> if el == ',' || el == ' ' then acc ++ [[]] 
                                           else init acc ++ [last acc ++ [el]]) [[f]] fs

stringArrayToIntArray :: [String] -> [Int]
stringArrayToIntArray = map (\el -> read el :: Int)

parseFigureIntArray :: [Int] -> Figure --[1,0,0,1] -> [(1,0), (0,1)]
parseFigureIntArray [] = []
parseFigureIntArray (x:y:rest) = (x,y) : parseFigureIntArray rest

parseFigure :: String -> Figure
parseFigure input = parseFigureIntArray intNumbersArray
                        where {
                                inputNoBrackets = removeBrackets input;
                                stringNumbersArray = putToArrayString inputNoBrackets;
                                intNumbersArray = stringArrayToIntArray stringNumbersArray
                              }


parsefigures :: [String] -> [Figure]
parsefigures = foldl(\acc figure -> parseFigure figure : acc) [] 

parseshape :: String -> Figure
parseshape = parseFigure
----PARSING INPUT---END----


----Fit places in the shape------
fitPlaces :: Figure -> Figure -> [Block]
-- So where can we put our figure into the shape
--
-- to each block coordinate we add the coordinates of fit block
-- then we check wether a figure with new coordinates fits in the shape
-- so wheter new coordinates exists in the set of shape's coordinate
fitPlaces figure shape = foldl(\acc block -> if (addCoordinates block figure) `fitsIn` shape then block : acc else acc) 
                                    [] shape

addCoordinates :: Block -> Figure -> Figure
addCoordinates block figure = map (\figureBlock -> ((fst figureBlock) + (fst block - fst lockedBlock), (snd figureBlock + (snd block - snd lockedBlock)))) figure
                                where 
                                lockedBlock = head figure

fitsIn :: Figure -> Figure -> Bool
-- Does the first figure fit in the second figure
-- so does all first figure's coordinates are in the second figure's coordinates
fitsIn figure1 figure2 = foldl(\acc blockFig1 -> acc && blockFig1 `elem` figure2) True figure1
----Fit places in the shape--END----

----Matching figures to the shape------
removeBlocks :: Figure -> Block -> Figure -> Figure
-- we point a place where we are to put the figure and remove this part from the shape
removeBlocks figure placeOfRemoval shape = foldl(\acc block -> filter(/=block) acc) shape (addCoordinates placeOfRemoval figure)

fitfigures :: [Figure] -> Figure -> Bool
fitfigures [] [] = True
fitfigures figures [] = False
fitfigures [] shape = False
fitfigures (f:fs) shape = foldl(\acc place -> acc || fitfigures fs (removeBlocks f place shape)) False (fitPlaces f shape)
                            || foldl(\acc place -> acc || fitfigures fs (removeBlocks (rotate90 f) place shape)) False (fitPlaces (rotate90 f) shape)
                            || foldl(\acc place -> acc || fitfigures fs (removeBlocks (rotate180 f) place shape)) False (fitPlaces (rotate180 f) shape)
                            || foldl(\acc place -> acc || fitfigures fs (removeBlocks (rotate270 f) place shape)) False (fitPlaces (rotate270 f) shape)
----Matching figures to the shape--END----

----Rotation-------
rotate90 :: Figure -> Figure
rotate90 = map (\(x, y) -> (y, -x) )

rotate180 :: Figure -> Figure
rotate180 = map (\(x, y) -> (-x, -y) )

rotate270 :: Figure -> Figure
rotate270 = map (\(x, y) -> (-y, x) )
----Rotation---END----
