<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Codenames</title>
<link rel="stylesheet" href="Start_Page.css">
<script src="StartPage.js"></script>
<link rel="stylesheet" type="text/css"
	href="../JQuerySource/jquery-ui-1.13.1/jquery-ui.css">
<script src="../JQuerySource/jquery-3.6.0.js"></script>
<script src="../JQuerySource/jquery-ui-1.13.1/jquery-ui.js"></script>
</head>
<body>
	<div class="background"></div>
	<div class="background-image"></div>
	<img id="titleImg" src="assets/backgrounds/titleImg.webp">
	<div>
		<button class="start" onclick="startDialog()">Start</button>
	</div>
	<button class="help" onclick="rulesDialog()">Anleitung</button>
	<div id="rulesDialog" title="Codenames Rules">
		<nav class="rulesTitlePanel">
			<h2 class="rulesTitle">Codenames</h2>
			<p class="rulesUndertitle">Team VS Team, 4 Spieler</p>
			<button class="closeButton"></button>
		</nav>
		<section class="rulesContent">
			<p>
				Codenames ist ein Spiel für zwei Teams. Das Spielfeld ist aufgebaut aus einem 5x5 Raster. Manche der Karten werden heimlich auf das
				<b><font color="#a21414">rote Team</font></b>, andere auf das <b><font color="#144da2">blaue Team</font></b> verteilt.
				Ein Spieler jedes Teams ist ein <b>Spymaster</b> und nur der Spymaster sieht, welche Karten zu welchem Team gehören.
				Spymasters versuchen, den <b>Operatives</b> einen Tipp zu geben, damit dieser die zu seinem Team zugehörigen Begriffe herausfindet.
				Das erste Team, welches alle seine Karten aufgedeckt hat, gewinnt.
			</p>
			<blockquote>
				<strong>Bitte beachte:</strong> Codenames hat keine festen Regeln. Diese können nach belieben angepasst werden.
			</blockquote>
			<h2>Teamaufteilung</h2>
			<p>
				Teile alle Spieler in zwei Teams, <b><font color="#a21414">rot</font></b>
				und <b><font color="#144da2">blau</font></b>.
			</p>
			<section class="rulesWith2Figures">
				<figure>
					<figcaption>
						Ein Spieler jedes Teams sollte auf den <strong class="bg-yellow">Als Spymaster beitreten</strong>-Knopf klicken. Derjenige sieht dann die Farbe aller Karten.
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
						Alle anderen sollten auf den <strong class="bg-yellow">Als Operative beitreten</strong>-Knopf klicken. Sie sehen die Farben nicht.
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
			<p>
				Spymasters können Hinweise geben. Wähle die Wörter aus, für welche du einen Hinweis geben möchtest, und schreibe deinen Hinweis, welcher sich auf all diese Wörter beziehen sollte daneben.
				Deinen Teammitglieder sehen deinen Hinweis und die Anzahl der damit verbundenen Karten.
			</p>
			<figure>
				<figcaption class="figureCaption">
					<section>Wenn du einen Tipp gibst ...</section>
					<section class="text-right">... sehen deine Operatives nur das Wort und die Zahl.</section>
				</figcaption>
				<div class="figureDiv">
					<img
						src="../GamePage/assets/instruction/give_clues.png"
						alt="give_clue"
						class="figure">
				</div>
			</figure>
			<p>&nbsp;</p>
			<p>
				<img
					src="../GamePage/assets/instruction/assassin_card_blank.png"
					alt="assassin card"
					style="float: left; padding-right: 1rem; padding-top: 0.3rem;"
					width="90"> 
					Pass auf die schwarze Karte auf - Sie ist ein versteckter Assassin!
					Vermeide Wörter, die damit in Verbindung stehen. 
			</p>
			<p>&nbsp;</p>
			<blockquote>
				<strong>Notiz:</strong> Manche Tipps sind nicht erlaubt, zum Beispiel ein Wort was bereits im Raster steht, in Teilen wiederzuverwenden. Siehe <a href="#valid-clues">Valide
					Tipps</a>.
			</blockquote>
			<h2>Erraten</h2>
			<p>Operatives erraten die Wörter auf Grundlage des Hinweises des Spymasters.</p>
			<section class="rulesWith2Figures">
				<figure>
					<figcaption>Du kannst deine Gedanken mit deinem Team teilen, indem du auf eine der Karten klickst, welche du denkst, dass es die sein könnte.</figcaption>
					<div class="figureDiv">
						<img
							src="../GamePage/assets/instruction/give_guess.png"
							alt="give_guess"
							class="figure">
					</div>
				</figure>
				<figure>
					<figcaption>
						Um deine Schätzung offiziell zu machen, klicke auf den <img
							src="../GamePage/assets/instruction/icon_tap_card.png"
							class="rulesFingerIcon">-Knopf. Das Spiel wird dir dann die Antwort zeigen.
					</figcaption>
					<div class="figureDiv">
						<img
							src="../GamePage/assets/instruction/official_guess.png"
							alt="official_guess"
							class="figure">
					</div>
				</figure>
			</section>
			<p>&nbsp;</p>
			<p>Wenn du eine richtige Karte errätst, darfst du nochmal raten.
				Versuche die Anzahl die dein Spymaster angegeben hat zu nutzen.</p>
			<blockquote>
				<strong>Notiz:</strong> Du kannst Karten aus vorherigen Runden erraten. Siehe <a href="#number-of-guesses">Anzahl der Ratungen</a>.
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
			<p>Die Teams wechseln sich ab. Ein Team gewinnt, wenn es alle seine Karten erraten hat, und verliert, wenn es denn Assassin trifft!</p>
			<h2>Notiz</h2>
			<details>
				<summary class="rulesSummary" id="valid-clues">Valid clues</summary>
				<section>
					<ul>
						<li>Der Hinweis ist strickt auf <b>ein Wort und eine Zahl</b> beschränkt.
							Von dem Spymaster wird erwartet keine Kommentare zu den Rateversuchen zu geben, um keine zusätzliche Hilfe zu sein
						</li>
						<li>Dein Hinweis soll nur <b>ein Wort</b> sein, aber Spymaster können sich auf 
							andere Regeln einigen. Zum Beispiel könnt ihr zwei Wörter Städtenamen erlaub, wie zum Beispiel NEW YORK.
						</li>
						<li>Benutze <b>keine Form von Wörtern im Raster</b> als ein Hinweis. 
							Benutze nicht ZUCKER als Hinweis für ZUCKER und SCHOCKOLADE und versuche auch nicht,
							diese Regel zu umgehen, indem du ZUCKRIG oder ZUCKERROHR
						</li>
						<li>Gib Hinweise <b>in der vereinbarten Sprache</b>. Benutze keine andere Sprache für extra Information.
						</li>
						<li>Der Hinweis muss mit <b>der Bedeutung der Wörter</b> übereinstimmer. 
							Gib keine Hinweise über die Buchstaben im Wort oder die Position im Raster.
						</li>
					</ul>
					<p>Behalte deine Hinweise im Sinne des Spiels, und wenn du dir nicht sicher bist, kannst du immer noch 
					die anderen Spymaster fragen, was sie erlauben.
					</p>
				</section>
			</details>
			<details>
				<summary class="rulesSummary" id="number-of-guesses">Anzahl der Ratungen</summary>
				<section>
					<p style="margin-bottom: 1.1rem;">
						Die Zahl in deinem Hinweis sagt deinem Team, wieviele Wörter mit deinem Hinweis gemeint sind
						Sie können immer <b>eine extra Wort</b> erraten. Üblicherweise ein Wort, das sie in vorherigen Runden nicht erraten haben.
					</p>
					<section class="numberOfGuessesRuleText">
						<ul>
							<li>Wenn du willst, dass dein Team mehr Karten erraten soll, kannst du per hand <b>Unendlich ∞</b> auswählen. 
								Sie können dann so viele Wörter auswählen wie sie wollen. (wissen aber nicht, wieviele Wörter du mit 
								deinem Hinweis meintest)
							</li>
							<li>Du kannst auch <b>-</b> für deinen Tipp benutzen. Es erlaubt deinem Team soviel zu erraten wie sie wollen.
								Der Unterschied ist, dass du damit sagst, das dein Tipp auf kein Wort deiner Farbe hinweist.
								Du kannst es zum Beispiel benutzen, wenn du verhindern willst, dass dein Team eine gegnerische Karte errät.
							</li>
						</ul>
						
					</section>
					<p>
						Egal wieviele Tipps du einstellst, dein Team muss immer
						<b>mindestens eine Karte erraten</b>.
					</p>
				</section>
			</details>
		</section>
	</div>
	<button class="impressum"
		onclick="window.location.href = '../StartPage/Impressum.html'">Impressum</button>
	<div id="dialog-form" title="Create Room">
		<form action="../GameController" method="post">
			<div>
				<h3>Wähle, welche Kategorien du gerne verwenden möchtest:</h3>
				<div id="checkBox">
					<input type="checkbox" id="allCat" name="categories" value="basic" checked />
					<label style="word-wrap: break-word">Alle Kategorien</label>
				</div>
				<div id="checkBox">
					<input type="checkbox" id="allCat" name="categories" value="gaming" /> 
					<label style="word-wrap: break-word">Gaming</label>
				</div>
				<div id="checkBox">
					<input type="checkbox" id="allCat" name="categories" value="movies_and_series" /> 
					<label style="word-wrap: break-word">Filme und Serien</label>
				</div>
			</div>
			<div class="dialogButtonPanel">
				<input type="submit" class="dialogButton" value="Erstelle Raum">
				<button type="Button" class="dialogButton" id="cancel">Abbrechen</button>
			</div>
		</form>
	</div>
	<img id="maleAgentImg" src="assets/backgrounds/agent_male.webp">
	<img id="femaleAgentImg" src="assets/backgrounds/agent_female.webp">
</body>
</html>