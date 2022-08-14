package beans;


import java.util.UUID;


public class GameID
{
    private UUID gameId;

    public GameID()
    {
        this.gameId = UUID.randomUUID();
    }


    public UUID getGameID()
    {
        return gameId;
    }
}
