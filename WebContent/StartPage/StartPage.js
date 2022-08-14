function popup() {
	$('.modal').css('display', 'block');
	$('.modal-content').css('z-index', '11');
}

function popupclose() {
	$('.modal').css('display', 'none');
}

function rulesDialog() {
	$("#rulesDialog").css("visibility", "visible");
	if ($("#rulesDialog").dialog("instance") === undefined || !$("#rulesDialog").dialog("isOpen")) {
		$("#rulesDialog").dialog({
			draggable: false,
			resizable: false,
			width: 960,
		});

		$(".closeButton").on("click", function() {
			$("#rulesDialog").dialog("close");
		});
	}
	else {
		$("#rulesDialog").dialog("close");
	}
}
function startDialog() {
	$("#dialog-form").dialog({
		draggable: false,
		resizable: false,
		height: "auto",
		width: 600,
		modal: true,
	});

	$("#cancel").on("click", function() {
		$("#dialog-form").dialog("close");
	});
};

function ajaxCall() {
	var req = new XMLHttpRequest();
	req.open("GET", "../GameController");
	req.onreadystatechange = function redirect() {
		if (req.readyState == 4) {
			window.location.replace(req.responseURL);
		}
	}
	req.send();
}