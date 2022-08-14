package servlets;


import java.io.IOException;

import beans.Cards;
import beans.GameID;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;


@WebServlet
public class GameController extends HttpServlet
{
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException
    {
        Cards bean = new Cards();
        bean.setPathToCards(this.getServletContext().getRealPath("Files/cards.json"));
        String[] categories = request.getParameterValues("categories");
        for (String category : categories)
        {
            if (category.equals("basic"))
            {
                bean.setBasic(true);
            }
            if (category.equals("gaming"))
            {
                bean.setGaming(true);
            }
            if (category.equals("movies_and_series"))
            {
                bean.setMoviesAndSeries(true);
            }
        }
        request.getServletContext().setAttribute("cards", bean);
        response.sendRedirect("/Codenames/GamePage/game.jsp?gameId=" + new GameID().getGameID());
    }


    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException
    {
        doGet(request, response);
    }

}
