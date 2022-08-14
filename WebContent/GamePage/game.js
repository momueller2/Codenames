function cardClicked() {
	let card = $(this);
	var card_text = $(this).find(".card_text").text();

	if (card_text !== "") {
		if (card.data("selected") == null || card.data("selected") === false) {
			card.append($("<div>", { class: "selected-border" }));
			card.data("selected", true);
			incrementCounter();

		} else {
			card.children(".selected-border").remove();
			card.data("selected", false);
			decrementCounter();
		}
	}
}

function incrementCounter() {
	var counter = $(".clue_number").data("data");
	counter++;
	$(".clue_number").data("data", counter);
	$(".clue_number").val(counter);
}

function decrementCounter() {
	var counter = $(".clue_number").data("data");
	counter--;
	$(".clue_number").data("data", counter);
	if (counter === 0) {
		$(".clue_number").val("-");

	} else {
		$(".clue_number").val(counter);
	}
}

function guessClicked() {
	var guess_field = $(this).children(".guess_field");
	var card_text = $(this).children().first().text();
	var guess_text = guess_field.text();

	if (card_text !== "" && (guess_text === "" || guess_text === sessionStorage.getItem('playerName'))) {
		if (guess_field.data("visibility") == null || guess_field.data("visibility") === "hidden") {
			guess_field.data('visibility', "visible");
			guess_field.css('visibility', "visible");
			sendGuessTip("setVisible", guess_field.attr('id'), sessionStorage.getItem('playerName'));
		} else {
			guess_field.data('visibility', "hidden");
			guess_field.css('visibility', "hidden");
			sendGuessTip("setHidden", guess_field.attr('id'), sessionStorage.getItem('playerName'));
		}
	}
}

function copyLink() {
	var copyLink = document.getElementById("link");
	copyLink.select();
	copyLink.setSelectionRange(0, 99999);
	navigator.clipboard.writeText(copyLink.value);
	playerButtonClicked();
	$(".copiedLinkCaption").css("visibility", "visible");
	window.setTimeout("hideLinkCaption()", 2000);
}

function joinGame() {
	const player = $(this).attr('id').split(" ");
	join(player[0], player[1]);
	removeJoinButtons();
}

function removeJoinButtons() {
	$(".joinButton").css("display", "none");
	$("[class$='Side']").css("height", "35%");
}

function hideLinkCaption() {
	$(".copiedLinkCaption").css("visibility", "hidden")
}

function playerButtonClicked() {
	if ($(".roomLinkPanel").data("visible") == null || $(".roomLinkPanel").data("visible") === false) {
		$(".roomLinkPanel").css("visibility", "visible");
		$(".roomLinkPanel").data("visible", true);

	} else {
		$(".roomLinkPanel").css("visibility", "hidden");
		$(".roomLinkPanel").data("visible", false);
	}
}

function optionsButtonClicked() {
	if ($(".optionsPanel").data("visible") == null || $(".optionsPanel").data("visible") === false) {
		$(".optionsPanel").css("visibility", "visible");
		$(".optionsPanel").data("visible", true);

	} else {
		$(".optionsPanel").css("visibility", "hidden");
		$(".optionsPanel").data("visible", false);
	}
}

function toStartPage() {
	sessionStorage.clear();
	location.href = "../../Codenames/StartPage/StartPage.jsp";
}

function gameOverDialog() {
	$("#gameOverPanel").css("display", "flex");
	$("#gameOverDialog").dialog({
		resizable: false,
		height: "auto",
		width: 400,
		modal: true,
		classes: {
			"ui-dialog-buttonpane": "dialogButtonPanel",
			"ui-dialog": "nameDialog"
		},
	});
};

function nameDialog() {
	$("#nameInputPanel").css("display", "flex");
	$("#nameDialog").keypress(function(e) {
		if (e.keyCode == $.ui.keyCode.ENTER) {
			emptyCheck();
		}
	});
	$("#nameDialog").dialog({
		resizable: false,
		height: "auto",
		width: 400,
		modal: true,
		buttons: [
			{
				text: "Beitreten",
				"class": "dialogButton",
				click: emptyCheck,
			}
		],
		classes: {
			"ui-dialog-buttonpane": "dialogButtonPanel",
			"ui-dialog": "nameDialog"
		},
	});
};

function emptyCheck() {
	if (!document.getElementById("nameInput").value == "") {
		nameEntered();
	}
}

function nameEntered() {
	sessionStorage.setItem('playerName', document.getElementById("nameInput").value);
	$(".optionsButton").text(sessionStorage.getItem('playerName'));
	document.getElementById("nickname").value = sessionStorage.getItem('playerName');
	$("#nameDialog").dialog("close");
}

function updateName() {
	sessionStorage.setItem('playerName', document.getElementById("nickname").value);
	$(".optionsButton").text(sessionStorage.getItem('playerName'));
}

$(function() {
	$("#rulesDialog").css("visibility", "visible");
	$("#rulesDialog").dialog({
		autoOpen: false,
		draggable: false,
		resizable: false,
		width: 960,
	});

	$(".rulesButton").on("click", function() {
		if ($("#rulesDialog").dialog("isOpen")) {
			$("#rulesDialog").dialog("close");
		} else {
			$("#rulesDialog").dialog("open");
		}
	});
});

function register() {
	$(".guess_button").on("click", guess)
	$(".card div").on("click", guessClicked)
	$(".closeButton").on("click", function() {
		$("#rulesDialog").dialog("close");
	})
	$(".playerCount").on("click", playerButtonClicked);
	$(".optionsButton").on("click", optionsButtonClicked);
	$(".linkButton").on("click", copyLink);
	$(".joinButton").on("click", joinGame);
	$(".updateButton").on("click", updateName);
	$(".optionsButton").text(sessionStorage.getItem('playerName'));
	document.getElementById("nickname").value = sessionStorage.getItem('playerName');
	document.getElementById("link").value = window.location.href;
	if (!sessionStorage.getItem('playerName')) {
		nameDialog();
	}
	if (sessionStorage.getItem('player')) {
		if (sessionStorage.getItem('player').endsWith("spymaster")) {
			$(".grid").load("spymasterGrid.jsp");
			setTimeout(() => {
				$(".card > div[id=" + team + "]").parent().on("click", cardClicked)
				$(".clue_number").data("data", 0);
			}, 100);
		}
		removeJoinButtons();
		document.getElementById(sessionStorage.getItem('player') + " name").textContent = sessionStorage.getItem('playerName');
	}
}

$(window).on("load", register);