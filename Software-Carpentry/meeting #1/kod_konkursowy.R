# Na zakończenie warsztatów został zrobiony konkurs, którego główną nagrodą była książka "Przewodnik po pakiecie R".
# Zasady były bardzo proste:
# - każdy z uczestników miał za zadanie skopiować GitHubowego repozytorium prowadzącego
# - w repozytorium należało utowrzyć plik tekstowy o nazwie identyfikującej jednoznacznie uczestnika. Plik tekstowy miał zawierać liczbę z zakresu 1 do 1000
# - na koniec należało wykonać pull request na repozytorium prowadzącego
# - poniższy kod R pobiera ze strony GitHub.com pliki wysłane przez uczestników
# - wartości z pobranych plików są sumowane i suma ta jest ziarnem generatora losowego
# - na końcu następuje wylosowanie jednego z uczestników za pomocą funkcji sample



# Pakiety -----------------------------------------------------------------

#install.packages("rvest")          poruszanie się po treściach stron www
#install.packages("downloader")     pobieranie plików (dobre zarządzanie przekierowaniami, z czym nie radzi sobie funkcja wbudowana)

library(rvest)
library(downloader)

# Linki do plików ---------------------------------------------------------

link_prefix <- "https://www.github.com"
link        <- "https://github.com/klemensnoga/SwC-eRka-2016-03-12"

s <- html_session(link) # pobranie treści www ze strony link i wielu innych atrybutów

linki <- html_nodes(s, "tr") %>% .[-1] %>% 
            html_nodes(".content") %>% 
            html_node("a") %>% 
            html_attr("href") %>% 
            paste0(link_prefix, .) %>% 
            gsub("blob", "raw", .) # PIĘKNO rvest !!!
linki <- linki[grepl(".txt$", linki)] # tylko pliki z rozszerzeniem .txt

# Pobranie plików ---------------------------------------------------------

# invisible jest po to aby nie zwracało wyniku działania funkcji lapply
invisible(lapply(linki, function(x) download(x, paste0("pliki/", gsub(".*/", "", x))))) 

# Wczytanie wartości z plików i ich zsumowanie ----------------------------

lista_plikow <- list.files("pliki", full.names = TRUE)

# nie przejmujemy się tym jak ktoś niepoprawnie uzupełnił plik tekstowy, po prostu wartość nie zostanie uwzględniona
ziarno <- sum(sapply(lista_plikow, function(x) as.numeric(readLines(x, n=1, warn = FALSE))), na.rm = TRUE) 

# Losowanie ---------------------------------------------------------------

uczestnicy <- c("Janek", "Franek", "Maniek", "Krystyna", "Malina")

set.seed(ziarno)

print(paste0("Konkurs wygrał(a) '", sample(uczestnicy, 1), "' GRATULACJE!!!"))
