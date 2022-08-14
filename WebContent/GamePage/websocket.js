const gameId = new URLSearchParams(window.location.search).get("gameId");
var webSocket = new WebSocket("ws://" + location.hostname + ":8080/Codenames/WebSocket/" + gameId);

webSocket.onerror = function(event) {
	onError(event)
};

webSocket.onmessage = function(event) {
	onMessage(event)
};

function onMessage(event) {
	const response = JSON.parse(event.data);
	if (response.method == "visible") {
		document.getElementById(response.id).textContent = response.name;
		var guess_field = $("#" + response.id);
		guess_field.css("visibility", "visible");
		guess_field.data('visibility', "visible");
	}
	if (response.method == "hidden") {
		document.getElementById(response.id).textContent = "";
		var guess_field = $("#" + response.id);
		guess_field.css("visibility", "hidden");
		guess_field.data('visibility', "hidden");
	}
	if (response.method == "join") {
		document.getElementById(response.id).remove();
		document.getElementById(response.id + " name").textContent = response.name;
	}
	if (response.method == "spymasterTurn") {
		showInfo("Gib deinem Team einen Hinweis");
		$(".clue_panel").css("visibility", "visible");
	}
	if (response.method == "showClue") {
		$(".clue_panel").css("visibility", "hidden");
		$(".selected_clue_panel").css("visibility", "visible");
		$("#selected_clue_text").text(response.word);
		$("#selected_clue_number").text(response.number);
		if (sessionStorage.getItem('player').startsWith("red")) {
			$(".selected_clue_text").css("border", "7px solid #d74d25");
		}
		else {
			$(".selected_clue_text").css("border", "7px solid #69cddd");
		}
	}
	if (response.method == "operativeTurn") {
		$(".guess_button").each(function() {
			var card_text = $(this).parent().children().first().text();
			if (card_text !== "") {
				$(this).css("visibility", "visible");
			}
		});
		$(".end_button").css("visibility", "visible");
	}
	if (response.method == "guessResponse") {
		var card = $("#" + response.word).parent();
		card.find(".card_text").text("");
		card.find(".guess_button").css("visibility", "hidden");
		card.find(".guess_field").css("visibility", "hidden");
		var counter = $("article[id=" + "'" + response.team + " counter" + "'" + "]");
		counter.text(Number(counter.text()) + Number(response.point));
		switch (response.team) {
			case "red":
				card.css("background-image", "url(assets/backgrounds/red_character_back.png)");
				break;
			case "blue":
				card.css("background-image", "url(assets/backgrounds/blue_character_back.png)");
				break;
			case "white":
				card.css("background-image", "url(assets/backgrounds/white_character_back.png)");
				break;
			case "black":
				card.css("background-image", "url(assets/backgrounds/black_character_back.png)");
				break;
		}
	}
	if (response.method == "info") {
		showInfo(response.message);
	}
	if (response.method == "reset") {
		$(".clue_panel").css("visibility", "hidden");
		$(".clue_field").val("");
		$(".clue_number").val("-");
		$(".selected_clue_panel").css("visibility", "hidden");
		$(".guess_button").css("visibility", "hidden");
		$(".guess_field").css("visibility", "hidden");
		$("#selected_clue_text").text("");
		$("#selected_clue_number").text("");
		$(".card").data("selected", false);
		$(".clue_number").data("data", 0);
		$(".end_button").css("visibility", "hidden");
	}
	if (response.method == "gameOver") {
		if (sessionStorage.getItem('player').startsWith(response.team)) {
			$("#gameOverHeadline").text("Dein Team hat verloren!");
		}
		else {
			$("#gameOverHeadline").text("Dein Team hat gewonnen!");
		}
		gameOverDialog();
	}
	if (response.method == "synchronize") {
		synchronize(response.sessionId);
	}
	if (response.method == "error") {
		console.log("Error Page");
	}
}

function synchronize(sessionId) {
	var message = JSON.stringify({
		method: "synchronize",
		sessionId: sessionId,
		red_spymaster: document.getElementById("red spymaster name").textContent,
		blue_spymaster: document.getElementById("blue spymaster name").textContent,
		red_operative: document.getElementById("red operative name").textContent,
		blue_operative: document.getElementById("blue operative name").textContent
	})
	webSocket.send(message);
	return false;
}

function guess() {
	var card = $(this).parent();
	var message = JSON.stringify({
		method: "guess",
		color: card.get(0).dataset.color,
		team: sessionStorage.getItem('player').split(" ")[0],
		word: card.find(".card_text").text()
	})
	webSocket.send(message);
	return false;
}

function showInfo(info) {
	$(".info").text(info);
}

function onError(event) {
	console.log("Error ", event);
}

function sendGuessTip(method, id, name) {
	var message = JSON.stringify({
		method: method,
		id: id,
		name: name,
		player: sessionStorage.getItem('player')
	})
	webSocket.send(message);
	return false;
}

function startGame() {
	webSocket.send(JSON.stringify({
		method: "create"
	}));
	return false;
}

function giveClue() {
	var word = $(".clue_field").val();
	var number = $(".clue_number").val();

	if (word === "" || number === "-") {
		return;
	}

	$(".selected-border").css("visibility", "hidden");
	if (number == "∞") {
		number = "max"
	}
	var message = JSON.stringify({
		method: "giveClue",
		word: word,
		number: number,
		player: sessionStorage.getItem('player')
	})
	webSocket.send(message);
	return false;
}

function endGuess() {
	var message = JSON.stringify({
		method: "endGuess",
		team: sessionStorage.getItem('player').split(" ")[0],
	})
	webSocket.send(message);
	return false;
}

function join(team, role) {
	var message = JSON.stringify({
		method: "join",
		team: team,
		role: role,
		gameId: gameId,
		name: sessionStorage.getItem('playerName')
	})
	if (role == "spymaster") {
		$(".grid").load("spymasterGrid.jsp");
		setTimeout(() => {
			$(".card > div[id=" + team + "]").parent().on("click", cardClicked)
			$(".clue_number").data("data", 0);
		}, 100);
	}
	sessionStorage.setItem('player', team + " " + role);
	webSocket.send(message);
	return false;
}