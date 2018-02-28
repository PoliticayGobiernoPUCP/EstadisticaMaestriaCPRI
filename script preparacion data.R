##mapa provincas----
#minusculas y tudes
library(foreign)
mapa<-read.dbf("PROVINCIAsPeru.dbf")###tiene problemas en los caracteres 

mapa$PROVINCIA <- gsub("\xd1", "N", mapa$PROVINCIA) #solucionar problema de encoding 

#ojo con Callao, Carlos Fermin Fitzcarrald y Daniel Alcides Carrion que estan escritos de manera diferente en todas las bases

write.dbf(mapa, file="PROVINCIAsPeru.dbf")

#### idh Peru ----
#PROVINCIAs en 2007 # minusculas y tildes
library(openxlsx)
idhPeru<- read.xlsx("idhPeru.xlsx",skipEmptyRows = T, skipEmptyCols = T, sheet=4, startRow = 5)

idhPeru <- idhPeru[-c(1435,2056:2061),]#eliminar filas innecesarias 
idhPeru <- idhPeru[is.na(idhPeru$X2),] #seleccionar PROVINCIAs 
idhPeru <- idhPeru[,-c(2,5,7,9,11,13,15)]#eliminar columnas

colnames(idhPeru) <- c("Ubigeo", "PROVINCIA", "habitantes", "IDH", "esperanza", "secundaria", "educa", "percapitaf")
rownames(idhPeru) <- 1:nrow(idhPeru)

idhPeru$PROVINCIA <- toupper(idhPeru$PROVINCIA) # mayusculas 
idhPeru$PROVINCIA <- stri_trans_general(idhPeru$PROVINCIA,"Latin-ASCII") #quitar tildes y ñs 

##Callao y Carlos Fermin estan bien. arreglar DANIEL A. CARRION
idhPeru$PROVINCIA[idhPeru$PROVINCIA == "CARLOS FERMIN FITZCARRALD"] <- "CARLOS F. FITZCARRALD"
idhPeru$PROVINCIA[idhPeru$PROVINCIA == "DANIEL A. CARRION"] <- "DANIEL ALCIDES CARRION"
##Problema con Satipo:
idhPeru$PROVINCIA[idhPeru$PROVINCIA == "SATIPO 2/"] <- "SATIPO"

write.xlsx(idhPeru, "idhPeru.xlsx")

#### idh_elec----
#mayusculas sin tildes 
idh_elec <- read.csv("idh_elec.csv",strip.white = T,stringsAsFactors = F)
idh_elec <- as.data.frame(aggregate(cbind(PPK, FP) ~ ubiProv + prov, data = idh_elec, sum, na.rm = F))

colnames(idh_elec) <- c("Ubigeo", "PROVINCIA", "Voto_PPK", "Voto_FP")
##Callao y Carlos Fermin estan bien. arreglar DANIEL A. CARRION
idh_elec$PROVINCIA[idh_elec$PROVINCIA == "DANIEL A. CARRION"] <- "DANIEL ALCIDES CARRION"
idh_elec$PROVINCIA[idh_elec$PROVINCIA == "CARLOS FERMIN FITZCARRALD"] <- "CARLOS F. FITZCARRALD"

write.xlsx(idh_elec, "idh_elec.xlsx")


#### fecundidad----
#mayusculas y sin tildes  pero con ñs
fecundidad<- read.xlsx("fecundidad.xlsx",skipEmptyRows = T, skipEmptyCols = T, startRow = 3)

fecundidad$prov <- substr(fecundidad$Ubigeo,5,6) #identificar PROVINCIAs y departamentos: 00
fecundidad$dep<- substr(fecundidad$Ubigeo,3,4) #identificar departamentos: 00
fecundidad<- fecundidad[!fecundidad$dep=="00" & fecundidad$prov=="00",][,c(1:5)] #seleccionar PROVINCIAs

fecundidad<- fecundidad[complete.cases(fecundidad),]

colnames(fecundidad) <- c("Ubigeo", "PROVINCIA", "mortalidadinf", "fecundidad", "desnutricion")
rownames(fecundidad) <- 1:nrow(fecundidad)

fecundidad[c(3:5)] =lapply(fecundidad[c(3:5)],as.numeric) #volverlas numericas 

fecundidad$PROVINCIA <- stri_trans_general(fecundidad$PROVINCIA,"Latin-ASCII") #quitar tildes y ñs 

#solucionar problema con datem del maranon 

fecundidad[fecundidad$PROVINCIA=="DATEM DEL MARANON ",] <- "DATEM DEL MARANON"

write.xlsx(fecundidad, "fecundidad.xlsx")


### indicadoresvarios ----
#minusculas con tildes 
indicadores<- read.xlsx("indicadoresvarios.xlsx",skipEmptyRows = T, skipEmptyCols = T, startRow = 7)

indicadores <- indicadores[,-c(1,4, 7: 14)]#eliminar columnas innecesarias

colnames(indicadores) <- c("Departamento", "PROVINCIA", "densidadpob", "mortalidadinf", "analfabetismo", 
                           "analfabetismo_urb", "analfabetismo_rural", "analfabetismo_h", "analfabetismo_m") 
       
