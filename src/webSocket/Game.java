package webSocket;


import java.io.IOException;
import java.util.HashMap;
import java.util.HashSet;
import java.util.LinkedHashMap;
import java.util.Map;
import java.util.Map.Entry;
import java.util.Objects;
import java.util.Set;

import org.json.JSONObject;

import jakarta.websocket.Session;


public class Game
{
    private Set<Session> sessions = new HashSet<>();
    private Map<String, Session> selectedPlayers = new HashMap<>();
    private int blueCards;
    private int redCards;
    private String gameId;
    private boolean redTurn, blueTurn;
    private int numberOfGuesses;

    public Game(String gameId)
    {
        this.gameId = gameId;
        this.redTurn = false;
        this.blueTurn = false;
        this.numberOfGuesses = 0;
        this.blueCards = 9;
        this.redCards = 8;
    }


    public boolean addSession(Session session)
    {
        if (sessions.size() < 4)
        {
            return sessions.add(session);
        }
        else
        {
            return false;
        }
    }


    public void removeSession(Session session)
    {
        sessions.remove(session);
        for (Entry<String, Session> player : selectedPlayers.entrySet())
        {
            if (player.getValue() != null && player.getValue().equals(session))
            {
                player.setValue(null);
            }
        }
    }


    public boolean hasSession(Session session)
    {
        for (Session gameSession : sessions)
        {
            if (gameSession.equals(session))
            {
                return true;
            }
        }
        return false;
    }


    public void addPlayer(Session session, String team, String role)
    {
        selectedPlayers.put(team + " " + role, session);
        if (selectedPlayers.size() == 4 && !(blueTurn || redTurn))
        {
            blueTurn = true;
            startTurn();
        }
    }


    public String getGameId()
    {
        return gameId;
    }


    public Set<Session> getSessions()
    {
        return sessions;
    }


    @Override
    public boolean equals(Object obj)
    {
        if (obj == null)
        {
            return false;
        }
        final Game game = (Game)obj;
        if (!game.getGameId().equals(gameId))
        {
            return false;
        }
        return true;
    }


    @Override
    public int hashCode()
    {
        return Objects.hash(gameId);
    }


    public void guess(Session session, String color, String team, String word) throws IOException
    {
        if (color.equals("white"))
        {
            sendGuessResponse(session, "white", word, 0);
            switchTeam(session);
        }
        else if (color.equals("black"))
        {
            sendGameOver(session, team);
        }
        else if (color.equals(team))
        {
            sendGuessResponse(session, team, word, -1);
            numberOfGuesses--;

            if (team.equals("red"))
            {
                this.redCards--;

                if (redCards == 0)
                {
                    sendGameOver(session, "blue");
                    return;
                }
            }
            if (team.equals("blue"))
            {
                this.blueCards--;

                if (blueCards == 0)
                {
                    sendGameOver(session, "red");
                    return;
                }
            }

            if (numberOfGuesses == 0)
            {
                switchTeam(session);
            }
        }
        else
        {
            sendGuessResponse(session, color, word, -1);
            switchTeam(session);
        }
    }


    public void join(Session session, LinkedHashMap<String, Object> result) throws IOException
    {
        JSONObject response = new JSONObject();
        response.put("method", "join");
        response.put("name", result.get("name").toString());
        response.put("id", result.get("team").toString() + " " + result.get("role").toString());
        response.put("value", true);

        addPlayer(session, result.get("team").toString(), result.get("role").toString());
        sendResponseToSessions(session, response, false);
    }


    public void changeVisibility(String visibility, Session session, LinkedHashMap<String, Object> result) throws IOException
    {
        JSONObject response = new JSONObject();
        response.put("method", visibility);
        response.put("id", result.get("id"));
        response.put("name", result.get("name"));
        sendResponseToSessions(session, response, true);
    }


