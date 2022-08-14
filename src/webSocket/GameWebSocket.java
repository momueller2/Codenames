package webSocket;


import java.io.IOException;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.LinkedHashMap;
import java.util.List;

import org.apache.tomcat.util.json.JSONParser;
import org.json.JSONException;
import org.json.JSONObject;

import jakarta.websocket.OnClose;
import jakarta.websocket.OnError;
import jakarta.websocket.OnMessage;
import jakarta.websocket.OnOpen;
import jakarta.websocket.Session;
import jakarta.websocket.server.PathParam;
import jakarta.websocket.server.ServerEndpoint;


@ServerEndpoint("/WebSocket/{gameId}")
public class GameWebSocket
{
    private static List<Game> games = new ArrayList<>();

    @OnOpen
    public void onOpen(Session session, @PathParam("gameId") String gameId) throws JSONException, IOException
    {
        System.out.println(session.getId() + " has opened a connection");
        createRoom(session, gameId);
        if (!joinRoom(session, gameId))
        {
            try
            {
                JSONObject response = new JSONObject();
                response.put("method", "error");
                session.getBasicRemote().sendText(response.toString());
            }
            catch (IOException e)
            {
                e.printStackTrace();
            }
        }
    }


    private void createRoom(Session session, String gameId)
    {
        Game newGame = new Game(gameId);
        if (!games.contains(newGame))
        {
            games.add(newGame);
        }
    }


    private boolean joinRoom(Session session, String gameId) throws IOException
    {
        for (Game game : games)
        {
            if (game.getGameId().equals(gameId) && !game.hasSession(session))
            {
                game.addSession(session);
                synchronize(game, session);
                return true;
            }
        }
        return false;
    }


    private void synchronize(Game game, Session session) throws IOException
    {
        if (game.getSessions().size() > 0)
        {
            Session firstSession = game.getSessions().iterator().next();
            JSONObject response = new JSONObject();
            response.put("method", "synchronize");
            response.put("sessionId", session.getId());
            firstSession.getBasicRemote().sendText(response.toString());
            game.synchronizePlayer(session);
        }
    }


    @OnMessage
    public void onMessage(String message, Session session)
    {
        LinkedHashMap<String, Object> result;
        try
        {
            result = (LinkedHashMap<String, Object>)new JSONParser(message).parse();
            switch (result.get("method").toString())
            {
                case "setVisible":
                    getGame(session).changeVisibility("visible", session, result);
                    break;
                case "setHidden":
                    getGame(session).changeVisibility("hidden", session, result);
                    break;
                case "join":
                    joinGame(session, result);
                    break;
                case "giveClue":
                    getGame(session).showClue(session, result);
                    break;
                case "guess":
                    getGame(session).guess(session, (String)result.get("color"), (String)result.get("team"), (String)result.get("word"));
                    break;
                case "synchronize":
                    getGame(session).synchronize(result);
                    break;
                case "endGuess":
                    getGame(session).switchTeam(session);
                    break;
                default:
                    break;
            }
        }
        catch (org.apache.tomcat.util.json.ParseException | IOException e)
        {
            e.printStackTrace();
        }
    }


    private Game getGame(Session session)
    {
        for (Game game : games)
        {
            if (game.hasSession(session))
            {
                return game;
            }
        }
        return null;
    }


    private void joinGame(Session session, LinkedHashMap<String, Object> result) throws IOException
    {
        JSONObject response = new JSONObject();
        response.put("method", "join");
        response.put("value", false);
        response.put("name", result.get("name").toString());
        response.put("id", result.get("team").toString() + " " + result.get("role").toString());
        for (Game game : games)
        {
            if (game.getGameId().equals(result.get("gameId")))
            {
                game.join(session, result);
            }
        }
        session.getBasicRemote().sendText(response.toString());
    }


    @OnClose
    public void onClose(Session session)
    {
        removePlayer(session);
        System.out.println("Session " + session.getId() + " has ended");
    }


    private void removePlayer(Session session)
    {
        Iterator<Game> iterator = games.iterator();
        while (iterator.hasNext())
        {
            Game game = iterator.next();
            game.removeSession(session);
            if (game.getSessions().size() == 0)
            {
                iterator.remove();
            }
        }
    }


    @OnError
    public void onError(Throwable e, Session session)
    {
        e.printStackTrace();
        onClose(session);
    }
}