#analfabetismo rural está como caracter 
indicadores$analfabetismo_rural<- as.numeric(indicadores$analfabetismo_rural)

indicadores$PROVINCIA <- toupper(indicadores$PROVINCIA) #mayusculas 
indicadores$PROVINCIA <- stri_trans_general(indicadores$PROVINCIA,"Latin-ASCII") #quitar tildes y ñs 

#carlos fermin esta bien. arreglar callao:
indicadores$PROVINCIA[indicadores$PROVINCIA == "PROVINCIA CONSTITUCIONAL DEL CALLAO"] <- "CALLAO"
indicadores$PROVINCIA[indicadores$PROVINCIA == "CARLOS FERMIN FITZCARRALD"] <- "CARLOS F. FITZCARRALD"

write.xlsx(indicadores, "indicadoresvarios.xlsx")


### poblacion ----
#minusculas con tildes 
poblacion<- read.xlsx("poblacion.xlsx",skipEmptyRows = T, skipEmptyCols = T ,startRow = 7)

poblacion <- poblacion[,-c(1,4)]#eliminar columnas innecesarias
colnames(poblacion) <- c("Departamento", "PROVINCIA", "pob", "pob_ur", "pob_rural", "pob_h", "pob_m")

poblacion$PROVINCIA <- toupper(poblacion$PROVINCIA) #mayusculas 
poblacion$PROVINCIA <- stri_trans_general(poblacion$PROVINCIA,"Latin-ASCII") #quitar tildes y ñs 

#carlos fermin esta bien. arreglar callao:
poblacion$PROVINCIA[poblacion$PROVINCIA == "PROVINCIA CONSTITUCIONAL DEL CALLAO"] <- "CALLAO"
poblacion$PROVINCIA[poblacion$PROVINCIA == "CARLOS FERMIN FITZCARRALD"] <- "CARLOS F. FITZCARRALD"

write.xlsx(poblacion, "poblacion.xlsx")


### ingreso per capita----
#minusculas con tildes
ingreso<- read.xlsx("Ingreso-Per-Capita.xlsx",skipEmptyRows = T, skipEmptyCols = T ,startRow = 3)
ingreso <- ingreso[is.na(ingreso$Distrito),] #eliminar distritos
ingreso <- ingreso[!is.na(ingreso$Provincia),] #seleccionar PROVINCIAs

ingreso <- ingreso[,c(1:3,5)]#seleccionar columas 
colnames(ingreso) <- c("Ubigeo", "Departamento", "PROVINCIA", "percapitaf")

ingreso$PROVINCIA <- toupper(ingreso$PROVINCIA) #mayusculas 
ingreso$PROVINCIA <- stri_trans_general(ingreso$PROVINCIA,"Latin-ASCII") #quitar tildes y ñs 

##No hay info de Callao y Carlos Fermin estan bien. arreglar DANIEL A. CARRION
ingreso$PROVINCIA[ingreso$PROVINCIA == "DANIEL A. CARRION"] <- "DANIEL ALCIDES CARRION"
ingreso$PROVINCIA[ingreso$PROVINCIA == "CARLOS FERMIN FITZCARRALD"] <- "CARLOS F. FITZCARRALD"

##Problema con Satipo:
ingreso$PROVINCIA[ingreso$PROVINCIA == "SATIPO 2/"] <- "SATIPO"

write.xlsx(ingreso, "Ingreso-Per-Capita.xlsx")

##Densidad Estado---- 
#minusculas con tildes
idePeru<- read.xlsx("idePeru.xlsx",skipEmptyRows = T, skipEmptyCols = T, sheet=4, startRow = 6)

idePeru <- idePeru[-c(221:224),]#eliminar filas innecesarias 
idePeru <- idePeru[is.na(idePeru$X2),] #seleccionar PROVINCIAs 
idePeru <- idePeru[,-c(2,5,7,9,11,13,15,17)]#eliminar columnas innecesarias
colnames(idePeru) <- c("Ubigeo", "PROVINCIA", "habitantes", "IDE", "identidad", "salud", "educacion", "saneamiento", "electrificacion")

idePeru$PROVINCIA <- toupper(idePeru$PROVINCIA) #mayusculas 
idePeru$PROVINCIA <- stri_trans_general(idePeru$PROVINCIA,"Latin-ASCII") #quitar tildes y ñs 
##Callao y Carlos Fermin estan bien. arreglar DANIEL A. CARRION
idePeru$PROVINCIA[idePeru$PROVINCIA == "DANIEL A. CARRION"] <- "DANIEL ALCIDES CARRION"
idePeru$PROVINCIA[idePeru$PROVINCIA == "CARLOS FERMIN FITZCARRALD"] <- "CARLOS F. FITZCARRALD"

##Problema con Satipo:
idePeru$PROVINCIA[idePeru$PROVINCIA == "SATIPO 1/"] <- "SATIPO"

write.xlsx(idePeru, "idePeru.xlsx")

d3<-merge(mapa,poblacion, by.x="PROVINCIA", sort=FALSE, all.x = T, all.y = T) 


