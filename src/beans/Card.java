package beans;


import java.util.Objects;


public class Card
{
    private String color;
    private String text;

    public Card()
    {
        this.color = "white";
        this.text = "";
    }


    public String getColor()
    {
        return color;
    }


    public void setColor(String color)
    {
        this.color = color;
    }


    public String getText()
    {
        return text;
    }


    public void setText(String text)
    {
        this.text = text;
    }


    @Override
    public boolean equals(Object obj)
    {
        if (obj == null)
        {
            return false;
        }
        final Card card = (Card)obj;
        if (!card.getColor().equals(color) && !card.getText().equals(text))
        {
            return false;
        }
        return true;
    }


    @Override
    public int hashCode()
    {
        return Objects.hash(color, text);
    }
}
