# Commentaar schrijven voor Declarative Programming in de Haddockstijl

Ook Haskell heeft eigen symbolen en standaarden als het gaat om documentatie. Het pakket [Haddock](https://haskell-haddock.readthedocs.io/en/latest/intro.html) kan je documentatie omzetten naar makkelijk navigeerbare HTML-pagina's zoals je bij professionele projecten gewend bent. Nu gaan we niet van elke student die webpagina's aanmaken en ook echt doorlopen; het is voor ons veel efficiënter om direct in de code te kijken of de documentatie er in het juiste format staat. Haddock installeren is dan ook volledig optioneel, maar de _commentaarstijl_ die Haddock voorschrijft niet!

## De Haddock-stijl

Commentaar in Haskell schrijf je als volgt:

```haskell
-- Twee dashes voor enkele regels,
{-
   en accolades met dashes
   voor meerdere regels.
-}
```

Dit zie je ook terug in het commentaar dat wij al hebben toegevoegd in de practica. Om in Haddockstijl te schrijven, voeg je extra symbolen toe aan je commentaar:

```haskell
-- | Een spatie en een pipe-symbool voor enkele regels,
-- ^ of een spatie en een accent circonflexe voor enkele regels,
{-| 
    en accolade-dash-pipe 
    voor meerdere regels,
-}
{-^
    of accolade-dash-accent circonflexe
    voor meerdere regels.
-}
```

**Let op: `-- |` werkt prima, maar `--|` geeft compiler errors; gebruik daar dus altijd spaties!** Maar wanneer gebruik je nou `|` en wanneer gebruik je `^`? Simpel: als je documentatie vóór de functie/regel staat, gebruik je `|`, als het erna staat gebruik je `^`. Een voorbeeld van correcte documentatie:

```haskell
{-|
    This function multiplies every value in the list by three, by explicitly recursing over all elements.
-}
multiplyByThree :: [Int] -> [Int]
-- | This is the base case, when the list is empty; we complete the loop by returning an empty list.
multiplyByThree [] = []
-- | This is the recursive case, where we multiply the head by three and place it before the result of processing the tail.
multiplyByThree (x:xs) = x * 3 : multiplyByThree xs
```

Dit is ook correcte documentatie:

```haskell
multiplyByThree :: [Int] -> [Int]
{-^
    This function multiplies every value in the list by three, by explicitly recursing over all elements.
-}
multiplyByThree [] = [] -- ^ This is the base case, when the list is empty; we complete the loop by returning an empty list.
multiplyByThree (x:xs) = x * 3 : multiplyByThree xs -- ^ This is the recursive case, where we multiply the head by three and place it before the result of processing the tail.
```

Je kunt ze ook door elkaar gebruiken:

```haskell
{-|
    This function multiplies every value in the list by three, by explicitly recursing over all elements.
-}
multiplyByThree :: [Int] -> [Int]
multiplyByThree [] = [] -- ^ This is the base case, when the list is empty; we complete the loop by returning an empty list.
multiplyByThree (x:xs) = x * 3 : multiplyByThree xs -- ^ This is the recursive case, where we multiply the head by three and place it before the result of processing the tail.
```

Voor onze practica heb je alleen deze opmaak nodig. Haddock heeft nog veel meer opties; hiervoor kun je [de specificatie](https://haskell-haddock.readthedocs.io/en/latest/markup.html) raadplegen, maar wij slaan er geen acht op bij het becijferen.

## Inhoud van goed commentaar

Het voorbeeld uit de vorige sectie is erg uitgebreid; zo commentaar geven is een pluspunt, maar het is zeker niet noodzakelijk om de volle punten te krijgen. We vragen je om heel veel functies van commentaar te voorzien, en vaak zijn het functies van slechts een paar regels lang (als je een goede oplossing hebt gevonden). Dan is een enkele regel commentaar voorafgaand aan de functie voldoende:

```haskell
-- | This function multiplies every value in the list by three, by explicitly recursing over all elements.
multiplyByThree :: [Int] -> [Int]
multiplyByThree [] = [] 
multiplyByThree (x:xs) = x * 3 : multiplyByThree xs 
```

Wat je in deze enkele regel zet is echter wel belangrijk. We willen de volgende vragen beantwoord zien in jullie commentaar:

1. Wat doet de functie (in je eigen woorden, niet de onze)?
2. Hoe doet de functie dat?

Hopelijk is het helder dat de documentatie in het voorbeeld hierboven precies deze twee vragen beantwoordt. Bij het eerste practicum zal het antwoord op de tweede vraag bijna altijd hetzelfde zijn; in herhaling vallen is niet erg. In verdere practica kun je ook gebruik gaan maken van bijvoorbeeld folds, en dan zien we dat graag terug in je documentatie. 

Controleer dus dat jouw commentaar die twee vragen altijd beantwoordt. Als je twijfelt, kun je ons altijd raadplegen over hoe je dit kunt formuleren.

Verder de volgende zaken:

- Documentatie hoort per functie zelfstandig leesbaar te zijn! Verwijs dus niet naar de documentatie van andere functies (bijv. "hetzelfde principe als bij de voorgaande functie"). Dan liever nog een copy-paste van de relevante onderdelen. 
- Je mag commentaar in het Nederlands schrijven, of in het Engels, maar niet beide door elkaar!
- We letten ook op spelling en grammatica bij het becijferen. Als je hier onzeker over bent, kan het de moeite lonen om je documentatie even te kopiëren en door een spellchecker te halen.
- In het commentaar van de opdrachten hebben we bij alle opdrachten het woord TODO gezet. Je mag onze documentatie weghalen in jouw inlevering, en dus ook TODO weghalen als je functie klaar is. Dat kan helpen met bijhouden hoeveel je nog moet doen.