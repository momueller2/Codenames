<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>Codenames Operative</title>
<link rel="stylesheet" type="text/css"
	href="../JQuerySource/jquery-ui-1.13.1/jquery-ui.css">
<script src="../JQuerySource/jquery-3.6.0.js"></script>
<script src="../JQuerySource/jquery-ui-1.13.1/jquery-ui.js"></script>
<link rel="stylesheet" type="text/css" href="game.css">
<script src="game.js"></script>
<script src="websocket.js"></script>
</head>
<body>
	<div class="background"></div>
	<div class="background-image"></div>
	<div id="rulesDialog" title="Codenames Rules">
		<nav class="rulesTitlePanel">
			<h2 class="rulesTitle">Codenames</h2>
			<p class="rulesUndertitle">Team VS Team, 4 Spieler</p>
			<button class="closeButton"></button>
		</nav>
		<section class="rulesContent">
			<p>
				Codenames ist ein Spiel für zwei Teams. Das Spielfeld ist aufgebaut
				aus einem 5x5 Raster. Manche der Karten werden heimlich auf das <b><font
					color="#a21414">rote Team</font></b>, andere auf das <b><font
					color="#144da2">blaue Team</font></b> verteilt. Ein Spieler jedes Teams
				ist ein <b>Spymaster</b> und nur der Spymaster sieht, welche Karten
				zu welchem Team gehören. Spymasters versuchen, den <b>Operatives</b>
				einen Tipp zu geben, damit dieser die zu seinem Team zugehörigen
				Begriffe herausfindet. Das erste Team, welches alle seine Karten
				aufgedeckt hat, gewinnt.
			</p>
			<blockquote>
				<strong>Bitte beachte:</strong> Codenames hat keine festen Regeln.
				Diese können nach belieben angepasst werden.
			</blockquote>
			<h2>Teamaufteilung</h2>
			<p>
				Teile alle Spieler in zwei Teams, <b><font color="#a21414">rot</font></b>
				und <b><font color="#144da2">blau</font></b>.
			</p>
			<section class="rulesWith2Figures">
				<figure>
					<figcaption>
						Ein Spieler jedes Teams sollte auf den <strong class="bg-yellow">Als
							Spymaster beitreten</strong>-Knopf klicken. Derjenige sieht dann die Farbe
						aller Karten.
					</figcaption>
					<div class="figureDiv">
						<img
							src="../GamePage/assets/instruction/spymasterview.png"
							alt="spymaster_view"
							class="figure">
					</div>
				</figure>
				<figure>
					<figcaption>
						Alle anderen sollten auf den <strong class="bg-yellow">Als
							Operative beitreten</strong>-Knopf klicken. Sie sehen die Farben nicht.
					</figcaption>
					<div class="figureDiv">
						<img
							src="../GamePage/assets/instruction/operativeview.png"
							alt="operative_view"
							class="figure">
					</div>
				</figure>
			</section>
			<h2>Tipps geben</h2>
			<p>Spymasters können Hinweise geben. Wähle die Wörter aus, für
				welche du einen Hinweis geben möchtest, und schreibe deinen Hinweis,
				welcher sich auf all diese Wörter beziehen sollte daneben. Deinen
				Teammitglieder sehen deinen Hinweis und die Anzahl der damit
				verbundenen Karten.</p>
			<figure>
				<figcaption class="figureCaption">
					<section>Wenn du einen Tipp gibst ...</section>
					<section class="text-right">... sehen deine Operatives
						nur das Wort und die Zahl.</section>
				</figcaption>
				<div class="figureDiv">
					<img src="../GamePage/assets/instruction/give_clues.png"
						alt="give_clue" class="figure">
				</div>
			</figure>
			<p>&nbsp;</p>
			<p>
				<img src="../GamePage/assets/instruction/assassin_card_blank.png"
					alt="assassin card"
					style="float: left; padding-right: 1rem; padding-top: 0.3rem;"
					width="90"> Pass auf die schwarze Karte auf - Sie ist ein
				versteckter Assassin! Vermeide Wörter, die damit in Verbindung
				stehen.
			</p>
			<p>&nbsp;</p>
			<blockquote>
				<strong>Notiz:</strong> Manche Tipps sind nicht erlaubt, zum
				Beispiel ein Wort was bereits im Raster steht, in Teilen
				wiederzuverwenden. Siehe <a href="#valid-clues">Valide Tipps</a>.
			</blockquote>
			<h2>Erraten</h2>
			<p>Operatives erraten die Wörter auf Grundlage des Hinweises des
				Spymasters.</p>
			<section class="rulesWith2Figures">
				<figure>
					<figcaption>Du kannst deine Gedanken mit deinem Team
						teilen, indem du auf eine der Karten klickst, welche du denkst,
						dass es die sein könnte.</figcaption>
					<div class="figureDiv">
						<img src="../GamePage/assets/instruction/give_guess.png"
							alt="give_guess" class="figure">
					</div>
				</figure>
				<figure>
					<figcaption>
						Um deine Schätzung offiziell zu machen, klicke auf den <img
							src="../GamePage/assets/instruction/icon_tap_card.png"
							class="rulesFingerIcon">-Knopf. Das Spiel wird dir dann die
						Antwort zeigen.
					</figcaption>
					<div class="figureDiv">
						<img src="../GamePage/assets/instruction/official_guess.png"
							alt="official_guess" class="figure">
					</div>
				</figure>
			</section>
			<p>&nbsp;</p>
			<p>Wenn du eine richtige Karte errätst, darfst du nochmal raten.
				Versuche die Anzahl die dein Spymaster angegeben hat zu nutzen.</p>
			<blockquote>
				<strong>Notiz:</strong> Du kannst Karten aus vorherigen Runden
				erraten. Siehe <a href="#number-of-guesses">Anzahl der Ratungen</a>.
			</blockquote>
			<h2>Spielzugende</h2>
			<p>Du kannst den Spielzug auf drei verschiedenen Wegen beenden:</p>
			<section class="rulesWith3Figures">
				<figure>
					<figcaption>Errate ein Feld, welches vom Gegnerteam oder farblos ist</figcaption>
					<div class="figureDiv">
						<img
							src="../GamePage/assets/instruction/farbloses.png"
							class="figure">
					</div>
				</figure>
				<figure>
					<figcaption>Manuell über den <strong>Raten beenden</strong> Button.</figcaption>
					<div class="figureDiv">
						<img
							src="../GamePage/assets/instruction/raten_beenden.png"
							class="figure">
					</div>
				</figure>
				<figure>
					<figcaption>Errichen der maximalen Rateanzahl (Hinweisnummer + 1).</figcaption>
					<div class="figureDiv">
						<img
							src="../GamePage/assets/instruction/max_ratungen.png"
							class="figure">
					</div>
				</figure>
			</section>
			<h2>Gewinnen und Verlieren</h2>
			<p>Die Teams wechseln sich ab. Ein Team gewinnt, wenn es alle
				seine Karten erraten hat, und verliert, wenn es denn Assassin
				trifft!</p>
			<h2>Notiz</h2>
			<details>
				<summary class="rulesSummary" id="valid-clues">Valid clues</summary>
				<section>
					<ul>
						<li>Der Hinweis ist strickt auf <b>ein Wort und eine Zahl</b>
							beschränkt. Von dem Spymaster wird erwartet keine Kommentare zu
							den Rateversuchen zu geben, um keine zusätzliche Hilfe zu sein
						</li>
						<li>Dein Hinweis soll nur <b>ein Wort</b> sein, aber
							Spymaster können sich auf andere Regeln einigen. Zum Beispiel
							könnt ihr zwei Wörter Städtenamen erlaub, wie zum Beispiel NEW
							YORK.
						</li>
						<li>Benutze <b>keine Form von Wörtern im Raster</b> als ein
							Hinweis. Benutze nicht ZUCKER als Hinweis für ZUCKER und
							SCHOCKOLADE und versuche auch nicht, diese Regel zu umgehen,
							indem du ZUCKRIG oder ZUCKERROHR
						</li>
						<li>Gib Hinweise <b>in der vereinbarten Sprache</b>. Benutze
							keine andere Sprache für extra Information.
						</li>
						<li>Der Hinweis muss mit <b>der Bedeutung der Wörter</b>
							übereinstimmer. Gib keine Hinweise über die Buchstaben im Wort
							oder die Position im Raster.
						</li>
					</ul>
					<p>Behalte deine Hinweise im Sinne des Spiels, und wenn du dir
						nicht sicher bist, kannst du immer noch die anderen Spymaster
						fragen, was sie erlauben.</p>
				</section>
			</details>
			<details>
				<summary class="rulesSummary" id="number-of-guesses">Anzahl
					der Ratungen</summary>
				<section>
					<p style="margin-bottom: 1.1rem;">
						Die Zahl in deinem Hinweis sagt deinem Team, wieviele Wörter mit
						deinem Hinweis gemeint sind Sie können immer <b>eine extra
							Wort</b> erraten. Üblicherweise ein Wort, das sie in vorherigen
						Runden nicht erraten haben.
					</p>
					<section class="numberOfGuessesRuleText">
						<ul>
							<li>Wenn du willst, dass dein Team mehr Karten erraten soll,
								kannst du per hand <b>Unendlich ∞</b> auswählen. Sie können dann so
								viele Wörter auswählen wie sie wollen. (wissen aber nicht,
								wieviele Wörter du mit deinem Hinweis meintest)
							</li>
							<li>Du kannst auch <b>-</b> für deinen Tipp benutzen. Es
								erlaubt deinem Team soviel zu erraten wie sie wollen. Der
								Unterschied ist, dass du damit sagst, das dein Tipp auf kein
								Wort deiner Farbe hinweist. Du kannst es zum Beispiel benutzen,
								wenn du verhindern willst, dass dein Team eine gegnerische Karte
								errät.
							</li>
						</ul>
					</section>
					<p>
						Egal wieviele Tipps du einstellst, dein Team muss immer <b>mindestens
							eine Karte erraten</b>.
					</p>
				</section>
			</details>
		</section>
	</div>
	<div id="nameDialog" title="Enter Name">
		<div class="dialogInputPanel" id="nameInputPanel">
			<h3 id="enterNameHeadline">Dein Name:</h3>
			<input id="nameInput" name="nameInput" />
		</div>
	</div>
	<div class="wrapper">
		<button class="playerCount">Spieler</button>
		<div class="roomLinkPanel">
			<h3 class="linkCaption">Lade andere Spieler mit diesem Link ein:</h3>
			<input class="roomLink" id="link" value="">
			<button class="linkButton">Kopieren</button>
		</div>
		<p class="copiedLinkCaption">Der Link wurde kopiert!</p>
		<div class="optionPanel">
			<button class="rulesButton">Anleitung</button>
			<button class="optionsButton">Name</button>
			<div class="optionsPanel">
				<div class="namePanel">
					<label class="nickNameLabel">Name</label> <input
						class="nickNameField" id="nickname" value="">
					<button class="updateButton">Ändere deinen Namen</button>
				</div>
				<button class="leaveRoomButton"
					onclick="window.location.href = '../StartPage/StartPage.jsp'">Raum
					verlassen</button>
			</div>
		</div>
		<div class="info">Codenames</div>
		<div class="blueSide">
			<section>
				<article id="blue counter" class="counter">9</article>
			</section>
			<div class="blueCharacter"></div>
			<div class="players">
				<header class="operativeBlue" id="blue operative header">
					<span>Operative</span>
				</header>
				<div class="name" id="blue operative name">-</div>
				<button id="blue operative" class="joinButton">Als
					Operative beitreten</button>
				<header class="spymasterBlue" id="blue spymaster header">
					<span>Spymaster</span>
				</header>
				<div class="name" id="blue spymaster name">-</div>
				<button id="blue spymaster" class="joinButton">Als
					Spymaster beitreten</button>
			</div>
		</div>
		<div class="grid">
			<c:forEach var="word" items="${cards.randomCards}"
				varStatus="loopState">
				<div class="card">
					<div id="white" data-color="${word.getColor()}">
						<div class="card_text">${word.getText()}</div>
						<div id="${word.getText()}" class="guess_field"></div>
						<button class="guess_button"></button>
					</div>
				</div>
			</c:forEach>
		</div>
		<div class="redSide">
			<section>
				<article id="red counter" class="counter">8</article>
			</section>
			<div class="redCharacter"></div>
			<div class="players">
				<header class="operativeRed" id="red operative header">
					<span>Operative</span>
				</header>
				<div class="name" id="red operative name">-</div>
				<button id="red operative" class="joinButton">Als Operative
					beitreten</button>
				<header class="spymasterRed" id="red spymaster header">
					<span>Spymaster</span>
				</header>
				<div class="name" id="red spymaster name">-</div>
				<button id="red spymaster" class="joinButton">Als Spymaster
					beitreten</button>
			</div>
		</div>
		<div class="clue_panel">
			<input class="clue_field" name="clue" type="text"
				placeholder="Tippe hier deinen Hinweis"> <select
				class="clue_number" name="number" id="number">
				<option class="0" selected="selected">-</option>
				<option class="1">1</option>
				<option class="2">2</option>
				<option class="3">3</option>
				<option class="4">4</option>
				<option class="5">5</option>
				<option class="6">6</option>
				<option class="7">7</option>
				<option class="8">8</option>
				<option class="9">9</option>
				<option class="∞">∞</option>
			</select>
			<button class="clue_button" onclick="giveClue()">Hinweis
				geben</button>
		</div>
		<div class="bottom_panel">
			<div class="selected_clue_panel">
				<div class="selected_clue_text" id="selected_clue_text">Codenames</div>
				<div class="selected_clue_text" id="selected_clue_number">Nummer</div>
			</div>
			<button class="end_button" id="end_guess" onclick="endGuess()">Raten beenden</button>
		</div>
	</div>
	<div id="gameOverDialog">
		<div class="dialogInputPanel" id="gameOverPanel">
			<h3 id="gameOverHeadline"></h3>
			<button class="linkButton" onclick="toStartPage()">Neues Spiel</button>
		</div>
	</div>
</body>
</html>