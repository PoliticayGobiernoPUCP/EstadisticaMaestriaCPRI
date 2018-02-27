##mapa provincas----
#minusculas y tudes
library(foreign)
mapa<-read.dbf("provinciasPeru.dbf")###tiene acentos y ñs 
#nota: no hay informacion de datem del marañon: lo voy a eliminar de las otras bases 

mapa$Provincia <- toupper(mapa$NAME_2) #crear nueva variable con mayusculas 
library(stringi) 
mapa$Provincia <- stri_trans_general(mapa$Provincia,"Latin-ASCII") #quitar tildes y ñs 

#HUANUCO está escrito como HUENUCO:
mapa$Provincia[mapa$Provincia == "HUENUCO"] <- "HUANUCO"

#ojo con Callao y con Carlos Fermin Fitzcarrald y Daniel Alcides Carrion que estan escritos de manera diferente en todas las bases

write.dbf(mapa, file="provinciasPeru.dbf")

#### idh Peru ----
#provincias en 2007 # minusculas y tildes
library(openxlsx)
idhPeru<- read.xlsx("idhPeru.xlsx",skipEmptyRows = T, skipEmptyCols = T, sheet=4, startRow = 5)

idhPeru <- idhPeru[-c(1435,2056:2061),]#eliminar filas innecesarias 
idhPeru <- idhPeru[is.na(idhPeru$X2),] #seleccionar provincias 
idhPeru <- idhPeru[,-c(2,5,7,9,11,13,15)]#eliminar columnas

colnames(idhPeru) <- c("Ubigeo", "Provincia", "habitantes", "IDH", "esperanza", "secundaria", "educa", "percapitaf")
rownames(idhPeru) <- 1:nrow(idhPeru)

idhPeru$Provincia <- toupper(idhPeru$Provincia) # mayusculas 
idhPeru$Provincia <- stri_trans_general(idhPeru$Provincia,"Latin-ASCII") #quitar tildes y ñs 
##Callao y Carlos Fermin estan bien. arreglar DANIEL A. CARRION
idhPeru$Provincia[idhPeru$Provincia == "DANIEL A. CARRION"] <- "DANIEL ALCIDES CARRION"
##Problema con Satipo:
idhPeru$Provincia[idhPeru$Provincia == "SATIPO 2/"] <- "SATIPO"

#eliminar datem del marañon
idhPeru <- idhPeru[!idhPeru$Provincia=="DATEM DEL MARANON",]

write.xlsx(idhPeru, "idhPeru.xlsx")

#### idh_elec----
#mayusculas sin tildes 
idh_elec <- read.csv("idh_elec.csv",strip.white = T,stringsAsFactors = F)
idh_elec <- as.data.frame(aggregate(cbind(PPK, FP) ~ ubiProv + prov, data = idh_elec, sum, na.rm = F))

colnames(idh_elec) <- c("Ubigeo", "Provincia", "Voto_PPK", "Voto_FP")
##Callao y Carlos Fermin estan bien. arreglar DANIEL A. CARRION
idh_elec$Provincia[idh_elec$Provincia == "DANIEL A. CARRION"] <- "DANIEL ALCIDES CARRION"

#eliminar datem del marañon
idh_elec <- idh_elec[!idh_elec$Provincia=="DATEM DEL MARANON",]

write.xlsx(idh_elec, "idh_elec.xlsx")


#### fecundidad----
#mayusculas y sin tildes  pero con ñs
fecundidad<- read.xlsx("fecundidad.xlsx",skipEmptyRows = T, skipEmptyCols = T, startRow = 3)

fecundidad$prov <- substr(fecundidad$Ubigeo,5,6) #identificar provincias y departamentos: 00
fecundidad$dep<- substr(fecundidad$Ubigeo,3,4) #identificar departamentos: 00
fecundidad<- fecundidad[!fecundidad$dep=="00" & fecundidad$prov=="00",][,c(1:5)] #seleccionar provincias

fecundidad<- fecundidad[complete.cases(fecundidad),]

colnames(fecundidad) <- c("Ubigeo", "Provincia", "mortalidadinf", "fecundidad", "desnutricion")
rownames(fecundidad) <- 1:nrow(fecundidad)

fecundidad[c(3:5)] =lapply(fecundidad[c(3:5)],as.numeric) #volverlas numericas 

fecundidad$Provincia <- stri_trans_general(fecundidad$Provincia,"Latin-ASCII") #quitar tildes y ñs 

##Callao está bien carlos fermin  esta como CARLOS F. FITZCARRALD transformar:
fecundidad$Provincia[fecundidad$Provincia == "CARLOS F. FITZCARRALD"] <- "CARLOS FERMIN FITZCARRALD"

#eliminar datem del marañon
fecundidad <- fecundidad[!fecundidad$Provincia=="DATEM DEL MARANON ",]

write.xlsx(fecundidad, "fecundidad.xlsx")


