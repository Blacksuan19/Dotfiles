# some defaults.
USER_AGENT='Mozilla/5.0'
CURL="curl -s -A '$USER_AGENT'";

# This is used to get the url for the lyrics
function google { 
    Q="$@"
    GOOG_URL='https://www.google.com/search?tbs=li:1&q='
    AGENT="Mozilla/4.0"
    stream=$(curl -A "$AGENT" -skLm 10 "${GOOG_URL}${Q//\ /+}")
    echo "$stream" | grep -o "href=\"/url[^\&]*&amp;" | sed 's/href=".url.q=\([^\&]*\).*/\1/'
}

# Get the lyrics from plyrics
function do_it_plyrics() {

    ALL=$(google "$1 $2 lyrics site:plyrics.com");
    URL="$(echo $ALL | tr ' ' '\n' | grep "plyrics.com" -m 1)";
    if [[ -z "$URL" ]];then
        echo "There were no plyrics.com results. Giving up now :(";
        exit 0;
    fi
    # Print the artist and title we are going to look up
    echo -e "($URL) $1 - $2: ";
    RESULT="$($CURL $URL | awk '/start of lyric/, /end of lyric/' \
        | perl -pe 's/<.*?>//g' \
        | sed 's/^\s*//' \
        | sed 's/’//g' \
        | sed 's/‘//g' \
        | sed 's/”/"/g' \
        | sed 's/“/"/g' \
        | sed 's/…/.../g' \
        | sed 's/[fF][uU][cC][kK]/[32mF***[39m/g' \
        | sed 's/[sS][hH][iI][tT]/[32mS***[39m/g' \
        | sed "s/&#039;/'/g" \
        | sed 's/&rsquo;//g' \
        | sed 's/&quot;//g' \
        | uniq
    )"



    # If we didn't get anything, lets give up. This is the last option.
    if [[ -z "$RESULT" ]];then
        echo "That URL sucked. Giving up now :(";
        exit 0;

    # We found something
    else
        echo "$RESULT"
    fi

}

# Get the lyrics of a song by googling it, and parsing result pages
function do_it_songLyrics() {
    
    ALL=$(google "$1 $2 lyrics site:songlyrics.com");
    URL="$(echo $ALL | tr ' ' '\n' | grep "songlyrics.com" -m 1)";
    if [[ -z "$URL" ]];then
        echo "There were no songlyrics.com results. Trying plyrics now...";
        do_it_plyrics "$1" "$2"
        exit 0;
    fi
    # Print the artist and title we are going to look up
    echo -e "($URL) $1 - $2: ";
    RESULT="$($CURL $URL | awk '/<p id=\"songLyricsDiv\"/, /<\/p>/' \
        | perl -pe 's/<.*?>//g' \
        | sed 's/^\s*//' \
        | sed 's/’//g' \
        | sed 's/‘//g' \
        | sed 's/”/"/g' \
        | sed 's/“/"/g' \
        | sed 's/…/.../g' \
        | sed 's/[fF][uU][cC][kK]/[32mF***[39m/g' \
        | sed 's/[sS][hH][iI][tT]/[32mS***[39m/g' \
        | sed "s/&#039;/'/g" \
        | sed 's/&rsquo;//g' \
        | sed 's/&quot;//g' \
        | uniq
    )"



    # If we didn't get anything, lets give up. This is the last option.
    if [[ -z "$RESULT" ]];then
        echo "That URL sucked. Trying plyrics now..."
        do_it_plyrics "$1" "$2"
        exit 0;

    # We found something
    else
        echo "$RESULT"
    fi

}

# The a-z lyrics method
function do_it_azlyrics() {
    
        # Or, lets google it and get one
        ALL=$(google "$1 $2 lyrics site:azlyrics.com");
        URL="$(echo $ALL | tr ' ' '\n' | grep "azlyrics.com" -m 1)";
    if [[ -z "$URL" ]];then
        echo "There was no azlyrics.com results. Lets try songlyrics.com...";
        #do_it_azlyrics "$1" "$2"
        do_it_songLyrics "$1" "$2"
        exit 0;
    fi

    # Print the artist and title we are going to look up
    echo -e "($URL) $1 - $2: ";
    RESULT="$($CURL $URL \
        | awk '/<!-- Usage of azlyrics.com content by any third-party lyrics provider is prohibited by our licensing agreement. Sorry about that. -->/, /<\/div>/' \
        | perl -pe 's/<.*?>//g' \
        | sed 's/^\s*//' \
        | sed 's/’//g' \
        | sed 's/‘//g' \
        | sed 's/”/"/g' \
        | sed 's/“/"/g' \
        | sed 's/…/.../g' \
        | sed 's/[fF][uU][cC][kK]/[32mF***[39m/g' \
        | sed 's/[sS][hH][iI][tT]/[32mS***[39m/g' \
        | sed "s/&#039;/'/g" \
        | sed 's/&rsquo;//g' \
        | sed 's/&quot;//g' \
        | uniq
    )";


    # See if that worked, if it didn't, lets try songLyrics
    if [[ -z "$RESULT" ]];then
        echo "That URL sucked. Lets try songlyrics.com...";
        do_it_songLyrics "$1" "$2"
        exit 0;

    # We found something, print it
    else
        echo "$RESULT"
    fi


}
# Look up the title and artist in spotify, Sets the global ARTIST and TITLE varibles
function lookupSpotifyInfo() {
    # Checks $OSTYPE to determine the proper command for artist/title query
    if [[ "$OSTYPE" == "linux-gnu" ]];then
      ARTIST="$(dbus-send --print-reply --session --dest=org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 org.freedesktop.DBus.Properties.Get string:'org.mpris.MediaPlayer2.Player' string:'Metadata' | grep -A 3 artist | grep string | grep -v xesam | sed 's/^\s*//' | cut -d ' ' -f 2- | tr '(' ' ' | tr ')' ' ' | tr '"' ' ' )";

      TITLE="$(dbus-send --print-reply --session --dest=org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 org.freedesktop.DBus.Properties.Get string:'org.mpris.MediaPlayer2.Player' string:'Metadata' | grep -A 3 title | grep string | grep -v xesam | sed 's/^\s*//' | sed 's/^variant\s*//' | cut -d ' ' -f 2- | tr '(' ' ' | tr ')' ' ' | tr '"' ' ' )";

    elif [[ "$OSTYPE" == "darwin"* ]];then
      ARTIST="$(osascript -e 'tell application "Spotify" to artist of current track as string')";

      TITLE="$(osascript -e 'tell application "Spotify" to name of current track as string')";

    else
      echo "Your OS doesn't appear to be supported"
    fi

    if [[ -z "$ARTIST" || -z "$TITLE" ]];then
        echo "There was a problem getting the currently playing info from spotify";
        exit 1;
    fi

}
# look up the lyrics from the currently playing spotify song
if [[ "$1" == 'spotify' ]]; then
    # Sets the global ARTIST and TITLE vars
    lookupSpotifyInfo
    echo "Looking up title by Spotify artist and title...";
    echo "Artist: $ARTIST";
    echo "Title: $TITLE";

    do_it_azlyrics "$ARTIST" "$TITLE"
    exit 0;
fi
