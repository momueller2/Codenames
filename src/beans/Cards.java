package beans;


import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.util.ArrayList;
import java.util.Collections;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Map.Entry;
import java.util.Set;

import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;


public class Cards
{
    private String pathToCards;
    private Set<Card> randomCards;
    private boolean basic, gaming, movies_and_series;

    public Cards()
    {
        randomCards = new HashSet<>();
        basic = false;
        gaming = false;
        movies_and_series = false;
    }


    public String getPathToCards()
    {
        return pathToCards;
    }


    public boolean hasBasic()
    {
        return basic;
    }


    public boolean hasGaming()
    {
        return gaming;
    }


    public boolean hasMoviesAndSeries()
    {
        return movies_and_series;
    }


    public Set<Card> getRandomCards()
    {
        List<String> selectedWords = setSelectedWords();
        Collections.shuffle(selectedWords);

        if (randomCards.size() == 0)
        {
            for (int i = 0; i < 25; i++)
            {
                if (i <= 8)
                {
                    Card card = new Card();
                    card.setColor("blue");
                    card.setText(selectedWords.get(i).toUpperCase());
                    randomCards.add(card);
                }
                if (i > 8 && i <= 16)
                {
                    Card card = new Card();
                    card.setColor("red");
                    card.setText(selectedWords.get(i).toUpperCase());
                    randomCards.add(card);
                }
                if (i > 16 && i <= 23)
                {
                    Card card = new Card();
                    card.setColor("white");
                    card.setText(selectedWords.get(i).toUpperCase());
                    randomCards.add(card);
                }
                if (i == 24)
                {
                    Card card = new Card();
                    card.setColor("black");
                    card.setText(selectedWords.get(i).toUpperCase());
                    randomCards.add(card);
                }
            }
        }
        return randomCards;
    }


    public void setBasic(boolean basic)
    {
        this.basic = basic;
    }


    public void setGaming(boolean gaming)
    {
        this.gaming = gaming;
    }


    public void setMoviesAndSeries(boolean movies_and_series)
    {
        this.movies_and_series = movies_and_series;
    }


    private List<String> setSelectedWords()
    {
        List<String> selectedWords = new ArrayList<>();
        Map<String, String[]> jsonConvertedMap = readWords();
        if (basic)
        {
            getWords("Basic", jsonConvertedMap, selectedWords);
        }
        if (gaming)
        {
            getWords("Gaming", jsonConvertedMap, selectedWords);
        }
        if (movies_and_series)
        {
            getWords("Serien und Filme", jsonConvertedMap, selectedWords);
        }
        return selectedWords;
    }


    private List<String> getWords(String category, Map<String, String[]> jsonConvertedMap, List<String> selectedWords)
    {
        for (Entry<String, String[]> entry : jsonConvertedMap.entrySet())
        {
            if (category.equals(entry.getKey()))
            {
                for (String jsonCategoryContent : entry.getValue())
                {
                    selectedWords.add(jsonCategoryContent);
                }
            }
        }
        return selectedWords;
    }


    private Map<String, String[]> readWords()
    {
        ObjectMapper mapper = new ObjectMapper();
        JsonNode jsonNode = null;
        Map<String, String[]> jsonConvertedMap = new HashMap<String, String[]>();
        try
        {
            jsonNode = mapper.readTree(readFileContent());
            jsonConvertedMap = mapper.convertValue(jsonNode, new TypeReference<Map<String, String[]>>()
            {});

        }
        catch (Exception e)
        {
            e.printStackTrace();
        }
        return jsonConvertedMap;
    }


    private String readFileContent()
    {
        File cardFile = new File(pathToCards);
        FileInputStream inputStream;
        String str = null;
        try
        {
            inputStream = new FileInputStream(cardFile);
            byte[] data = new byte[(int)cardFile.length()];
            inputStream.read(data);
            inputStream.close();
            str = new String(data, "UTF-8");
        }
        catch (IOException e)
        {
            e.printStackTrace();
        }

        return str;
    }


    public void setPathToCards(String pathToCards)
    {
        this.pathToCards = pathToCards;
    }

}
