
import java.net.*;
import java.io.*;

/*
Sample quoey url

http://www.netfonds.no/quotes/tradedump.php?date=20150424&paper=MON.N&csv_format=csv

http://www.netfonds.no/quotes/posdump.php?date=20150424&paper=MON.N&csv_format=csv

quoteGE.N0423.csv

tradeGE.N0423.csv

Usage:

java TickDL [quote or trade] YYYY MMDD sym

example: java TickDL quote 2015 0501 C.N

*/

public class TickDL {

        public static void main(String[] args) throws Exception {

                if( args.length!=4 ){
                        System.out.println("Usage: java TickDL [quote or trade] YYYY MMDD sym");
                        return;
                }

                //Get the command line arguments.
                String tbl = args[0];
                String year = args[1];
                String dt = args[2];
                String sym = args[3];

                String tradeurl = "http://www.netfonds.no/quotes/tradedump.php?date="
                        + year + dt +  "&paper=" + sym +"&csv_format=csv";

                String quoteurl = "http://www.netfonds.no/quotes/posdump.php?date="
                        + year + dt +  "&paper=" + sym +"&csv_format=csv";

                String queryUrl = "quote".equals(tbl) ? quoteurl:tradeurl;

                URL netfonds = new URL(queryUrl);
                URLConnection nf = netfonds.openConnection();

                BufferedReader in = new BufferedReader(new InputStreamReader(nf.getInputStream()));

                String inputLine;
                while ((inputLine = in.readLine()) != null)
                        System.out.println(inputLine);
                in.close();
        }

}