    public void sendResponseToSessions(Session session, JSONObject response, boolean sendToOwnSession) throws IOException
    {
        for (Session gameSession : getSessions())
        {
            if (!gameSession.equals(session) || sendToOwnSession)
            {
                gameSession.getBasicRemote().sendText(response.toString());
            }
        }
    }


    public void sendResponseToSessions(Map<Player, JSONObject> responses)
    {
        for (Player player : responses.keySet())
        {
            try
            {
                selectedPlayers.get(player.toString()).getBasicRemote().sendText(responses.get(player).toString());
            }
            catch (IOException e)
            {
                e.printStackTrace();
            }
        }
    }


    public void showClue(Session session, LinkedHashMap<String, Object> result) throws IOException
    {
        if (((String)result.get("number")).equals("max"))
        {
            numberOfGuesses = Integer.MAX_VALUE;
            result.put("number", "∞");
        }
        else
        {
            numberOfGuesses = Integer.parseInt((String)result.get("number")) + 1;
        }
        JSONObject response = new JSONObject();
        response.put("method", "showClue");
        response.put("word", result.get("word"));
        response.put("number", result.get("number"));
        sendResponseToSessions(session, response, true);
        updateInfo(result);
    }


    private void sendGuessResponse(Session session, String team, String word, int point) throws IOException
    {
        JSONObject response = new JSONObject();
        response.put("method", "guessResponse");
        response.put("team", team);
        response.put("word", word);
        response.put("point", point);
        sendResponseToSessions(session, response, true);
    }


    private void sendGameOver(Session session, String team) throws IOException
    {
        JSONObject response = new JSONObject();
        response.put("method", "gameOver");
        response.put("team", team);
        sendResponseToSessions(session, response, true);
    }


    private void updateInfo(LinkedHashMap<String, Object> result)
    {
        Map<Player, JSONObject> responses = new HashMap<>();
        if (result.get("player").toString().contains("red spymaster"))
        {
            responses.put(Player.RED_SPYMASTER, getResponse("operativeGuessing"));
            responses.put(Player.BLUE_SPYMASTER, getResponse("opponentOperativeTurn"));
            responses.put(Player.BLUE_OPERATIVE, getResponse("opponentOperativeTurn"));
            responses.put(Player.RED_OPERATIVE, getResponse("operativeTurn"));

            showGuessButton(Player.RED_OPERATIVE);
        }
        else if (result.get("player").toString().contains("blue spymaster"))
        {
            responses.put(Player.RED_SPYMASTER, getResponse("opponentOperativeTurn"));
            responses.put(Player.BLUE_SPYMASTER, getResponse("operativeGuessing"));
            responses.put(Player.BLUE_OPERATIVE, getResponse("operativeTurn"));
            responses.put(Player.RED_OPERATIVE, getResponse("opponentOperativeTurn"));

            showGuessButton(Player.BLUE_OPERATIVE);
        }
        sendResponseToSessions(responses);
    }


    private void showGuessButton(Player player)
    {
        Map<Player, JSONObject> responses = new HashMap<>();
        JSONObject response = new JSONObject();
        response.put("method", "operativeTurn");
        responses.put(player, response);
        sendResponseToSessions(responses);
    }


    public void switchTeam(Session session) throws IOException
    {
        if (blueTurn)
        {
            this.blueTurn = false;
            this.redTurn = true;
        }
        else if (redTurn)
        {
            this.blueTurn = true;
            this.redTurn = false;
        }
        resetView(session);
        startTurn();
        numberOfGuesses = 0;
    }


    private void resetView(Session session) throws IOException
    {
        JSONObject response = new JSONObject();
        response.put("method", "reset");
        sendResponseToSessions(session, response, true);
    }


