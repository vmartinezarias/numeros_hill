# Números de Hill usando iNEXT
# Hecho por: Víctor M. Martínez-Arias
# Contacto: vmmartineza@unal.edu.co

#Instalar iNEXT
install.packages("iNEXT")

#DEFINIR CARPETA DONDE SE ENCUENTRAN LOS .CSV:
# Configuración directorio base (donde van los datos a procesar, y donde salen las gráficas que producidermos)

setwd("... Archivos de entrada/")  #poner la ubicación de los archivos de entrada

# Cargar paquetes requeridos 
require(iNEXT)
library(ggplot2)

# Para construir una curva de acumulación, usando datos de abundancia
datos<-read.csv2("abundancias_curva.csv", sep=",") # datos de muestra
View(datos)
curva<-iNEXT(datos, q=0, datatype="abundance", size=NULL, endpoint=NULL, knots=50, se=TRUE, conf=0.95, nboot=50)
curvaplot<-ggiNEXT(curva, type=1, se=TRUE, facet.var="none", color.var="site", grey=FALSE)
curvaplot + labs(x = "Unidad de muestreo", y = "Diversidad de especies")
curvaplot 


#Para graficar la completitud del muestreo
completitud<-ggiNEXT(curva, type=2, facet.var="none", color.var="site", se=FALSE)
completitud + labs(x = "Unidad de muestreo", y = "Cobertura del muestreo")

#Para graficar la cobertura del muestreo
cobertura<-ggiNEXT(curva, type=3, facet.var="none", color.var="site", se=FALSE)
cobertura+ labs(x = "Cobertura de muestreo", y = "Diversidad de especies")

#Para visualizar las tres curvas (riqueza, shannon, simpson) al mismo tiempo:
trescurvas <- iNEXT(datos, q=c(0, 1, 2), datatype="abundance")
graficatrescurvas<-ggiNEXT(trescurvas, type=1, facet.var="order", color.var="site")
graficatrescurvas


# OBTENCIÓN DE LOS ÍNDICES Y EXPORTACIÓN DE LOS DATOS

curva #te saca los índices
# OBTENCIÓN DE LOS ÍNDICES Y EXPORTACIÓN DE LOS DATOS
indices.nombres<-cbind("Riqueza de especies","Especies comunes (Shannon)", "Especies raras (Simpson)")
Nsitios<-ncol(datos)
indices<-rep(indices.nombres,Nsitios)
yda<-cbind(colnames(curva))
ydear<-yda[rep(seq_len(nrow(yda)),each=3)]
Sitio<-as.character(ydear)
Diversidad<-as.character(indices)
Observada<-curvaestacion_abund$AsyEst$Observed
Esperada<-curvaestacion_abund$AsyEst$Estimator
Desviacion<-curvaestacion_abund$AsyEst$s.e.
TablaDat<-data.frame(cbind(Sitio,Diversidad,Observada,Esperada,Desviacion))
write.table(TablaDat, "indicesXunidad.csv", sep=",", row.names = FALSE)
#Calculo de porcentajes
totalrow<-(nrow(TablaDat)-2)
Obs<-as.data.frame(TablaDat[totalrow,"Observada"])
rownames(Obs)<-c("a")
colnames(Obs)<-c("b")
obser<-as.character(Obs[1,1])
observado<-as.numeric(obser)
Esp<-as.data.frame(TablaDat[totalrow,"Esperada"])
rownames(Esp)<-c("a")
colnames(Esp)<-c("b")
esper<-as.character(Esp[1,1])
esperado<-as.numeric(esper)

write.table(curva["AsyEst"], "ubicacionarchivos/indices.txt", sep="\t")