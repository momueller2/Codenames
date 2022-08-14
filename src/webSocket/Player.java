package webSocket;

public enum Player
{
    RED_SPYMASTER("red", "spymaster"), RED_OPERATIVE("red", "operative"), 
    BLUE_SPYMASTER("blue", "spymaster"), BLUE_OPERATIVE("blue", "operative");
    
    Player(String team, String role)
    {
        this.team = team;
        this.role = role;
    }
    
    private String team;
    private String role;

    public String getTeam()
    {
        return team;
    }


    public String getRole()
    {
        return role;
    }
    
    public String toString() 
    {
        return team.toString() + " " + role.toString();
    }
}