    private void startTurn()
    {
        if (blueTurn)
        {
            Map<Player, JSONObject> responses = new HashMap<>();
            responses.put(Player.BLUE_SPYMASTER, getResponse("blueSpymasterTurn"));
            responses.put(Player.BLUE_OPERATIVE, getResponse("waitSpymaster"));
            responses.put(Player.RED_SPYMASTER, getResponse("opponentSpymasterTurn"));
            responses.put(Player.RED_OPERATIVE, getResponse("opponentSpymasterTurn"));
            sendResponseToSessions(responses);
        }
        else if (redTurn)
        {
            Map<Player, JSONObject> responses = new HashMap<>();
            responses.put(Player.RED_SPYMASTER, getResponse("redSpymasterTurn"));
            responses.put(Player.RED_OPERATIVE, getResponse("waitSpymaster"));
            responses.put(Player.BLUE_SPYMASTER, getResponse("opponentSpymasterTurn"));
            responses.put(Player.BLUE_OPERATIVE, getResponse("opponentSpymasterTurn"));
            sendResponseToSessions(responses);
        }
    }


    private JSONObject getResponse(String message)
    {
        JSONObject response = new JSONObject();
        switch (message)
        {
            case "opponentSpymasterTurn":
                response = new JSONObject();
                response.put("method", "info");
                response.put("message", "Der gegnerische Spymaster spielt, warte auf deinen Zug");
                return response;
            case "blueSpymasterTurn":
                response = new JSONObject();
                response.put("method", "spymasterTurn");
                return response;
            case "redSpymasterTurn":
                response = new JSONObject();
                response.put("method", "spymasterTurn");
                return response;
            case "waitSpymaster":
                response = new JSONObject();
                response.put("method", "info");
                response.put("message", "Warte bis dein Spymaster dir einen Hinweis gibt");
                return response;
            case "operativeGuessing":
                response = new JSONObject();
                response.put("method", "info");
                response.put("message", "Dein Operative rätselt gerade");
                return response;
            case "operativeTurn":
                response = new JSONObject();
                response.put("method", "info");
                response.put("message", "Versuche ein Wort zu erraten");
                return response;
            case "opponentOperativeTurn":
                response = new JSONObject();
                response.put("method", "info");
                response.put("message", "Der gegnerische Operative spielt, warte auf deinen Zug");
                return response;
            case "reset":
                response = new JSONObject();
                response.put("method", "reset");
            default:
                return new JSONObject();
        }
    }


    public void synchronize(LinkedHashMap<String, Object> result) throws IOException
    {
        for (Session session : sessions)
        {
            if (session.getId().equals(result.get("sessionId")))
            {
                synchronizeNames(result, session);
            }
        }
    }


    private void synchronizeNames(LinkedHashMap<String, Object> result, Session session) throws IOException
    {
        if (!result.get("red_spymaster").equals("-"))
        {
            JSONObject response = new JSONObject();
            response.put("method", "join");
            response.put("name", result.get("red_spymaster").toString());
            response.put("id", "red spymaster");
            session.getBasicRemote().sendText(response.toString());
        }
        if (!result.get("blue_spymaster").equals("-"))
        {
            JSONObject response = new JSONObject();
            response.put("method", "join");
            response.put("name", result.get("blue_spymaster").toString());
            response.put("id", "blue spymaster");
            session.getBasicRemote().sendText(response.toString());
        }
        if (!result.get("red_operative").equals("-"))
        {
            JSONObject response = new JSONObject();
            response.put("method", "join");
            response.put("name", result.get("red_operative").toString());
            response.put("id", "red operative");
            session.getBasicRemote().sendText(response.toString());
        }
        if (!result.get("blue_operative").equals("-"))
        {
            JSONObject response = new JSONObject();
            response.put("method", "join");
            response.put("name", result.get("blue_operative").toString());
            response.put("id", "blue operative");
            session.getBasicRemote().sendText(response.toString());
        }
    }


    public void synchronizePlayer(Session session)
    {
        for (Entry<String, Session> player : selectedPlayers.entrySet())
        {
            if (player.getValue() == null)
            {
                player.setValue(session);
            }
        }
    }
}
