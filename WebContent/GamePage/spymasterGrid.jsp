<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<div class="grid">
	<c:forEach var="word" items="${cards.randomCards}"
		varStatus="loopState">
		<div class="card">
			<div id="${word.getColor()}">
				<div class="card_text">${word.getText()}</div>
				<div id="${word.getText()}" class="guess_field"></div>
			</div>
		</div>
	</c:forEach>
</div>