### indicadoresvarios ----
#minusculas con tildes 
indicadores<- read.xlsx("indicadoresvarios.xlsx",skipEmptyRows = T, skipEmptyCols = T, startRow = 7)

indicadores <- indicadores[,-c(1,4, 7: 14)]#eliminar columnas innecesarias

colnames(indicadores) <- c("Departamento", "Provincia", "densidadpob", "mortalidadinf", "analfabetismo", 
                           "analfabetismo_urb", "analfabetismo_rural", "analfabetismo_h", "analfabetismo_m") 
       
#analfabetismo rural está como caracter 
indicadores$analfabetismo_rural<- as.numeric(indicadores$analfabetismo_rural)

indicadores$Provincia <- toupper(indicadores$Provincia) #mayusculas 
indicadores$Provincia <- stri_trans_general(indicadores$Provincia,"Latin-ASCII") #quitar tildes y ñs 

#carlos fermin esta bien. arreglar callao:
indicadores$Provincia[indicadores$Provincia == "PROVINCIA CONSTITUCIONAL DEL CALLAO"] <- "CALLAO"

#eliminar datem del marañon
indicadores <- indicadores[!indicadores$Provincia=="DATEM DEL MARANON",]

write.xlsx(indicadores, "indicadoresvarios.xlsx")


### poblacion ----
#minusculas con tildes 
poblacion<- read.xlsx("poblacion.xlsx",skipEmptyRows = T, skipEmptyCols = T ,startRow = 7)

poblacion <- poblacion[,-c(1,4)]#eliminar columnas innecesarias
colnames(poblacion) <- c("Departamento", "Provincia", "pob", "pob_ur", "pob_rural", "pob_h", "pob_m")

poblacion$Provincia <- toupper(poblacion$Provincia) #mayusculas 
poblacion$Provincia <- stri_trans_general(poblacion$Provincia,"Latin-ASCII") #quitar tildes y ñs 

#carlos fermin esta bien. arreglar callao:
poblacion$Provincia[poblacion$Provincia == "PROVINCIA CONSTITUCIONAL DEL CALLAO"] <- "CALLAO"

#eliminar datem del marañon
poblacion <- poblacion[!poblacion$Provincia=="DATEM DEL MARANON",]

write.xlsx(poblacion, "poblacion.xlsx")


### ingreso per capita----
#minusculas con tildes
ingreso<- read.xlsx("Ingreso-Per-Capita.xlsx",skipEmptyRows = T, skipEmptyCols = T ,startRow = 3)
ingreso <- ingreso[is.na(ingreso$Distrito),] #eliminar distritos
ingreso <- ingreso[!is.na(ingreso$Provincia),] #seleccionar provincias

ingreso <- ingreso[,c(1:3,5)]#seleccionar columas 
colnames(ingreso) <- c("Ubigeo", "Departamento", "Provincia", "percapitaf")

ingreso$Provincia <- toupper(ingreso$Provincia) #mayusculas 
ingreso$Provincia <- stri_trans_general(ingreso$Provincia,"Latin-ASCII") #quitar tildes y ñs 

##No hay info de Callao y Carlos Fermin estan bien. arreglar DANIEL A. CARRION
ingreso$Provincia[ingreso$Provincia == "DANIEL A. CARRION"] <- "DANIEL ALCIDES CARRION"

#eliminar datem del marañon
ingreso <- ingreso[!ingreso$Provincia=="DATEM DEL MARANON",]

##Problema con Satipo:
ingreso$Provincia[ingreso$Provincia == "SATIPO 2/"] <- "SATIPO"

write.xlsx(ingreso, "Ingreso-Per-Capita.xlsx")

##Densidad Estado---- 
#minusculas con tildes
idePeru<- read.xlsx("idePeru.xlsx",skipEmptyRows = T, skipEmptyCols = T, sheet=4, startRow = 6)

idePeru <- idePeru[-c(221:224),]#eliminar filas innecesarias 
idePeru <- idePeru[is.na(idePeru$X2),] #seleccionar provincias 
idePeru <- idePeru[,-c(2,5,7,9,11,13,15,17)]#eliminar columnas innecesarias
colnames(idePeru) <- c("Ubigeo", "Provincia", "habitantes", "IDE", "identidad", "salud", "educacion", "saneamiento", "electrificacion")

idePeru$Provincia <- toupper(idePeru$Provincia) #mayusculas 
idePeru$Provincia <- stri_trans_general(idePeru$Provincia,"Latin-ASCII") #quitar tildes y ñs 
##Callao y Carlos Fermin estan bien. arreglar DANIEL A. CARRION
idePeru$Provincia[idePeru$Provincia == "DANIEL A. CARRION"] <- "DANIEL ALCIDES CARRION"
##Problema con Satipo:
idePeru$Provincia[idePeru$Provincia == "SATIPO 1/"] <- "SATIPO"

#eliminar datem del marañon
idePeru <- idePeru[!idePeru$Provincia=="DATEM DEL MARANON",]
write.xlsx(idePeru, "idePeru.xlsx")
