### Vybraná téma

**Banka**  
Navrhněte modul informačního systém banky pro správu účtů. 
Modul musí evidovat klienty, jejich účty a operace s nimi. 
Předpokládejte, že každý účet má jednoho vlastníka, ale s účtem může disponovat více osob, které určí vlastník. 
Operace zahrnují vklad na účet, výběr z účtu a převod na jiný účet (téže či jiné banky). 
Systém musí ukládat informaci o všech operacích s účtem (kdo zadal, kdy, jaká operace a částka, kdo provedl). 
Se systémem vždy přímo komunikuje pouze pracovník banky. 
Systém musí také mimo jiné poskytovat výpis z účtu, který se posílá vlastníkovi, tj. výpis všech operací s účtem za dané období.

---

### Popis projektu

Cílem řešeného projektu je návrh a implementace relační databáze na zvolené téma. Projekt se řeší ve dvoučlenných týmech. Je možné pokračovat na projektu z předmětu IUS. Pokud se studenti rozhodnou v projektu z IUS nepokračovat, pak si příslušné téma dvojice vybere ze [seznamu témat](https://www.fit.vutbr.cz/study/courses/IDS/private/temata.html).

Zvolené téma není potřeba předem nikde hlásit, avšak všechny výsledky musí obsahovat název zvoleného tématu (např. jako komentář v SQL skriptech, či vyznačený v diagramech nebo dokumentaci).

Projekt sestává ze čtyř částí, které se odevzdávají ve stanovených termínech do IS VUT. Všechny odevzdávané SQL skripty musí být určené pro systém řízení báze dat (SŘBD) Oracle 12c a musí umožňovat opakované volání, tedy odstranění a opětovné vytvoření, nebo rovnou přepsání, objektů v databázi a jejich dat (je v pořádku, když při prvním volání skriptu proběhnou neúspěšné pokusy o odstranění neexistujících databázových objektů).

Část projektu s diagramy se odevzdává vždy jako jeden PDF soubor. Části projektu s SQL skripty se odevzdávají jednotlivě vždy v jednom souboru s prostým textem v kódování znaků UTF-8.

### 1\. část - Datový model (ERD) a model případů užití

*   Datový model (ER diagram) zachycující strukturu dat, resp. požadavky na data v databázi, vyjádřený v notaci UML diagramu tříd (jako na přednáškách) nebo jako ER diagram např. v tzv. [Crow's Foot](https://cs.wikipedia.org/wiki/Entity-relationship_model#Crow.27s_Foot) notaci a model případů užití vyjádřený jako diagram případů užití v notaci UML reprezentující požadavky na poskytovanou funkcionalitu aplikace používající databázi navrženého datového modelu. Datový model musí obsahovat alespoň jeden vztah generalizace/specializace (tedy nějakou entitu/třídu a nějakou její specializovanou entitu/podtřídu spojené vztahem generalizace/specializace; vč. použití správné notace vztahu generalizace/specializace v diagramu).
*   Odevzdává se dokument obsahující výše uvedené modely včetně stručného popisu datového modelu. Z popisu musí být zřejmý význam jednotlivých entitních a vztahových množin.

  

### 2\. část - SQL skript pro vytvoření objektů schématu databáze

*   SQL skript vytvářející základní objekty schématu databáze, jako jsou tabulky vč. definice integritních omezení (zejména primárních a cizích klíčů), a naplňující vytvořené tabulky ukázkovými daty. Vytvořené schéma databáze musí odpovídat datovému modelu z předchozí části projektu a musí splňovat požadavky uvedené v následujících bodech (je samozřejmě vhodné opravit chyby a nedostatky, které se v ER diagramu objevily, popř. provést dílčí změny vedoucí ke kvalitnějšímu řešení).
*   V tabulkách databázového schématu musí být alespoň jeden sloupec se speciálním omezením hodnot, např. [rodné číslo či evidenční číslo pojištěnce (RČ)](https://www.cssz.cz/web/cz/standardni-kontrola-rodneho-cisla-a-evidencniho-cisla-pojistence), [identifikační číslo osoby/podnikatelského subjektu (IČ)](https://www.pohary.com/cs/660-ic-nebo-ico/), [identifikační číslo lékařského pracoviště (IČPE)](https://www.cssz.cz/web/cz/kontrola-icpe-pomoci-luhnova-algoritmu), [ISBN](https://cs.wikipedia.org/wiki/International_Standard_Book_Number#Kontroln.C3.AD_.C4.8D.C3.ADslice_u.C2.A0ISBN-10) či [ISSN](https://cs.wikipedia.org/wiki/International_Standard_Serial_Number#Kontrola_platnosti), [číslo bankovního účtu](https://www.kutac.cz/pocitace-a-internety/jak-poznat-spravne-cislo-uctu) (vizte také [tajemství čísla účtu](https://www.penize.cz/bezne-ucty/15470-tajemstvi-cisla-uctu)), atp. Databáze musí v tomto sloupci povolit pouze platné hodnoty (implementujte pomocí CHECK integritního omezení).
*   V tabulkách databázového schématu musí být vhodná realizace vztahu generalizace/specializace určená pro čistě relační databázi, tedy musí být vhodně převeden uvedený vztah a související entity datového modelu na schéma relační databáze. Zvolený způsob převodu generalizace/specializace do schéma relační databáze musí být stručně vysvětlen (v komentáři SQL kódu).
*   Skript také musí obsahovat automatické generování hodnot primárního klíče nějaké tabulky ze sekvence (např. pokud bude při vkládání záznamů do dané tabulky hodnota primárního klíče nedefinována, tj. NULL).

  

### 3\. část - SQL skript s dotazy SELECT

*   SQL skript, který nejprve vytvoří základní objekty schéma databáze a naplní tabulky ukázkovými daty (stejně jako skript v bodě 2) a poté provede několik dotazů SELECT.
*   Konkrétně musí tento skript obsahovat alespoň dva dotazy využívající spojení dvou tabulek, jeden využívající spojení tří tabulek, dva dotazy s klauzulí GROUP BY a agregační funkcí, jeden dotaz obsahující predikát EXISTS a jeden dotaz s predikátem IN s vnořeným selectem (nikoliv IN s množinou konstantních dat), tj. celkem minimálně 7 dotazů. U každého z dotazů musí být (v komentáři SQL kódu) popsáno srozumitelně, jaká data hledá daný dotaz (jaká je jeho funkce v aplikaci).

  

### 4\. část - SQL skript pro vytvoření pokročilých objektů schématu databáze

*   SQL skript, který nejprve vytvoří základní objekty schéma databáze a naplní tabulky ukázkovými daty (stejně jako skript v bodě 2), a poté zadefinuje či vytvoří pokročilá omezení či objekty databáze dle upřesňujících požadavků zadání. Dále skript bude obsahovat ukázkové příkazy manipulace dat a dotazy demonstrující použití výše zmiňovaných omezení a objektů tohoto skriptu (např. pro demonstraci použití indexů zavolá nejprve skript EXPLAIN PLAN na dotaz bez indexu, poté vytvoří index, a nakonec zavolá EXPLAIN PLAN na dotaz s indexem; pro demostranci databázového triggeru se provede manipulace s daty, která vyvolá daný trigger; atp.).
*   Tento SQL skript musí konkrétně obsahovat vše z následujících
    *   vytvoření alespoň dvou netriviálních databázových triggerů vč. jejich předvedení,
    *   vytvoření alespoň dvou netriviálních uložených procedur vč. jejich předvedení, ve kterých se musí (dohromady) vyskytovat alespoň jednou kurzor, ošetření výjimek a použití proměnné s datovým typem odkazujícím se na řádek či typ sloupce tabulky (`table_name.column_name%TYPE` nebo `table_name%ROWTYPE`),
    *   explicitní vytvoření alespoň jednoho indexu tak, aby pomohl optimalizovat zpracování dotazů, přičemž musí být uveden také příslušný dotaz, na který má index vliv, a na obhajobě vysvětlen způsob využití indexu v tomto dotazu (toto lze zkombinovat s EXPLAIN PLAN, vizte dále),
    *   alespoň jedno použití EXPLAIN PLAN pro výpis plánu provedení databazového dotazu se spojením alespoň dvou tabulek, agregační funkcí a klauzulí GROUP BY, přičemž na obhajobě musí být srozumitelně popsáno a vysvětleno, jak proběhne dle toho výpisu plánu provedení dotazu, vč. objasnění použitých prostředků pro jeho urychlení (např. použití indexu, druhu spojení, atp.), a dále musí být navrnut způsob, jak konkrétně by bylo možné dotaz dále urychlit (např. zavedením nového indexu), navržený způsob proveden (např. vytvořen index), zopakován EXPLAIN PLAN a jeho výsledek porovnán s výsledkem před provedením navrženého způsobu urychlení,
    *   definici přístupových práv k databázovým objektům pro druhého člena týmu,
    *   vytvoření alespoň jednoho materializovaného pohledu patřící druhému členu týmu a používající tabulky definované prvním členem týmu (nutno mít již definována přístupová práva), vč. SQL příkazů/dotazů ukazujících, jak materializovaný pohled funguje,
    *   vytvoření jednoho komplexního dotazu SELECT využívajícího klauzuli WITH a operátor CASE. V poznámce musí být uvedeno, jaká data dotaz získává.
*   Řešení projektu může volitelně obsahovat také další prvky neuvedené explicitně v předchozích bodech či větší počet nebo složitost prvků uvedených. Takové řešení pak může být považováno za nadstandardní řešení a oceněno dalšími body. Příkladem nadstandardního řešení může být řešení obsahující
    *   klientskou aplikaci realizovánou v libovolném programovacím jazyce, přičemž práce s aplikací odpovídá případům užití uvedených v řešení 1. části projektu – tedy aplikace by neměla pouze zobrazovat obecným způsobem tabulky s daty a nabízet možnost vkládání nových či úpravy a mazání původních dát, ale měla by odpovídat pracovním postupům uživatelů (např. knihovník po příchodu čtenáře žádá ID průkazky čtenáře, systém vypíše existující výpůjčky čtenáře s vyznačením případných pokut, knihovník má možnost označit jednolivé výpůjčky jako právě vrácené, případně inkasovat pokuty spojené s výpůjčkami, či přidat nové výpůjčky daného čtenáře),
    *   SQL dotazy a příkazy ukazující transakční zpracování, vč. jejich popisu a vysvětlení na obhajobě – např. ukázka atomicity transakcí při souběžném přístupu více uživatelů/spojení k jedněm datům, ukázka zamykání, atp.
*   Jednotlivé části tohoto skriptu bude potřeba na obhajobě vysvětlit, zejména část s příkazem EXPLAIN PLAN. K tomuto účelu doporučujeme, aby si studenti připravili (nepovinně) k obhajobě poznámky ve formátu krátkého textového dokumentu, které mohou být součástí odevzdání.

Tip: pro ladění PL/SQL kódu v uložených procedurách či databázových triggerech můžete použít proceduru `DBMS_OUTPUT.put_line(...)` pro výstup na terminál klienta.

### Organizace projektu, řešení a obhajoby

Studenti řeší projekt ve dvojici (v týmu). Každý z výsledků projektu musí být vypracován v souladu se studijními předpisy VUT a FIT a autorským zákonem, tj. zejména samostatně dvojicí studentů (týmem), která jej předkládá, jako svůj výsledek (viz čl. 11 Směrnice děkana FIT doplňující Studijní a zkušební řád VUT).

Pro řešení studenti využívají čas volného využití v počítačových učebnách CVT nebo řeší na svých počítačích. Cvičící poskytují zájemcům konzultace. Kromě toho jsou zařazena do programu přednášek témata na podporu řešení projektů zaměřená na seznámení s prostředím, které budou studenti využívat k řešení projektů, např. databázový server Oracle 12c, vývojové prostředí Oracle SQL Developer a jazyk PL/SQL – viz výše v části o přednáškách.

Součástí 4. části je závěrečná obhajoba projektu. Cílem obhajob je zdůvodnit a diskutovat prezentované řešení a prokázat samostatnou práci (na obhajobě můžete být požádáni o vysvětlení či upřesnění kterékoliv části projektu).

### Hodnocení řešení projektu

Za projekt lze získat celkem 34 bodů, z toho za poslední část lze získat až 19 bodů. Za výsledek obsahující další funkcionalitu či prvky nepožadované explicitně v zadání projektu lze získat další prémiové body.

Celkově lze dosáhnout nejvýše 34 bodů. Za jednotlivé části řešení je následující počet bodů:

*   **Datový model (ERD) a model případů užití** – max. 5 bodů
*   **SQL skript pro vytvoření základních objektů schématu databáze** – max. 5 bodů
*   **SQL skript s několika dotazy SELECT** – max. 5 bodů
*   **SQL skript pro vytvoření pokročilých objektů schématu databáze** (s obhajobou) – max. 19 bodů

### Školní databázový server Oracle

Přibližně v průběhu druhého týdne výuky budou všem studentů kurzu IDS vytvořeny uživatelské účty na školním databázovém server Oracle. V IS VUT bude termín "Přihlašovací údaje na školní databázový server Oracle" v jehož popisu budou informace o způsobu připojení na server a v komentáři k (nulovému) hodnocení heslo pro přihlášení (login je stejný, jako jinde na FIT).

O vytvoření účtů a možnostech přihlášení budete také informování v hromadném emailu.

### Doporučená literatura a pomůcky pro řešení projektu

*   [Oracle Database 12c Release 1 (12.1) – Get Started](https://docs.oracle.com/database/121/index.htm)
*   [Oracle Database Online Documentation 12c Release 1 (12.1) – Database SQL Language Reference](https://docs.oracle.com/database/121/SQLRF/toc.htm)
*   [Oracle Database Online Documentation 12c Release 1 (12.1) – Database PL/SQL Language Reference](https://docs.oracle.com/database/121/LNPLS/toc.htm)
*   [Oracle Database Online Documentation 12c Release 1 (12.1) – SQL Developer User's Guide](https://docs.oracle.com/database/121/RPTUG/toc.htm)
*   [Oracle Database Online Documentation 12c Release 1 (12.1) – SQL\*Plus User's Guide and Reference](https://docs.oracle.com/database/121/SQPUG/toc.htm)
*   Ráb, J.: Tvorba databázových aplikacív prostředí Oracle Form Builder. Studijní opora, 2006. Dostupné mezi soubory k předmětu ve složce Studijní opory.
*   [Visual Paradigm – Use Case Modeling](https://www.visual-paradigm.com/VPGallery/usecase/index.html)
*   [Visual Paradigm – Entity Relationship Diagram](https://www.visual-paradigm.com/VPGallery/datamodeling/EntityRelationshipDiagram.html)
*   [Visual Paradigm – Class Diagram](https://www.visual-paradigm.com/VPGallery/diagrams/Class.html)
*   Jaroslav Ráb: Prezentace práce ve vývojovém prostředí Oracle Forms Builder 6i/10g.
    *   [Uvod do tvorby databazovych aplikaci v prostredi Oracle Forms Builder 6i (wmv format/resolution 1024x768, filesize 240 MB, 45 minut)](https://www.fit.vutbr.cz/study/courses/IDS/private/demo/forms-reports/prezentace/demo01.wmv)
        
        *   [Prace s vice okny (wmv format/resolution 1024x768, filesize 90 MB, 15 minut)](https://www.fit.vutbr.cz/study/courses/IDS/private/demo/forms-reports/prezentace/demo02.wmv)
        *   [Prace s listboxem, dynamicke nastaveni DEFAULT\_WHERE klauzule databazoveho data bloku (wmv format/resolution 1024x768, filesize 48 MB, 9 minut)](https://www.fit.vutbr.cz/study/courses/IDS/private/demo/forms-reports/prezentace/demo03.wmv)
        *   [Prace s tiskovou sestavou (wmv format/resolution 1024x768, file size 120 MB, 15 minut)](https://www.fit.vutbr.cz/study/courses/IDS/private/demo/forms-reports/prezentace/demo04.wmv)

### Software

Některý níže uvedený software je dostupný take přímo na tomto webu, bez nutnosti stahovat z webu Oracle.

#### Klienti pri připojení k databázi Oracle

*   [Oracle SQL Developer](https://www.oracle.com/database/technologies/appdev/sql-developer.html)
*   [Oracle SQL Developer Command Line SQLcl (SQL\*Plus compatible)](https://www.oracle.com/database/technologies/appdev/sqlcl.html)
*   [JetBrains DataGrip](https://www.jetbrains.com/datagrip/) ([free for students and teachers](https://www.jetbrains.com/community/education/#students))

#### Databázový stroj Oracle

*   [Oracle Database Express Edition](http://www.oracle.com/technetwork/database/database-technologies/express-edition/overview/index.html)
*   [Oracle Pre-Built Developer VMs (Oracle Enterprise Manager Developer VM)](https://www.oracle.com/downloads/developer-vm/community-downloads.html)
*   [Oracle Docker Container Registry (Oracle Database SE2/EE, Instant Client)](https://container-registry.oracle.com/)

#### Vývoj klientských aplikací v prostředí Oracle

*   [Obraz virtuálního stroje pro Oracle VirtualBox s Windows XP a nástroji Oracle](https://www.fit.vutbr.cz/study/courses/IDS/private/download/virtual/IDS2013.ova) (velikost 5 GB; vizte [návod](https://www.fit.vutbr.cz/study/courses/IDS/private/download/virtual/IDS2013-navod.pdf)) – nástroje Oracle Forms a Reports Builder 10g Release 2, Oracle database 11gR2 XE, Oracle SQL Developer, Oracle Data Modeler, SQL Plus a další podpůrné nástroje
*   [Obraz virtuálního stroje pro Oracle VirtualBox s CentOS 5.9 a nástroji Oracle](https://www.fit.vutbr.cz/study/courses/IDS/private/download/virtual/CentOS59.ova) (velikost 4GB; vizte [návod](https://www.fit.vutbr.cz/study/courses/IDS/private/download/virtual/CentOS59-navod.txt))

#### Modelování

*   [Visual Paradigm for UML, Standard Edition – Academic Partner Program](https://www.fit.vutbr.cz/study/courses/IDS/private/vpapp/)
*   [Visual Paradigm, Community Edition](https://www.visual-paradigm.com/download/community.jsp)
*   [Obeo UML Designer (Eclipse)](http://www.umldesigner.org/)
*   [Modeliosoft Modelio](https://www.modelio.org/)
*   [PlantUML](https://plantuml.com/)