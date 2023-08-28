# Cellulaire Automata

In dit practicum gaan we aan de slag met (1D) cellulaire automata. Cellulaire automata zijn systemen waarbij een raster van cellen met elk een toestand in discrete stappen wordt geupdatet. Hierbij wordt de toestand van een cell bepaald aan de hand van de toestand in de vorige stap van de gegeven cell en diens buren. We gaan in dit practicum kijken naar de 1D variant, waarbij alle cellen op een enkele lijn liggen. Doordat we meerdere tijdstappen onder elkaar printen ontstaat een 2D-figuur, waarbij de verticale as de tijd representeert.

In deze Readme geven we kort enkele voorbeelden van de 1D cellulaire automata uit dit practicum. Dit is ter aanvulling op, niet ter vervanging van, het college. Tevens wordt het sterk aangeraden om de pagina's van Wolfram MathWorld er op na te slaan voor diepgaandere uitleg.

Een afbeelding van https://mathworld.wolfram.com/Rule30.html ter illustratie:

![Een illustratie van het cellulair automaton voor regel 30, van https://mathworld.wolfram.com/Rule30.html](../img/rule30.png)

We werken in dit practicum met 1D cellulaire automata. Dat wil zeggen dat er eigenlijk maar één as is waarop de cellen staan, oftewel een lijn van vakjes. Echter, de automata veranderen die lijn van vakjes met elke tijdstap. Als we meerdere tijdstappen zetten, en de lijnen van vakjes onder elkaar zetten, krijgen we een 2D grid van vakjes. Zo ontstaat ook de driehoek die je hierboven ziet.

Elke cel is ofwel levend (1) ofwel dood (0). In de startsituatie zijn alle cellen dood op één na. Het helpt om die levende cel in het "midden" van de oneindig lange rij dode cellen te visualiseren. Kijk in het grid van cellen naar de eerste rij van boven: alleen de middelste cel is levend (zwart), de rest is dood (wit).

Bij elke tijdstap passen we de regel van het automaton toe om te zien welke cellen levend en dood moeten zijn. Hiervoor kijken we per cel naar de vorige status van de cel, en de vorige status van diens buren. Omdat we naar drie cellen kijken, en elke cel twee mogelijke statussen heeft, zijn er maar acht mogelijke combinaties.

We zoomen nu in op het meest linkse geval ter uitleg:

![Een fragment van de vorige illustratie, die de regel demonstreert voor drie levende voorgangers, van https://mathworld.wolfram.com/Rule30.html](../img/rule30allalive.png)

Dit "Tetrisblokje"\* illustreert één van de acht mogelijke combinaties van levende en dode cellen. De bovenste drie vakjes vertegenwoordigen één cel en diens buren bij tijdstip *t*, het onderste vakje vertegenwoordigt die ene cel op tijdstip *t + 1*. Deze afbeelding betekent, in andere woorden:

*Als een cel en diens buren allemaal levend zijn, is die cel bij de volgende stap dood.*

Hiermee wordt hopelijk ook duidelijk wat de andere zeven gevallen voorstellen. Zo staat er bij de vierde combinatie van links bijvoorbeeld:

*Als een cel en diens rechterbuur dood zijn, maar diens linkerbuur leeft, is die cel bij de volgende stap levend.*

Je ziet precies deze patronen ook terug in de driehoek in het grid. Onthoud dat elke rij die je naar beneden gaat, je één tijdstap vooruit gaat.

Nu kunnen we eindelijk ook verklaren waarom dit Rule 30 is. Het getal 30 is in essentie een samenvatting van de regel. Als je de acht mogelijke gevallen naast elkaar zet, in de volgorde zoals hierboven, en noteert of de cel de volgende tijdstap levend of dood is, krijg je een binair getal (hier: 00011110) - wat staat voor 30.

Er zijn dan ook 256 mogelijke regels op te stellen. Echter, maar weinig regels leiden tot interessante patronen zoals je hierboven ziet. (Beeld je bijvoorbeeld in: hoe ziet de afbeelding voor Rule 0 eruit? Of Rule 255?)

Van veel van de regels die interessante patronen genereren is ook een pagina of Wolfram MathWorld te vinden. Kijk bijvoorbeeld ook eens op onderstaande links:

https://mathworld.wolfram.com/Rule28.html

https://mathworld.wolfram.com/Rule102.html

https://mathworld.wolfram.com/Rule126.html

https://mathworld.wolfram.com/Rule150.html

Hopelijk is nu helder wat je te zien krijgt als je het practicum helemaal juist invult. Heel veel succes met programmeren!

\*Als je eerste reflex was om mij te laten weten dat de formele term "Tetromino" is: wees gegroet, medenerd!