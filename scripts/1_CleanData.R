library(stringr)

dfDict <- read.csv("data/DicFra.csv", head=F, stringsAsFactors=F)
colnames(dfDict) <- c("word","definition")

dfDict[grep("n\\. m\\.", dfDict$definition, value=F), "gender"] <- 'm'
dfDict[grep("n\\. f\\.", dfDict$definition, value=F), "gender"] <- 'f'
#dual gender:
dfDictDuals <- dfDict[grep("n\\. m\\. et f\\.", dfDict$definition, value=F), ]
dfDictDuals$gender <- 'f'
dfDict <- rbind(dfDict, dfDictDuals) #duplicated as 'f'. The first grep already marked the originals as 'm'
rm(dfDictDuals)

#Drop all the others (non-nouns)
dfDict <- dfDict[complete.cases(dfDict), ]
dfDict <- dfDict[order(dfDict$word), ]
row.names(dfDict) <- NULL

dim(dfDict)


#Some more cleaning

dfDict$word <- (gsub("\\(.*\\)", "", dfDict$word))
dfDict$word <- (gsub("\\!$", "", dfDict$word))
dfDict$word <- (gsub("'$", "", dfDict$word))
dfDict$word <- str_trim(dfDict$word)

dfDict$word <- tolower(dfDict$word)

#Most-detailed diacritic version
dfDict$actualWord <- gsub("[\\{\\}]","",str_extract(dfDict$definition, "^\\{.*\\}"))
dfDict$actualWord[is.na(dfDict$actualWord)] <- dfDict$word[is.na(dfDict$actualWord)]

#apply the same cleaning

dfDict$actualWord <- (gsub("\\(.*\\)", "", dfDict$actualWord))
dfDict$actualWord <- (gsub("\\!$", "", dfDict$actualWord))
dfDict$actualWord <- (gsub("'$", "", dfDict$actualWord))
dfDict$actualWord <- str_trim(dfDict$actualWord)

dfDict$actualWord <- tolower(dfDict$actualWord)

#No-diacritic version
dfDict$simplifiedWord <- iconv(dfDict$actualWord, to="ASCII//TRANSLIT")

dfDict$definition <- NULL   	#not needed any more
dfDict <- dfDict[, c(1,3,4,2)]	#reordering columns

write.csv(dfDict, "data/taggedWordList.csv", row.names=F, quote=F)

dim(dfDict)




